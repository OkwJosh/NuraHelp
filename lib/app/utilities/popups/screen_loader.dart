import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';

class AppScreenLoader{

  static void openLoadingDialog(String text) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false, // Prevents user from dismissing dialog
      builder: (_) => PopScope(
        canPop: false, // Prevents back button dismissal
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Rounded corners
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ensures proper size
              children: [
                CircularProgressIndicator(color:AppColors.secondaryColor),
                const SizedBox(height: 16), // Ensure PgSizes is a const
                Text(
                  text,
                  style:TextStyle(color: AppColors.secondaryColor),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  static stopLoading(){
    Navigator.of(Get.overlayContext!).pop();
  }


}