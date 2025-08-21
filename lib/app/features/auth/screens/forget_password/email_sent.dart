import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nurahelp/app/features/auth/screens/login/login.dart';

import '../../../../utilities/constants/colors.dart';

class EmailSentScreen extends StatelessWidget {
  const EmailSentScreen({super.key,required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top:80.0,right:15,left: 15),
            child: Column(
              children: [
                Center(child: Lottie.asset('assets/animations/sent_email.json',width: 300,height: 300)),
                SizedBox(height: 20),
                Text(email,style: TextStyle(fontFamily: 'Poppins-Medium')),
                SizedBox(height: 20),
                Text('We\'ve sent a reset link to your email,\n you\'ll be redirected to a secure site to reset your password',textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Poppins-Regular')),
                SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                    child: ElevatedButton(onPressed: () => Get.offAll(()=>LoginScreen(),transition: Transition.leftToRight), child: Text('Continue to Login',style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: 'Poppins-Medium')))),
                SizedBox(height: 10),
                TextButton(onPressed: (){}, child: Text('Resend email',style: TextStyle(color: AppColors.black))),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
