import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/services/app_service.dart';
import 'package:nurahelp/app/data/services/network_manager.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/routes/app_routes.dart';
import 'package:nurahelp/app/utilities/loaders/loaders.dart';
import 'package:nurahelp/app/utilities/popups/screen_loader.dart';

/// Controller for OTP verification during login flow
/// Used when user needs to complete account verification after login
class OtpVerificationController extends GetxController {
  static OtpVerificationController get instance => Get.find();

  OtpVerificationController({required this.email});

  final String email;
  final TextEditingController otpCode = TextEditingController();
  final appService = AppService.instance;
  Rx<int> remainingSeconds = 60.obs;
  Timer? _timer;
  Rx<bool> resendingOtp = false.obs;

  @override
  void onInit() {
    super.onInit();
    _requestOtpOnInit();
    startCountdown(60);
  }

  Future<void> _requestOtpOnInit() async {
    try {
      await appService.requestOtp(email);
      print('✅ [OtpVerificationController] OTP requested on screen init');
    } catch (e) {
      print('❌ [OtpVerificationController] Error requesting OTP: $e');
    }
  }

  Future<void> resendOtp() async {
    try {
      AppScreenLoader.openLoadingDialog('Resending OTP ...');
      resendingOtp.value = true;
      await appService.requestOtp(email);
      AppScreenLoader.stopLoading();
      AppToasts.successSnackBar(
        title: 'OTP Resent',
        message: 'We\'ve sent another OTP to your email',
      );
      startCountdown(60);
    } catch (e) {
      AppScreenLoader.stopLoading();
      AppToasts.errorSnackBar(
        title: 'Error sending OTP',
        message: e.toString(),
      );
    }
  }

  Future<void> verifyOtp() async {
    AppScreenLoader.openLoadingDialog('Verifying OTP ...');
    final isConnected = await AppNetworkManager.instance.isConnected();
    if (!isConnected) {
      AppScreenLoader.stopLoading();
      AppToasts.warningSnackBar(
        title: 'No Internet Connection',
        message: 'Connect to the internet to continue',
      );
      return;
    }
    if (otpCode.text.length < 6) {
      AppScreenLoader.stopLoading();
      AppToasts.errorSnackBar(
        title: 'OTP Verification Failed',
        message: 'The OTP supplied is incomplete',
      );
      return;
    }
    try {
      // Verify OTP
      await appService.verifyOtp(email, otpCode.text.trim());

      // Get patient controller and update isComplete
      final user = FirebaseAuth.instance.currentUser;
      final patientController = Get.find<PatientController>();

      if (user != null) {
        // Update patient with isComplete = true and save to backend
        await appService.updateIsCompleteField(
          user,
          patientController.patient.value,
        );

        // Update patient controller
        patientController.patient.value.isComplete = true;
        patientController.patient.refresh();
      }

      AppScreenLoader.stopLoading();
      AppToasts.successSnackBar(
        title: 'OTP Verified!',
        message: 'Your account has been verified successfully',
      );

      // Navigate to navigation menu
      Get.offAllNamed(AppRoutes.navigationMenu);
    } catch (e) {
      AppScreenLoader.stopLoading();
      AppToasts.errorSnackBar(
        title: 'OTP Verification Failed',
        message: e.toString(),
      );
    }
  }

  void startCountdown(int seconds) {
    remainingSeconds.value = seconds;

    _timer?.cancel(); // cancel any existing timer

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds.value == 0) {
        resendingOtp.value = false;
        timer.cancel();
      } else {
        remainingSeconds.value--;
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpCode.dispose();
    super.onClose();
  }
}
