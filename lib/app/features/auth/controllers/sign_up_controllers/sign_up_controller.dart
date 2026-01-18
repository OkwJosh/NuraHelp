import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/models/patient_model.dart';
import 'package:nurahelp/app/data/repositories/auth_repository.dart';
import 'package:nurahelp/app/data/services/socket_service.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/routes/app_routes.dart';
import 'package:nurahelp/app/utilities/loaders/loaders.dart';
import 'package:nurahelp/app/utilities/popups/screen_loader.dart';
import '../../../../data/services/app_service.dart';
import '../../../../data/services/network_manager.dart';


class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final Rx<bool> hidePassword = true.obs;
  final Rx<bool> consentCheckboxIsClicked = false.obs;
  final Rx<bool> nuraAICheckboxIsClicked = false.obs;
  final Rx<bool> isSubmitted = false.obs;
  final Rx<DateTime?> submittedDate = Rx<DateTime?>(null);
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final fullName = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final password = TextEditingController();
  final invitationCode = TextEditingController();
  final _authRepo = Get.put(AuthenticationRepository());
  final patientController = Get.find<PatientController>();
  final appService = AppService.instance;

  void signUpWithEmailAndPassword() async {
    AppScreenLoader.openLoadingDialog('Signing up ...');
    final isConnected = await AppNetworkManager.instance.isConnected();
    if (!isConnected) {
      AppScreenLoader.stopLoading();
      AppToasts.warningSnackBar(
        title: 'No Internet Connection',
        message: 'Connect to the internet to continue',
      );
      return;
    }

    User? createdUser; // Track the created user for cleanup

    try {
      if (!signUpFormKey.currentState!.validate() ||
          !consentCheckboxIsClicked.value ||
          !nuraAICheckboxIsClicked.value) {
        AppScreenLoader.stopLoading();
        return;
      }

      UserCredential cred = await _authRepo.registerWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );
      createdUser = cred.user; // Store reference for potential cleanup
      final patient = PatientModel(
        name: fullName.text.trim(),
        email: email.text.trim(),
        phone: phoneNumber.text.trim(),
        DOB: submittedDate.value,
        profilePicture: '',
        // inviteCode: invitationCode.text.trim(),
      );
      await appService.savePatientRecord(patient, createdUser);
      patientController.patient.value = patient;
      patientController.refresh();

      // Initialize SocketService
      await Get.putAsync(
        () => SocketService().init(
          dotenv.env['NEXT_PUBLIC_API_URL']!,
          createdUser!.uid,
        ),
      );

      AppScreenLoader.stopLoading();
      AppToasts.successSnackBar(
        title: 'Congrats',
        message: 'Your account was created successfully',
      );
      appService.requestOtp(email.text.trim());
      Get.toNamed(AppRoutes.confirmEmail, arguments: email.text.trim());
    } catch (e) {
      if (createdUser != null) {
        try {
          await createdUser.delete();
        } catch (deleteError) {
          print(
            'Failed to delete user after registration failure: $deleteError',
          );
        }
      }

      AppScreenLoader.stopLoading();
      AppToasts.errorSnackBar(title: 'Sign-Up Failed', message: e.toString());
    }
  }

  void logout() async {
    try {
      AppScreenLoader.openLoadingDialog('Logging out');
      await _authRepo.logout();
      AppScreenLoader.stopLoading();
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      throw 'Something went wrong';
    }
  }
}
