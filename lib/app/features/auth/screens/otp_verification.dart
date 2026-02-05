import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:nurahelp/app/features/auth/controllers/otp_verification_controller.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpVerificationController(email: email));

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Verify Account',
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Poppins-SemiBold',
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                'Complete Your Verification',
                style: TextStyle(
                  fontFamily: 'Poppins-SemiBold',
                  fontSize: 28,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 15),
              Text.rich(
                style: const TextStyle(
                  fontFamily: 'Poppins-Regular',
                  color: AppColors.black300,
                  fontSize: 16,
                ),
                TextSpan(
                  text: 'We sent a verification code to ',
                  children: [
                    TextSpan(
                      text: email,
                      style: const TextStyle(
                        color: AppColors.secondaryColor,
                        fontFamily: 'Poppins-Medium',
                        fontSize: 16,
                      ),
                    ),
                    const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        color: AppColors.black300,
                        fontSize: 16,
                      ),
                      text:
                          '\n\nPlease enter the code to complete your account verification.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              CustomOtpField(
                controller: controller.otpCode,
                onCompleted: (value) => FocusScope.of(context).unfocus(),
              ),
              const SizedBox(height: 24),
              Obx(
                () => controller.remainingSeconds.value == 0
                    ? Center(
                        child: TextButton(
                          onPressed: () => controller.resendOtp(),
                          child: const Text(
                            'Resend code',
                            style: TextStyle(
                              color: AppColors.secondaryColor,
                              fontFamily: 'Poppins-Medium',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text.rich(
                          style: const TextStyle(
                            color: AppColors.black300,
                            fontSize: 14,
                            fontFamily: 'Poppins-Regular',
                          ),
                          TextSpan(
                            text: 'Resend code in ',
                            children: [
                              TextSpan(
                                text: '${controller.remainingSeconds.value}s',
                                style: const TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontFamily: 'Poppins-Medium',
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => controller.verifyOtp(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Verify Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins-SemiBold',
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomOtpField extends StatelessWidget {
  const CustomOtpField({
    super.key,
    required this.controller,
    required this.onCompleted,
  });

  final TextEditingController controller;
  final Function(String) onCompleted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: PinCodeTextField(
        appContext: context,
        showCursor: false,
        controller: controller,
        onCompleted: onCompleted,
        length: 6,
        obscureText: false,
        cursorColor: Colors.black,
        keyboardType: TextInputType.number,
        hintCharacter: '-',
        hintStyle: const TextStyle(
          fontSize: 27,
          fontFamily: 'Poppins-ExtraLight',
          color: Colors.black,
        ),
        textStyle: const TextStyle(
          fontSize: 22,
          fontFamily: 'Poppins-Light',
          color: Colors.black,
        ),
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(10),
          fieldHeight: 55,
          fieldWidth: 55,
          activeColor: AppColors.black,
          inactiveColor: AppColors.black,
          selectedColor: AppColors.black,
          activeFillColor: Colors.white,
          inactiveFillColor: Colors.white,
          selectedFillColor: Colors.white,
          borderWidth: 0.3,
          activeBorderWidth: 0.3,
          disabledBorderWidth: 0.3,
          inactiveBorderWidth: 0.3,
          errorBorderWidth: 0.3,
          errorBorderColor: Colors.red,
        ),
        enableActiveFill: true,
        onChanged: (value) {
          print('OTP: $value');
        },
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
    );
  }
}
