
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/repositories/auth_repository.dart';
import 'package:nurahelp/app/utilities/loaders/loaders.dart';
import 'package:nurahelp/app/utilities/popups/screen_loader.dart';

import '../../../../data/services/network_manager.dart';
import '../../screens/sign_up/confirm_email.dart';

class SignUpController extends GetxController{
  static SignUpController get instance => Get.find();

  final Rx<bool> hidePassword = true.obs;
  final Rx<bool> consentCheckboxIsClicked = false.obs;
  final Rx<bool> nuraAICheckboxIsClicked = false.obs;
  final Rx<bool> isSubmitted = false.obs;
  final Rx<DateTime?> submittedDate =  Rx<DateTime?>(null);
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final fullName = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final password = TextEditingController();
  final _auth = Get.put(AuthenticationRepository());



  void signUpWithEmailAndPassword() async{
    AppScreenLoader.openLoadingDialog('Signing up ...');
    final isConnected = await AppNetworkManager.instance.isConnected();
    if(!isConnected){
      AppScreenLoader.stopLoading();
      AppToasts.warningSnackBar(title: 'No Internet Connection',message: 'Connect to the internet to continue');
      return;
    }
    try{
      if(!signUpFormKey.currentState!.validate() || submittedDate == null || !consentCheckboxIsClicked.value || !nuraAICheckboxIsClicked.value){
        AppScreenLoader.stopLoading();
        return;
      }

      await _auth.registerWithEmailAndPassword(email.text.trim(), password.text.trim());

      AppScreenLoader.stopLoading();
      AppToasts.successSnackBar(title: 'Congrats',message: 'Your account was created successfully');
      Get.to(() => ConfirmEmailScreen(),transition: Transition.rightToLeft);
      
      
      
    }
    catch(e){
      AppScreenLoader.stopLoading();
      AppToasts.errorSnackBar(
        title: 'Sign-Up Failed',
        message: e.toString(),
      );
    }
  }





}