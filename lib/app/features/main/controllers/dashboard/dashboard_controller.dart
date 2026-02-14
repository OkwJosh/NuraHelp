import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/models/appointment_model.dart';
import 'package:nurahelp/app/data/models/clinical_response.dart';
import 'package:nurahelp/app/data/models/patient_model.dart';
import 'package:nurahelp/app/data/models/settings_model/settings_model.dart';
import 'package:nurahelp/app/data/services/app_service.dart';
import 'package:nurahelp/app/data/services/cache_service.dart';
import 'package:nurahelp/app/data/services/network_manager.dart';
import 'package:nurahelp/app/data/services/notification_service.dart';
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

  // Track previous clinical data counts for change detection
  int _previousMedicationCount = -1;
  int _previousTestResultCount = -1;

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

      // ─── NOTIFICATION WIRING ──────────────────────────────────────
      _scheduleNotifications(
        appointments: freshAppointments,
        clinicalInfo: clinicalInfo,
        settings: settings,
      );

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

  /// Silently refresh appointments without showing loading state.
  /// Called when returning from other screens (e.g. Nura Assistant).
  Future<void> silentRefreshAppointments() async {
    try {
      final isConnected = await networkManager.isConnected();
      if (!isConnected) return;

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final freshAppointments = await appService.fetchAppointments(currentUser);
      patientController.patient.value.appointments = freshAppointments;
      patientController.patient.refresh();

      // Re-schedule appointment reminders if enabled
      if (patientController.enableAppointmentReminders.value) {
        try {
          NotificationService.instance.scheduleAllAppointmentReminders(
            freshAppointments,
          );
        } catch (e) {
          debugPrint(
            '⚠️ Silent appointment notification scheduling failed: $e',
          );
        }
      }
    } catch (e) {
      debugPrint('⚠️ Silent appointment refresh failed: $e');
    }
  }

  // ─── NOTIFICATION HELPERS ──────────────────────────────────────

  void _scheduleNotifications({
    required List<AppointmentModel> appointments,
    required ClinicalResponse clinicalInfo,
    required SettingsModel settings,
  }) {
    try {
      final notificationService = NotificationService.instance;

      // 1. APPOINTMENT REMINDERS
      if (settings.notifications.appointmentReminders) {
        notificationService.scheduleAllAppointmentReminders(appointments);
        debugPrint('📅 [Dashboard] Scheduled appointment reminders');
      }

      // 2. DAILY SYMPTOM LOG REMINDERS
      notificationService.startDailySymptomReminder();
      debugPrint('⏰ [Dashboard] Daily symptom reminder enabled');

      // 3. NEW MEDICATION / TEST RESULT DETECTION
      _detectNewClinicalRecords(clinicalInfo);
    } catch (e) {
      debugPrint('⚠️ [Dashboard] Notification scheduling error: $e');
    }
  }

  void _detectNewClinicalRecords(ClinicalResponse clinicalInfo) {
    try {
      final newMedCount = clinicalInfo.medications.length;
      final newTestCount = clinicalInfo.testResults.length;

      // First load — just record counts, don't notify
      if (_previousMedicationCount == -1) {
        _previousMedicationCount = newMedCount;
        _previousTestResultCount = newTestCount;
        return;
      }

      final notificationService = NotificationService.instance;

      // Detect new medications
      if (newMedCount > _previousMedicationCount) {
        final diff = newMedCount - _previousMedicationCount;
        final latestMed = clinicalInfo.medications.first;
        notificationService.showClinicalRecordNotification(
          title: 'New Medication Added',
          body: diff == 1
              ? 'Your doctor prescribed ${latestMed.medName}'
              : '$diff new medications have been added to your records',
          payload: '{"type":"medication"}',
        );
        debugPrint('💊 [Dashboard] Notified: $diff new medication(s)');
      }

      // Detect new test results
      if (newTestCount > _previousTestResultCount) {
        final diff = newTestCount - _previousTestResultCount;
        notificationService.showClinicalRecordNotification(
          title: 'New Test Result Available',
          body: diff == 1
              ? 'A new test result has been added to your records'
              : '$diff new test results are available',
          payload: '{"type":"test_result"}',
        );
        debugPrint('🧪 [Dashboard] Notified: $diff new test result(s)');
      }

      _previousMedicationCount = newMedCount;
      _previousTestResultCount = newTestCount;
    } catch (e) {
      debugPrint('⚠️ [Dashboard] Clinical record detection error: $e');
    }
  }
}
