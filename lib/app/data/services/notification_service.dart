import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/features/main/controllers/notification/notification_controller.dart';
import 'package:nurahelp/app/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Top-level handler for background FCM messages (must be top-level function).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('📩 [FCM] Background message: ${message.messageId}');
  // Local notification will be shown by the system tray automatically
  // for data-only messages, we show it manually:
  await NotificationService._showFromRemoteMessage(message);
}

/// Notification types used across the app.
enum NotificationType {
  appointment,
  symptomReminder,
  doctorMessage,
  medication,
  testResult,
}

/// Central notification service for both FCM (push) and local notifications.
class NotificationService extends GetxService {
  static NotificationService get instance => Get.find();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final RxString fcmToken = ''.obs;

  // Notification channel IDs
  static const _appointmentChannel = 'appointment_channel';
  static const _symptomChannel = 'symptom_reminder_channel';
  static const _messageChannel = 'doctor_message_channel';
  static const _clinicalChannel = 'clinical_record_channel';

  // SharedPreferences keys for scheduled notification tracking
  static const _scheduledAppointmentsKey = 'scheduled_appointment_ids';
  static const _symptomReminderKey = 'symptom_reminder_enabled';

  // ─── INITIALIZATION ──────────────────────────────────────────────

  /// Call this once from main.dart after Firebase.initializeApp.
  Future<NotificationService> init() async {
    await _initLocalNotifications();
    await _requestPermissions();
    await _setupFCM();
    return this;
  }

  Future<void> _initLocalNotifications() async {
    // Android init
    const androidInit = AndroidInitializationSettings('@mipmap/launcher_icon');

    // iOS init
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create Android notification channels
    await _createNotificationChannels();
  }

  Future<void> _createNotificationChannels() async {
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin == null) return;

