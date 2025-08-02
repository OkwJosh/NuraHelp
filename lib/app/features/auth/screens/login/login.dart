import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nurahelp/app/features/auth/screens/forget_password/forget_password.dart';
import 'package:nurahelp/app/features/auth/screens/login/widgets/login_form.dart';
import 'package:nurahelp/app/features/auth/screens/sign_up/sign_up.dart';

import '../../../../nav_menu.dart';
import '../../../../utilities/constants/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 80, right: 15, left: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontFamily: 'Poppins-SemiBold',
                      fontSize: 24,
                      letterSpacing: 0,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'please fill in your details below',
                    style: TextStyle(fontFamily: 'Poppins-Regular'),
                  ),
                ],
              ),
              SizedBox(height: 24),
              LoginForm(),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Get.to(()=>ForgetPasswordScreen(),transition: Transition.rightToLeft),
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 12,
                        letterSpacing: 0,
                        fontFamily: 'Poppins-Light',
                        color: AppColors.black,
                        decorationColor: AppColors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                  child: ElevatedButton(onPressed: () => Get.offAll(() => NavigationMenu()), child: Text('Login',style: TextStyle(fontFamily: 'Poppins-Medium',color: Colors.white),))),
              SizedBox(height: 26),
              Center(
                child: GestureDetector(
                  onTap: () => Get.to(()=>SignUpScreen(),transition: Transition.rightToLeft),
                  child: Text.rich(
                    TextSpan(
                      text: 'Don\'t have an account?',
                      style: TextStyle(fontFamily: 'Poppins-Light',fontSize: 12,letterSpacing: 0,color: AppColors.black),
                      children: [
                        TextSpan(
                          text: ' Sign Up',
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

