import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/features/main/screens/dashboard/dashboard.dart';
import 'package:nurahelp/app/nav_menu.dart';
import 'package:nurahelp/app/utilities/popups/screen_loader.dart';

class LoginController extends GetxController{
  static LoginController get instance => Get.find();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Rx<bool> hidePassword = true.obs;


  void loginWithEmailAndPassword() async{
    try{
      AppScreenLoader.openLoadingDialog('Logging you in ...');

      if(!formKey.currentState!.validate()){
        AppScreenLoader.stopLoading();
        return;
      }

      AppScreenLoader.stopLoading();
      Get.offAll(()=> NavigationMenu());


    }catch(e){
      AppScreenLoader.stopLoading();

    }


  }




}