
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/features/auth/screens/sign_up/onboarding.dart';
import 'package:nurahelp/app/utilities/popups/screen_loader.dart';

import '../../../../data/services/app_service.dart';
import '../../../../data/services/network_manager.dart';
import '../../../../utilities/loaders/loaders.dart';

class OtpController extends GetxController {
  static OtpController get instance => Get.find();

  OtpController({required this.email});

  final String email;
  final TextEditingController otpCode = TextEditingController();
  final otpAuth = AppService.instance;
  Rx<int> remainingSeconds = 60.obs;
  Timer? _timer;
  Rx<bool> resendingOtp = false.obs;
  Rx<int> numberOfResendAttempts = 0.obs;

  @override
  void onInit() {
    super.onInit();
    startCountdown(60);
  }

  Future<void> resendOtp()async{
    try{
      AppScreenLoader.openLoadingDialog('Resending OTP ...');
      resendingOtp.value = true;
      await otpAuth.requestOtp(email);
      AppScreenLoader.stopLoading();
      AppToasts.successSnackBar(title: 'OTP Resent',
          message: 'We\'ve sent another OTP to your email');
    }catch (e) {
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
      AppToasts.warningSnackBar(title: 'No Internet Connection',
          message: 'Connect to the internet to continue');
      return;
    }
    if(otpCode.text.length < 6){
      AppScreenLoader.stopLoading();
      AppToasts.errorSnackBar(
        title: 'OTP Verification Failed',
        message: 'The OTP supplied is incomplete'
      );
      return ;
    }
    try {
      await otpAuth.verifyOtp(email, otpCode.text.trim());
      AppScreenLoader.stopLoading();
      AppToasts.successSnackBar(title: 'OTP Verified!',
          message: 'Your account has been verified successfully');
      Get.to(() => FirstTimeOnBoardingScreen(),
          transition: Transition.rightToLeft);
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
    super.onClose();
  }

}