    // Appointment channel (high importance)
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _appointmentChannel,
        'Appointment Reminders',
        description: 'Reminders for upcoming appointments',
        importance: Importance.high,
        playSound: true,
      ),
    );

    // Symptom reminder channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _symptomChannel,
        'Symptom Reminders',
        description: 'Daily reminders to log your symptoms',
        importance: Importance.defaultImportance,
        playSound: true,
      ),
    );

    // Doctor message channel (max importance)
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _messageChannel,
        'Doctor Messages',
        description: 'New messages from your doctor',
        importance: Importance.max,
        playSound: true,
      ),
    );

    // Clinical records channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _clinicalChannel,
        'Medical Records',
        description: 'New medications, test results, and records',
        importance: Importance.high,
        playSound: true,
      ),
    );
  }

  Future<void> _requestPermissions() async {
    // FCM permission
    final settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint(
      '🔔 [Notification] Permission status: ${settings.authorizationStatus}',
    );

    // Android 13+ notification permission
    if (Platform.isAndroid) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await androidPlugin?.requestNotificationsPermission();
    }
  }

  Future<void> _setupFCM() async {
    // Get FCM token
    try {
      final token = await _fcm.getToken();
      if (token != null) {
        fcmToken.value = token;
        debugPrint('🔑 [FCM] Token: ${token.substring(0, 20)}...');
        // TODO: Send token to your backend for push targeting
        // await _sendTokenToServer(token);
      }
    } catch (e) {
      debugPrint('⚠️ [FCM] Token retrieval failed: $e');
    }

    // Listen for token refresh
    _fcm.onTokenRefresh.listen((newToken) {
      fcmToken.value = newToken;
      debugPrint('🔄 [FCM] Token refreshed');
      // TODO: Send updated token to server
    });

    // Foreground message handler
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // When user taps notification that opened the app from terminated state
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationNavigation(initialMessage.data);
    }

    // When user taps notification that opened the app from background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotificationNavigation(message.data);
    });
  }

  // ─── FCM HANDLERS ────────────────────────────────────────────────

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('📨 [FCM] Foreground message: ${message.notification?.title}');

    final type = message.data['type'] ?? '';

    // Show local notification for foreground messages
    switch (type) {
      case 'appointment':
        showAppointmentNotification(
          title: message.notification?.title ?? 'Appointment Reminder',
          body:
              message.notification?.body ?? 'You have an upcoming appointment',
          payload: jsonEncode(message.data),
        );
        break;
      case 'symptom_reminder':
        showSymptomReminderNotification(
          title: message.notification?.title ?? 'Symptom Check-in',
          body: message.notification?.body ?? 'Time to log your symptoms',
        );
        break;
      case 'doctor_message':
        showDoctorMessageNotification(
          title: message.notification?.title ?? 'New Message',
          body: message.notification?.body ?? 'Your doctor sent you a message',
          payload: jsonEncode(message.data),
        );
        break;
      case 'medication':
      case 'test_result':
        showClinicalRecordNotification(
          title: message.notification?.title ?? 'New Record',
          body:
              message.notification?.body ?? 'A new medical record is available',
          payload: jsonEncode(message.data),
        );
        break;
      default:
        // Generic notification
        _showGenericNotification(message);
    }
  }

  /// Static method so it can be called from the background handler.
  static Future<void> _showFromRemoteMessage(RemoteMessage message) async {
    final type = message.data['type'] ?? '';
    final title = message.notification?.title ?? 'NuraHelp';
    final body = message.notification?.body ?? '';

    String channelId;
    switch (type) {
      case 'appointment':
        channelId = _appointmentChannel;
        break;
      case 'symptom_reminder':
        channelId = _symptomChannel;
        break;
      case 'doctor_message':
        channelId = _messageChannel;
        break;
      case 'medication':
      case 'test_result':
        channelId = _clinicalChannel;
        break;
      default:
        channelId = _messageChannel;
    }

    await _localNotifications.show(
      message.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelId.replaceAll('_', ' ').capitalizeFirst ?? channelId,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/launcher_icon',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }

  void _showGenericNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      notification.hashCode,
      notification.title ?? 'NuraHelp',
      notification.body ?? '',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _messageChannel,
          'Doctor Messages',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/launcher_icon',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }

  // ─── NOTIFICATION TAP HANDLING ────────────────────────────────────

  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;

    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      _handleNotificationNavigation(data);
    } catch (e) {
      debugPrint('⚠️ [Notification] Error parsing payload: $e');
    }
  }

  void _handleNotificationNavigation(Map<String, dynamic> data) {
    final type = data['type'] ?? '';

    switch (type) {
      case 'appointment':
        Get.toNamed(AppRoutes.appointments);
        break;
      case 'symptom_reminder':
        Get.toNamed(AppRoutes.symptomInsights);
        break;
      case 'doctor_message':
        // Navigate to direct message screen
        Get.toNamed(AppRoutes.directMessage);
        break;
      case 'medication':
      case 'test_result':
        Get.toNamed(AppRoutes.patientHealth);
        break;
      default:
        Get.toNamed(AppRoutes.notification);
    }
  }

  // ─── LOCAL NOTIFICATIONS — PUBLIC API ─────────────────────────────

  /// 1. Appointment reminder notification
  Future<void> showAppointmentNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    _recordToHistory(NotificationType.appointment, title, body);
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _appointmentChannel,
          'Appointment Reminders',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/launcher_icon',
          styleInformation: BigTextStyleInformation(''),
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload ?? '{"type":"appointment"}',
    );
  }

  /// Schedule an appointment notification for a specific time.
  Future<void> scheduleAppointmentReminder({
    required String appointmentId,
    required String purpose,
    required DateTime appointmentDateTime,
    Duration reminderBefore = const Duration(hours: 1),
  }) async {
    final reminderTime = appointmentDateTime.subtract(reminderBefore);

    // Don't schedule if the reminder time is already past
    if (reminderTime.isBefore(DateTime.now())) return;

    // Calculate delay and use Future.delayed for scheduling
    final delay = reminderTime.difference(DateTime.now());

    Future.delayed(delay, () async {
      await showAppointmentNotification(
        title: 'Upcoming Appointment',
        body:
            'Your "$purpose" appointment is in ${_formatDuration(reminderBefore)}',
        payload: '{"type":"appointment","appointmentId":"$appointmentId"}',
      );
    });

    // Track scheduled notification
    await _trackScheduledAppointment(appointmentId);

    debugPrint(
      '📅 [Notification] Scheduled reminder for "$purpose" at $reminderTime',
    );
  }

  /// 2. Symptom log reminder
  Future<void> showSymptomReminderNotification({
    String title = 'Symptom Check-in',
    String body =
        "How are you feeling today? Take a moment to log your symptoms.",
  }) async {
    _recordToHistory(NotificationType.symptomReminder, title, body);
    await _localNotifications.show(
      9999, // Fixed ID so it replaces old one
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _symptomChannel,
          'Symptom Reminders',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/launcher_icon',
          styleInformation: BigTextStyleInformation(''),
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: '{"type":"symptom_reminder"}',
    );
  }

  /// Start a daily symptom reminder check.
  /// This runs a periodic future that fires the notification at ~9 AM each day.
  void startDailySymptomReminder() {
    _setSymptomReminderEnabled(true);
    _scheduleDailySymptomReminder();
    debugPrint('⏰ [Notification] Daily symptom reminder enabled');
  }

  void stopDailySymptomReminder() {
    _setSymptomReminderEnabled(false);
    _localNotifications.cancel(9999);
    debugPrint('⏰ [Notification] Daily symptom reminder disabled');
  }

  void _scheduleDailySymptomReminder() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_symptomReminderKey) ?? false;
    if (!enabled) return;

    // Calculate time until next 9 AM
    final now = DateTime.now();
    var next9am = DateTime(now.year, now.month, now.day, 9, 0);
    if (now.isAfter(next9am)) {
      next9am = next9am.add(const Duration(days: 1));
    }

    final delay = next9am.difference(now);

    Future.delayed(delay, () async {
      await showSymptomReminderNotification();
      // Re-schedule for the next day
      _scheduleDailySymptomReminder();
    });
  }

  /// 3. Doctor message notification
  Future<void> showDoctorMessageNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    _recordToHistory(NotificationType.doctorMessage, title, body);
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _messageChannel,
          'Doctor Messages',
          importance: Importance.max,
          priority: Priority.max,
          icon: '@mipmap/launcher_icon',
          styleInformation: BigTextStyleInformation(''),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload ?? '{"type":"doctor_message"}',
    );
  }

  /// 4. New medication / test result notification
  Future<void> showClinicalRecordNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    // Determine sub-type from payload for history
    final historyType = (payload?.contains('test_result') ?? false)
        ? NotificationType.testResult
        : NotificationType.medication;
    _recordToHistory(historyType, title, body);
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _clinicalChannel,
          'Medical Records',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/launcher_icon',
          styleInformation: BigTextStyleInformation(''),
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload ?? '{"type":"medication"}',
    );
  }

  // ─── APPOINTMENT SCHEDULING HELPERS ───────────────────────────────

  /// Schedule reminders for all current appointments.
  Future<void> scheduleAllAppointmentReminders(
    List<dynamic> appointments,
  ) async {
    for (final apt in appointments) {
      try {
        // Parse appointment date and time
        final date = apt.appointmentDate as DateTime;
        final startTime = apt.appointmentStartTime as String;

        // Parse start time (e.g. "09:00" or "9:00 AM")
        final dateTime = _parseAppointmentDateTime(date, startTime);
        if (dateTime == null) continue;

        // Skip past appointments
        if (dateTime.isBefore(DateTime.now())) continue;

        // Skip canceled
        if (apt.status == 'Canceled') continue;

        // Schedule 1-hour before and 15-min before reminders
        await scheduleAppointmentReminder(
          appointmentId: '${apt.id}_1h',
          purpose: apt.purpose,
          appointmentDateTime: dateTime,
          reminderBefore: const Duration(hours: 1),
        );

        await scheduleAppointmentReminder(
          appointmentId: '${apt.id}_15m',
          purpose: apt.purpose,
          appointmentDateTime: dateTime,
          reminderBefore: const Duration(minutes: 15),
        );
      } catch (e) {
        debugPrint('⚠️ [Notification] Error scheduling appointment: $e');
      }
    }
  }

  DateTime? _parseAppointmentDateTime(DateTime date, String timeStr) {
    try {
      // Handle formats like "09:00", "9:00 AM", "14:30"
      final cleaned = timeStr.trim().toUpperCase();
      int hour;
      int minute;

      if (cleaned.contains('AM') || cleaned.contains('PM')) {
        final parts = cleaned
            .replaceAll(RegExp(r'[AP]M'), '')
            .trim()
            .split(':');
        hour = int.parse(parts[0]);
        minute = parts.length > 1 ? int.parse(parts[1]) : 0;
        if (cleaned.contains('PM') && hour != 12) hour += 12;
        if (cleaned.contains('AM') && hour == 12) hour = 0;
      } else {
        final parts = cleaned.split(':');
        hour = int.parse(parts[0]);
        minute = parts.length > 1 ? int.parse(parts[1]) : 0;
      }

      return DateTime(date.year, date.month, date.day, hour, minute);
    } catch (e) {
      debugPrint('⚠️ [Notification] Time parse error: $e');
      return null;
    }
  }

  String _formatDuration(Duration d) {
    if (d.inHours > 0) return '${d.inHours} hour${d.inHours > 1 ? 's' : ''}';
    return '${d.inMinutes} minute${d.inMinutes > 1 ? 's' : ''}';
  }

  // ─── PERSISTENCE HELPERS ──────────────────────────────────────────

  Future<void> _trackScheduledAppointment(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_scheduledAppointmentsKey) ?? [];
    if (!ids.contains(id)) {
      ids.add(id);
      await prefs.setStringList(_scheduledAppointmentsKey, ids);
    }
  }

  Future<void> _setSymptomReminderEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_symptomReminderKey, enabled);
  }

  /// Record a notification into the in-app history list.
  void _recordToHistory(NotificationType type, String title, String body) {
    try {
      if (Get.isRegistered<NotificationController>()) {
        NotificationController.instance.addNotification(
          type: type,
          title: title,
          body: body,
        );
      }
    } catch (e) {
      debugPrint('⚠️ [Notification] History record error: $e');
    }
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    await _localNotifications.cancelAll();
  }
}
