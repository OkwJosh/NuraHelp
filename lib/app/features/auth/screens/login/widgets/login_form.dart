import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:nurahelp/app/features/auth/controllers/login_controllers/login_controller.dart';

import '../../../../../nav_menu.dart';
import '../../../../../utilities/constants/colors.dart';
import '../../forget_password/forget_password.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());
    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(hintText: 'Email Address'),
          ),
          SizedBox(height: 16),
          Obx(
            () => TextFormField(
              obscureText: loginController.hidePassword.value,
              obscuringCharacter: '*',
              decoration: InputDecoration(
                hintText: 'Password',
                suffixIcon: IconButton(icon:loginController.hidePassword.value?Icon(Icons.visibility_off_outlined):Icon(Icons.visibility_outlined), onPressed: ()=> loginController.hidePassword.value = !loginController.hidePassword.value),
              ),
            ),
          ),
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
                    fontSize: 14,
                    letterSpacing: 0,
                    fontFamily: 'Poppins-Regular',
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
              child: ElevatedButton(onPressed: () => Get.offAll(() => NavigationMenu()), child: Text('Login',style: TextStyle(fontFamily: 'Poppins-Medium',fontSize:16,color: Colors.white),))),
        ],
      ),
    );
  }
}

