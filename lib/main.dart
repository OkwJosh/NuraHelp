import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/bindings/general_bindings.dart';
import 'package:nurahelp/app/data/services/app_service.dart';
import 'package:nurahelp/app/features/main/controllers/nura_bot/nura_bot_controller.dart';
import 'package:nurahelp/firebase_options.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'app/app.dart';
import 'app/features/main/controllers/patient/patient_controller.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  // ZegoUIKitPrebuiltCallInvitationService().init(
  //   appID: 645029584,
  //   appSign: '349504939c5810841a10596660c089d443c47262051760251344d4aa0fe3e62d',
  //   userID: 'joshie',
  //   userName: 'Joshua Okwoli',
  //   plugins: [ZegoUIKitSignalingPlugin()],
  // );

  await dotenv.load(fileName: '.env');
  Get.put(AppService(),permanent: true);
  Get.put(PatientController());
  Get.put(NuraBotController());
  runApp(const MyApp());
}



