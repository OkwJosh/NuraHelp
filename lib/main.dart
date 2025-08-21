import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/bindings/general_bindings.dart';
import 'package:nurahelp/app/data/services/app_service.dart';
import 'package:nurahelp/app/features/main/controllers/nura_bot/nura_bot_controller.dart';
import 'package:nurahelp/firebase_options.dart';

import 'app/app.dart';
import 'app/features/main/controllers/patient/patient_controller.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await dotenv.load(fileName: '.env');
  Get.put(AppService(),permanent: true);
  Get.put(PatientController());
  Get.put(NuraBotController());
  runApp(const MyApp());
}



