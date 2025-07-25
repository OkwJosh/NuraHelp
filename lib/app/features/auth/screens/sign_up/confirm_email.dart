import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nurahelp/app/features/auth/screens/sign_up/onboarding.dart';
import 'package:nurahelp/app/features/auth/screens/sign_up/widget/sign_up_progress_bar.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ConfirmEmailScreen extends StatelessWidget {
  const ConfirmEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: SignUpProgressBar(firstBarColor: AppColors.secondaryColor,secondBarColor: AppColors.secondaryColor,thirdBarColor: Colors.grey.withOpacity(0.5),),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'LOGO',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Confirm your email',
                    style: TextStyle(
                      fontFamily: 'Poppins-Medium',
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text.rich(
                    style: TextStyle(fontFamily: 'Poppins-Regular'),
                    TextSpan(
                      text: 'We sent a code to',
                      children: [
                        TextSpan(
                          text: ' example@gmail.com',
                          style: TextStyle(
                            color: AppColors.secondaryColor,
                            fontFamily: 'Poppins-Regular',
                          ),
                          children: [
                            TextSpan(
                              style: TextStyle(
                                fontFamily: 'Poppins-Regular',
                                color: Colors.black,
                              ),
                              text:
                                  '\nAfter confirming you email,you can continue\nyour account creation process',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              CustomOtpField(),
              SizedBox(height: 10),
              Center(
                child: Text.rich(
                  style: TextStyle(color: Colors.grey[600],fontSize: 14,fontFamily: 'Poppins-Regular'),
                  TextSpan(
                    text: 'Resending in',
                    children:[
                      TextSpan(
                        text: ' 60s',
                        style: TextStyle(color: AppColors.secondaryColor)
                      )
                ]
                  )
                ),
              ),
              SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                  child: ElevatedButton(onPressed: () => Get.to(() => FirstTimeOnBoardingScreen(),transition: Transition.rightToLeft), child: Text('Confirm email',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Medium'),)))
            ],
          ),
        ),
      ),
    );
  }
}

class CustomOtpField extends StatelessWidget {
  const CustomOtpField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: PinCodeTextField(
        appContext: context,
        length: 6,
        // Number of OTP boxes
        obscureText: false,
        cursorColor: Colors.black,
        keyboardType: TextInputType.number,
        hintCharacter: "-",
        hintStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),

        // Entered OTP style (bold like screenshot)
        textStyle: TextStyle(
          fontSize: 22,
          fontFamily: 'Poppins-Medium',
          color: Colors.black,
        ),

        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(10),
          // Slight rounding
          fieldHeight: 55,
          fieldWidth: 55,

          // Spacing between boxes
          // The package automatically adds spacing, but you can tweak via fieldWidth.
          activeColor: Colors.grey.shade300,
          inactiveColor: Colors.grey.shade300,
          selectedColor: Colors.grey.shade500,

          activeFillColor: Colors.white,
          inactiveFillColor: Colors.white,
          selectedFillColor: Colors.white,

          borderWidth: 1, // Thin border like in screenshot
        ),
        enableActiveFill: true,

        onChanged: (value) {
          print("OTP: $value");
        },

        mainAxisAlignment: MainAxisAlignment.center
      ),
    );
  }
}
