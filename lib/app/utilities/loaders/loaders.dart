import 'package:flutter/material.dart%20';
import 'package:get/get.dart';


class AppToasts{

  static successSnackBar({required title,message = '',duration = 3}){
    Get.snackbar(
      title,
    message,
    isDismissible:true,
    shouldIconPulse:true,
    colorText:Colors.white,
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(left: 5,right: 5,bottom: 5),
      icon: const Icon(Icons.check,color:Colors.white),
    );
  }

  static warningSnackBar({required title,message = '',duration = 2}){
    Get.snackbar(
      title,
      message,
      snackStyle: SnackStyle.FLOATING,
      isDismissible:true,
      shouldIconPulse:true,
      colorText:Colors.white,
      backgroundColor: Colors.orange,
      snackPosition: SnackPosition.BOTTOM,
      padding: EdgeInsets.all(5),
      duration: Duration(seconds: duration),
      margin: EdgeInsets.only(left: 5,right: 5,bottom: 5),
      icon: const Icon(Icons.warning_amber_sharp,color:Colors.white),
    );
  }

  static errorSnackBar({required title,message = '',duration = 3}){
    Get.snackbar(
      title,
      message,
      isDismissible:true,
      shouldIconPulse:true,
      colorText:Colors.white,
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(10),
      icon: const Icon(Icons.error_outline,color:Colors.white),
    );
  }

}