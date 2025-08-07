//
// import 'package:flutter/material.dart%20';
// import 'package:get/get.dart';
// import 'package:get/get_common/get_reset.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:iconsax/iconsax.dart';
//
// import '../constants/colors.dart';
//
// class PgLoaders{
//
//   static successSnackBar({required title,message = '',duration = 3}){
//     Get.snackbar(
//       title,
//     message,
//     isDismissible:true,
//     shouldIconPulse:true,
//     colorText:Colors.white,
//       backgroundColor: Colors.green,
//       snackPosition: SnackPosition.BOTTOM,
//       duration: Duration(seconds: duration),
//       margin: const EdgeInsets.all(10),
//       icon: const Icon(Iconsax.check,color:PgColors.white),
//     );
//   }
//
//   static warningSnackBar({required title,message = '',duration = 3}){
//     Get.snackbar(
//       title,
//       message,
//       isDismissible:true,
//       shouldIconPulse:true,
//       colorText:Colors.white,
//       backgroundColor: Colors.orange,
//       snackPosition: SnackPosition.BOTTOM,
//       duration: Duration(seconds: duration),
//       margin: const EdgeInsets.all(10),
//       icon: const Icon(Icons.warning_amber_sharp,color:PgColors.white),
//     );
//   }
//
//   static errorSnackBar({required title,message = '',duration = 3}){
//     Get.snackbar(
//       title,
//       message,
//       isDismissible:true,
//       shouldIconPulse:true,
//       colorText:Colors.white,
//       backgroundColor: Colors.red,
//       snackPosition: SnackPosition.BOTTOM,
//       duration: Duration(seconds: duration),
//       margin: const EdgeInsets.all(10),
//       icon: const Icon(Icons.error_outline,color:PgColors.white),
//     );
//   }
//
// }