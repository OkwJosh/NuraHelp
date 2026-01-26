import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/repositories/auth_repository.dart';
import 'package:nurahelp/app/data/services/app_service.dart';
import 'package:nurahelp/app/data/services/network_manager.dart';
import 'package:nurahelp/app/data/services/socket_service.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/routes/app_routes.dart';
import 'package:nurahelp/app/utilities/loaders/loaders.dart';
import 'package:nurahelp/app/utilities/popups/screen_loader.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Rx<bool> hidePassword = true.obs;
  final email = TextEditingController();
  final password = TextEditingController();
  final _auth = Get.put(AuthenticationRepository());
  final appService = AppService.instance;
  final patientController = Get.find<PatientController>();

  void loginWithEmailAndPassword() async {
    AppScreenLoader.openLoadingDialog('Logging you in ...');
    final isConnected = await AppNetworkManager.instance.isConnected();
    if (!isConnected) {
      AppScreenLoader.stopLoading();
      AppToasts.warningSnackBar(
        title: 'No Internet Connection',
        message: 'Connect to the internet to continue',
      );
      return;
    }
    try {
      if (!formKey.currentState!.validate()) {
        AppScreenLoader.stopLoading();
        return;
      }
      await _auth.loginWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );
      final currentUser = FirebaseAuth.instance.currentUser;

      // Initialize SocketService immediately (needed for real-time messaging)
      await Get.putAsync(
        () => SocketService().init(
          dotenv.env['NEXT_PUBLIC_API_URL']!,
          currentUser!.uid,
        ),
      );

      AppScreenLoader.stopLoading();

      // Navigate to dashboard - data will be fetched there with shimmer loading
      Get.offAllNamed(AppRoutes.navigationMenu);
    } catch (e) {
      AppScreenLoader.stopLoading();
      AppToasts.errorSnackBar(title: 'Login Failed', message: e.toString());
    }
  }
}
