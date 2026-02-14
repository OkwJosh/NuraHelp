import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/services/app_service.dart';
import 'package:nurahelp/app/data/services/cache_service.dart';
import 'package:nurahelp/app/data/services/file_management_service.dart';
import 'package:nurahelp/app/data/services/notification_service.dart';
import 'package:nurahelp/app/features/main/controllers/notification/notification_controller.dart';
import 'package:nurahelp/app/features/main/controllers/nura_bot/nura_bot_controller.dart';
import 'package:nurahelp/app/features/main/controllers/symptom_insight_controller/symptom_insight_controller.dart';
import 'package:nurahelp/app/data/controllers/file_controller.dart';
import 'package:nurahelp/firebase_options.dart';

import 'app/app.dart';
import 'app/features/main/controllers/patient/patient_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Register FCM background handler (must be top-level)
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await dotenv.load(fileName: '.env');

  // Initialize services
  await Get.putAsync(() => CacheService().init(), permanent: true);
  Get.put(AppService(), permanent: true);
  await Get.putAsync(() => FileManagementService().init(), permanent: true);
  await Get.putAsync(() => NotificationService().init(), permanent: true);
  Get.put(NotificationController(), permanent: true);
  Get.put(FileController(), permanent: true);
  Get.put(PatientController());
  Get.put(NuraBotController());
  Get.put(SymptomInsightController());

  runApp(const MyApp());
}
