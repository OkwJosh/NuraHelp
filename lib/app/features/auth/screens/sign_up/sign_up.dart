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
                        'Create account',
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Poppins-SemiBold',
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'please fill in you details below',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins-Regular',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  SignUpForm(),
                  SizedBox(height: 10),
                  Text(
                    'What best describes you?',
                    style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox.square(
                        dimension: 20,
                        child: Checkbox(
                          value: (true),
                          onChanged: (value) {},
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text('I accept the Terms of Service'),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: ()  => Get.to(() => ConfirmEmailScreen(),transition: Transition.rightToLeft),
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins-SemiBold',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: GestureDetector(
                      onTap: () => Get.to(()=>LoginScreen(),transition: Transition.leftToRight),
                      child: Text.rich(
                          TextSpan(
                              text: 'Already have an account?',
                              style: TextStyle(fontFamily: 'Poppins-Regular',fontSize: 12,letterSpacing: 0,color: AppColors.greyColor.withOpacity(0.9)),
                              children: [
                                TextSpan(
                                  text: ' Log in',
                                  style: TextStyle(fontFamily: 'Poppins-Regular',fontSize: 12,letterSpacing: 0,color: AppColors.secondaryColor),
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
    );
  }
}



