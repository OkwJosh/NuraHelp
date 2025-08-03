
import 'package:get/get.dart';

class SignUpController extends GetxController{
  static SignUpController get instance => Get.find();

  final Rx<bool> hidePassword = true.obs;
  final Rx<bool> consentCheckboxIsClicked = false.obs;
  final Rx<bool> nuraAICheckboxIsClicked = false.obs;





}