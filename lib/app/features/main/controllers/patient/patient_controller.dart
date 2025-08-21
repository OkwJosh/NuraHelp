import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurahelp/app/data/models/patient_model.dart';
import 'package:nurahelp/app/data/models/settings_model/notification_model.dart';
import 'package:nurahelp/app/data/models/settings_model/security_model.dart';
import 'package:nurahelp/app/data/models/settings_model/settings_model.dart';
import 'package:nurahelp/app/utilities/loaders/loaders.dart';
import 'package:nurahelp/app/utilities/popups/screen_loader.dart';
import '../../../../data/services/app_service.dart';
import '../../../../nav_menu.dart';

class PatientController extends GetxController {
  static PatientController get instance => Get.find();


  final imageLoading = false.obs;
  Rx<PatientModel> patient = PatientModel.empty().obs;
  final Rx<bool> proceedToDashboardIsClicked = false.obs;
  final Rx<bool> enableHeyNuraVoice = false.obs;
  final appService = AppService.instance;
  GlobalKey<FormState> onboardingFormKey = GlobalKey<FormState>();
  Rx<String>? selectedValue;
  final Rx<bool> enableAppointmentReminders = false.obs;
  final Rx<bool> enableMessageAlerts = false.obs;
  final Rx<bool> enable2Fa = false.obs;
  final TextEditingController editName = TextEditingController();
  final TextEditingController editEmail = TextEditingController();
  final TextEditingController editPhone = TextEditingController();


  @override
  void onReady(){
    super.onReady();
    if(patient != null){
      editName.text = patient.value.name;
      editEmail.text = patient.value.email;
      editPhone.text = patient.value.phone;
    }
  }


  formatDate(DateTime? date){
    String dateSuffix;
    if(date?.day == 1 || date?.day == 21 || date?.day == 31){
      dateSuffix = 'st';
    }else if(date?.day == 2 || date?.day == 22){
      dateSuffix = 'nd';
    }else if(date?.day == 3 || date?.day == 23){
      dateSuffix = 'rd';
    }else{
      dateSuffix = 'th';
    }
    return '${date?.day}$dateSuffix ${date?.month}, ${date?.year}';
  }

  uploadProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery,
          imageQuality: 70,
          maxHeight: 512,
          maxWidth: 512);
      if (image != null) {
        imageLoading.value = true;
        final currentUser = FirebaseAuth.instance.currentUser;
        final token = await currentUser?.getIdToken();
        print('Hey this is the token $token');
        final imageUrl = await appService.uploadImage('Patient/Profile/', image);
        patient.value.profilePicture = imageUrl;
        patient.refresh();
        await appService.updatePatientField(user: currentUser,patient: patient.value);
        AppToasts.successSnackBar(title: 'Congratulations',
            message: 'Your profile image has been updated');
      }
    } catch (e) {
      AppToasts.errorSnackBar(
          title: 'Oh Snap', message: 'Something went wrong $e');
    }
    finally {
      imageLoading.value = false;
    }
  }

  updatePersonalInfo() async{
    try{

    }catch(e){
      AppToasts.errorSnackBar(title: 'Oh Snap', message: 'Something went wrong $e');
    }
  }


  void proceedToDashboard() {
    try {
      AppScreenLoader.openLoadingDialog('Setting up ');
      if (!onboardingFormKey.currentState!.validate() ||
          !enableHeyNuraVoice.value) {
        AppScreenLoader.stopLoading();
        return;
      }
      Get.offAll(() => NavigationMenu(), duration: Duration(seconds: 0));
    } catch (e) {
      AppScreenLoader.stopLoading();
      throw AppToasts.errorSnackBar(title: 'Something went wrong ${e.toString()}');
    }
  }

  //
  void saveSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      AppScreenLoader.openLoadingDialog('Saving setting');
      final token = await user?.getIdToken();
      print('Hey this is the token $token');
       await appService.savePatientSettings(SettingsModel(notifications: NotificationModel(
              appointmentReminders: enableAppointmentReminders.value,
              messageAlerts: enableMessageAlerts.value),
          security: SecurityModel(twoFactorAuth: enable2Fa.value)), user);
      AppScreenLoader.stopLoading();
      AppToasts.successSnackBar(title: 'Settings has been saved!');
    }catch(e){
      AppScreenLoader.stopLoading();
      AppToasts.errorSnackBar(title: 'Something went wrong ${e.toString()}');
    }
  }

  void savePersonalInfo() async{
    final user = FirebaseAuth.instance.currentUser;
    try {
      AppScreenLoader.openLoadingDialog('Saving Personal Info');
      patient.value.name = editName.text.trim();
      patient.value.email = editEmail.text.trim();
      patient.value.phone = editPhone.text.trim();
      patient.refresh();
      final newPatient = patient.value;
      await appService.updatePatientField(user: user,patient: newPatient);
      AppScreenLoader.stopLoading();
      AppToasts.successSnackBar(title: 'Personal Info has been saved!');
    }catch(e){
      AppScreenLoader.stopLoading();
      AppToasts.errorSnackBar(title: 'Something went wrong ${e.toString()}');
    }
  }


}