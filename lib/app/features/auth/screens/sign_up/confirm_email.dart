import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/features/auth/screens/sign_up/widget/sign_up_progress_bar.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../controllers/sign_up_controllers/otp_controller.dart';

class ConfirmEmailScreen extends StatelessWidget {
  const ConfirmEmailScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpController(email: email));
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: SignUpProgressBar(
          firstBarColor: AppColors.secondaryColor,
          secondBarColor: AppColors.secondaryColor,
          thirdBarColor: Colors.grey.withOpacity(0.5),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Obx(
              ()=> Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm your email',
                        style: TextStyle(
                          fontFamily: 'Poppins-Medium',
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text.rich(
                        style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          color: AppColors.black300,
                          fontSize: 16,
                        ),
                        TextSpan(
                          text: 'We sent a code to ',
                          children: [
                            TextSpan(
                              text: email,
                              style: TextStyle(
                                color: AppColors.secondaryColor,
                                fontFamily: 'Poppins-Medium',
                                fontSize: 16,
                              ),
                              children: [
                                TextSpan(
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Regular',
                                    color: AppColors.black300,
                                    fontSize: 16,
                                  ),
                                  text:
                                      '\nAfter confirming you email,you can continue your account creation process',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  CustomOtpField(
                    controller: controller.otpCode,
                    onCompleted: (value) => FocusScope.of(context).unfocus(),
                  ),
                  SizedBox(height: 16),
                  controller.remainingSeconds.value == 0
                      ? Center(
                          child: TextButton(
                            onPressed: () {
                              controller.resendOtp();
                              controller.startCountdown(60);
                            },
                            child: Text(
                              'Resend email',
                              style: TextStyle(
                                color: AppColors.secondaryColor,
                                fontFamily: 'Poppins-Medium',
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Obx(
                            () => Text.rich(
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontFamily: 'Poppins-Regular',
                              ),
                              TextSpan(
                                text: 'Resending in ',
                                children: [
                                  TextSpan(
                                    text: '${controller.remainingSeconds.value}',
                                    style: TextStyle(
                                      color: AppColors.secondaryColor,
                                      fontFamily: 'Poppins-Medium',
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => controller.verifyOtp(),
                      child: Text(
                        'Confirm email',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins-Medium',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
        // Number of OTP boxes
        obscureText: false,
        cursorColor: Colors.black,
        keyboardType: TextInputType.number,
        hintCharacter: '-',
        hintStyle: TextStyle(
          fontSize: 27,
          fontFamily: 'Poppins-ExtraLight',
          color: Colors.black,
        ),

        // Entered OTP style (bold like screenshot)
        textStyle: TextStyle(
          fontSize: 22,
          fontFamily: 'Poppins-Light',
          color: Colors.black,
        ),

        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(10),
          // Slight rounding
          fieldHeight: 55,
          fieldWidth: 55,

          // Spacing between boxes
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
