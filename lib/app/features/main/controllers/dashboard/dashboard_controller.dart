import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/services/app_service.dart';
import 'package:nurahelp/app/data/services/network_manager.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/features/main/controllers/symptom_insight_controller/symptom_insight_controller.dart';
import 'package:nurahelp/app/routes/app_routes.dart';

/// Controller for dashboard to fetch data on first load
class DashboardController extends GetxController {
  static DashboardController get instance => Get.find();

  final appService = AppService.instance;
  final patientController = Get.find<PatientController>();
  final symptomController = Get.find<SymptomInsightController>();
  final isLoading = true.obs;
  final hasError = false.obs;
  final hasNetworkTimeout = false.obs;
  final hasNoInternet = false.obs; // New: Track no internet

  late AppNetworkManager networkManager;

  static const int networkTimeoutSeconds = 90; // 1.5 minutes

  @override
  void onInit() {
    super.onInit();
    try {
      networkManager = Get.find<AppNetworkManager>();
    } catch (e) {
      networkManager = AppNetworkManager();
    }
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      hasNetworkTimeout.value = false;
      hasNoInternet.value = false;

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        hasError.value = true;
        return;
      }

      // Check internet before fetching
      final isConnected = await networkManager.isConnected();
      if (!isConnected) {
        hasNoInternet.value = true;
        isLoading.value = false;
        return;
      }

      // Fetch all data with timeout (will use cache if available)
      final patient = await appService
          .fetchPatientRecord(currentUser)
          .timeout(
            const Duration(seconds: networkTimeoutSeconds),
            onTimeout: () {
              hasNetworkTimeout.value = true;
              throw Exception('Network timeout - unstable internet connection');
            },
          );
      final settings = await appService
          .fetchPatientSettings(currentUser)
          .timeout(
            const Duration(seconds: networkTimeoutSeconds),
            onTimeout: () {
              hasNetworkTimeout.value = true;
              throw Exception('Network timeout - unstable internet connection');
            },
          );
      final clinicalInfo = await appService
          .getClinicalData(user: currentUser)
          .timeout(
            const Duration(seconds: networkTimeoutSeconds),
            onTimeout: () {
              hasNetworkTimeout.value = true;
              throw Exception('Network timeout - unstable internet connection');
            },
          );

      // Check if user needs to complete OTP verification
      if (!patient.isComplete) {
        isLoading.value = false;
        Get.offAllNamed(
          AppRoutes.otpVerification,
          arguments: currentUser.email,
        );
        return;
      }

      // Update patient controller
      patient.clinicalResponse = clinicalInfo;
      patientController.patient.value = patient;
      patientController.enableMessageAlerts.value =
          settings.notifications.messageAlerts;
      patientController.enableAppointmentReminders.value =
          settings.notifications.appointmentReminders;
      patientController.enable2Fa.value = settings.security.twoFactorAuth;

      // Fetch symptoms data
      await symptomController.fetchSymptoms();
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshDashboardData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      hasNetworkTimeout.value = false;
      hasNoInternet.value = false;

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      // Check internet before fetching
      final isConnected = await networkManager.isConnected();
      if (!isConnected) {
        hasNoInternet.value = true;
        isLoading.value = false;
        return;
      }

      final patient = await appService
          .fetchPatientRecord(currentUser, forceRefresh: true)
          .timeout(
            const Duration(seconds: networkTimeoutSeconds),
            onTimeout: () {
              hasNetworkTimeout.value = true;
              throw Exception('Network timeout - unstable internet connection');
            },
          );
      final settings = await appService
          .fetchPatientSettings(currentUser, forceRefresh: true)
          .timeout(
            const Duration(seconds: networkTimeoutSeconds),
            onTimeout: () {
              hasNetworkTimeout.value = true;
              throw Exception('Network timeout - unstable internet connection');
            },
          );
      final clinicalInfo = await appService
          .getClinicalData(user: currentUser, forceRefresh: true)
          .timeout(
            const Duration(seconds: networkTimeoutSeconds),
            onTimeout: () {
              hasNetworkTimeout.value = true;
              throw Exception('Network timeout - unstable internet connection');
            },
          );

      patient.clinicalResponse = clinicalInfo;
      patientController.patient.value = patient;
      patientController.enableMessageAlerts.value =
          settings.notifications.messageAlerts;
      patientController.enableAppointmentReminders.value =
          settings.notifications.appointmentReminders;
      patientController.enable2Fa.value = settings.security.twoFactorAuth;

      // Refresh symptoms data
      await symptomController.fetchSymptoms();
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}
