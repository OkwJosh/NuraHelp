import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utilities/constants/colors.dart';
import 'email_sent.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 60, left: 20, right: 20),
            child: Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap:()=> Get.back(),
                    child: Icon(Icons.arrow_back_ios_new_sharp, size: 20)),
                SizedBox(height: 24),
                Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Poppins-Medium',
                  ),
                ),
                Text(
                  'Don’t worry, it happens to the best of us \nJust enter your email, and we’ll send\nyou a reset link',
                  style: TextStyle(fontSize: 14, fontFamily: 'Poppins-Regular'),
                ),
                SizedBox(height: 24),
                TextField(
                  cursorColor: Colors.black,
                  style: TextStyle(
                    color: AppColors.black,
                    fontFamily: 'Poppins-Light',
                  ),
                  decoration: InputDecoration(hintText: 'Enter email'),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.offAll(() => EmailSentScreen(),transition: Transition.rightToLeft),
                    child: Text('Send Email',style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: 'Poppins-Medium'),),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
