
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/utilities/popups/screen_loader.dart';

import '../../screens/sign_up/confirm_email.dart';

class SignUpController extends GetxController{
  static SignUpController get instance => Get.find();

  final Rx<bool> hidePassword = true.obs;
  final Rx<bool> consentCheckboxIsClicked = false.obs;
  final Rx<bool> nuraAICheckboxIsClicked = false.obs;
  final Rx<bool> isSubmitted = false.obs;
  final Rx<DateTime?> submittedDate =  Rx<DateTime?>(null);
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();



  void signUpWithEmailAndPassword() async{
    try{
      
      AppScreenLoader.openLoadingDialog('Signing up ...');

      if(!signUpFormKey.currentState!.validate() || submittedDate == null || !consentCheckboxIsClicked.value || !nuraAICheckboxIsClicked.value){
        AppScreenLoader.stopLoading();
        return;
      }

      AppScreenLoader.stopLoading();
      Get.to(() => ConfirmEmailScreen(),transition: Transition.rightToLeft);
      
      
      
    }
    catch(e){
      AppScreenLoader.stopLoading();
    }
  }





}