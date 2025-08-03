import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/features/auth/screens/login/login.dart';
import 'package:nurahelp/app/features/auth/screens/sign_up/confirm_email.dart';
import 'package:nurahelp/app/features/auth/screens/sign_up/widget/sign_up_form.dart';
import 'package:nurahelp/app/features/auth/screens/sign_up/widget/sign_up_progress_bar.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: SignUpProgressBar(firstBarColor: AppColors.secondaryColor,secondBarColor: Colors.grey.withOpacity(0.5),thirdBarColor: Colors.grey.withOpacity(0.5),),
      ),
      body: Padding(
            padding: const EdgeInsets.only(top: 50, right: 15, left: 15),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Set Up Your Nura Account',
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'Poppins-SemiBold',
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'form is pre-filled and editable',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins-Light',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    SignUpForm(),
                    SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: () => Get.to(()=>LoginScreen(),transition: Transition.leftToRight),
                        child: Text.rich(
                            TextSpan(
                                text: 'Already have an account?',
                                style: TextStyle(fontFamily: 'Poppins-Light',fontSize: 12,letterSpacing: 0,color: AppColors.black),
                                children: [
                                  TextSpan(
                                    text: ' Log in',
                                    style: TextStyle(fontFamily: 'Poppins-Light',fontSize: 12,letterSpacing: 0,color: AppColors.secondaryColor),
                                  )
                                ]
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}



