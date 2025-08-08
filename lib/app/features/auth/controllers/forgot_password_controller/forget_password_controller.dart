
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/repositories/auth_repository.dart';
import 'package:nurahelp/app/utilities/popups/screen_loader.dart';

import '../../../../data/services/network_manager.dart';
import '../../../../utilities/loaders/loaders.dart';
import '../../screens/forget_password/email_sent.dart';

class ForgetPasswordController extends GetxController{
  static ForgetPasswordController get instance => Get.find();


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final _auth = Get.put(AuthenticationRepository());


  void sendResetPasswordLink() async{
    AppScreenLoader.openLoadingDialog('Sending Reset Link ...');
    final isConnected = await AppNetworkManager.instance.isConnected();
    if(!isConnected){
      AppScreenLoader.stopLoading();
      AppToasts.warningSnackBar(title: 'No Internet Connection',message: 'Connect to the internet to continue');
      return;
    }
    try{
      AppScreenLoader.openLoadingDialog('Processing Request');
      if(!formKey.currentState!.validate()){
        AppScreenLoader.stopLoading();
        return ;
      }

      await _auth.sendPasswordResetLink(email.text.trim());
      AppScreenLoader.stopLoading();
      Get.offAll(() => EmailSentScreen(email: email.text.trim(),),transition: Transition.rightToLeft);

    }

    catch(e){
      AppScreenLoader.stopLoading();
    }
  }








}