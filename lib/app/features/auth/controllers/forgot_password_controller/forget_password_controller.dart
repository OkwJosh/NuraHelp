
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/utilities/popups/screen_loader.dart';

import '../../screens/forget_password/email_sent.dart';

class ForgetPasswordController extends GetxController{
  static ForgetPasswordController get instance => Get.find();


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController forgetPasswordTextController = TextEditingController();



  void sendResetPasswordLink(){
    try{
      AppScreenLoader.openLoadingDialog('Processing Request');

      if(!formKey.currentState!.validate()){
        AppScreenLoader.stopLoading();
        return ;
      }

      AppScreenLoader.stopLoading();
      Get.offAll(() => EmailSentScreen(),transition: Transition.rightToLeft);

    }

    catch(e){
      AppScreenLoader.stopLoading();
    }
  }








}