import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/models/appointment_model.dart';
import 'package:nurahelp/app/data/models/clinical_response.dart';
import 'package:nurahelp/app/data/models/patient_model.dart';
import 'package:nurahelp/app/data/models/settings_model/settings_model.dart';
import 'package:nurahelp/app/data/services/app_service.dart';
import 'package:nurahelp/app/data/services/cache_service.dart';
import 'package:nurahelp/app/data/services/network_manager.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/features/main/controllers/symptom_insight_controller/symptom_insight_controller.dart';
import 'package:nurahelp/app/routes/app_routes.dart';

class DashboardController extends GetxController {
  static DashboardController get instance => Get.find();

  final appService = AppService.instance;
  final cacheService = CacheService.instance;
  final patientController = Get.find<PatientController>();
  final symptomController = Get.find<SymptomInsightController>();
  final hasNoInternet = false.obs;
  final isLoading = false.obs;
  final lastUpdated = Rxn<DateTime>();
  final hasError = false.obs;
  final networkManager = AppNetworkManager.instance;

  @override
  void onInit() {
    super.onInit();
    _initializeDashboard();
  }

  Future<void> _initializeDashboard() async {
    // 1. FAST-START: Immediately load whatever is in the cache
    _hydrateFromCache();

    // 2. FETCH FRESH: Parallel network calls
    await refreshDashboardData();
  }

  void _hydrateFromCache() {
    final cachedPatient = cacheService.getCachedPatient();
    if (cachedPatient != null) {
      final patient = PatientModel.fromJson(cachedPatient);
      // Populate clinical data if cached
      final cachedClinical = cacheService.getCachedClinicalData();
      if (cachedClinical != null) {
        patient.clinicalResponse = ClinicalResponse.fromJson(cachedClinical);
      }
      patientController.patient.value = patient;
    }
  }

  Future<void> refreshDashboardData() async {
    try {
      // 1. Check current connectivity
      final isConnected = await networkManager.isConnected();

      if (!isConnected) {
        // 3. Update the state: This immediately triggers the UI change
        hasNoInternet.value = true;
        isLoading.value = false;
        return;
      }

      isLoading.value = true;
      hasNoInternet.value = false;
      hasError.value = false;

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      // PARALLEL EXECUTION (The Promise.all equivalent)
      // We run all three network requests simultaneously
      final results = await Future.wait([
        appService.fetchPatientRecord(currentUser),
        appService.fetchAppointments(currentUser),
        appService.fetchPatientSettings(currentUser),
        appService.getClinicalData(user: currentUser),
        symptomController.fetchSymptoms(), // Also run this in parallel
      ]);

      final patient = results[0] as PatientModel;
      final freshAppointments = results[1] as List<AppointmentModel>;
      final settings = results[2] as SettingsModel;
      final clinicalInfo = results[3] as ClinicalResponse;

      // Check OTP Status
      if (!patient.isComplete) {
        Get.offAllNamed(
          AppRoutes.otpVerification,
          arguments: currentUser.email,
        );
        return;
      }

      // Update State (Single Source of Truth)
      patient.clinicalResponse = clinicalInfo;
      patientController.patient.value = patient;
      patientController.patient.value.appointments = freshAppointments;
      patientController.patient.refresh();

      // Map settings to controller
      patientController.enableMessageAlerts.value =
          settings.notifications.messageAlerts;
      patientController.enableAppointmentReminders.value =
          settings.notifications.appointmentReminders;
      patientController.enable2Fa.value = settings.security.twoFactorAuth;

      // Persist to Cache (Update background storage)
      await cacheService.cachePatient(patient.toJson());
      await cacheService.cacheSettings(settings.toJson());
      await cacheService.cacheClinicalData(clinicalInfo.toJson());

      lastUpdated.value = DateTime.now();
    } catch (e) {
      hasError.value = true;
      Get.snackbar(
        "Sync Warning",
        "Showing offline data. Check your connection.",
      );
    } finally {
      isLoading.value = false;
    }
  }
}
