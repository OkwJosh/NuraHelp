import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
        padding: const EdgeInsets.only(top: 50, right: 15, left: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LOGO',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontFamily: 'Poppins-SemiBold',
                      fontSize: 22,
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
              SizedBox(height: 20),
              LoginForm(),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forgot password?',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 12,
                      letterSpacing: 0,
                      fontFamily: 'Poppins-Regular',
                      color: AppColors.greyColor.withOpacity(0.9),
                      decorationColor: AppColors.greyColor.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                  child: ElevatedButton(onPressed: () => Get.offAll(() => NavigationMenu()), child: Text('Login',style: TextStyle(fontFamily: 'Poppins-Medium',color: Colors.white),))),
              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () => Get.to(()=>SignUpScreen(),transition: Transition.rightToLeft),
                  child: Text.rich(
                    TextSpan(
                      text: 'Don\'t have an account?',
                      style: TextStyle(fontFamily: 'Poppins-Regular',fontSize: 12,letterSpacing: 0,color: AppColors.greyColor.withOpacity(0.9)),
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

