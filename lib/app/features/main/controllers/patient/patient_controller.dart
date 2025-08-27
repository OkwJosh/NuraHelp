import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurahelp/app/data/models/clinical_response.dart';
import 'package:nurahelp/app/data/models/patient_model.dart';
import 'package:nurahelp/app/data/models/settings_model/notification_model.dart';
import 'package:nurahelp/app/data/models/settings_model/security_model.dart';
import 'package:nurahelp/app/data/models/settings_model/settings_model.dart';
import 'package:nurahelp/app/data/services/network_manager.dart';
import 'package:nurahelp/app/utilities/loaders/loaders.dart';
import 'package:nurahelp/app/utilities/popups/screen_loader.dart';
import '../../../../data/services/app_service.dart';
import '../../../../nav_menu.dart';

class PatientController extends GetxController {
  static PatientController get instance => Get.find();


  final imageLoading = false.obs;
  Rx<PatientModel> patient = PatientModel.empty().obs;
  Rx<SettingsModel> settings = SettingsModel.empty().obs;
  // Rx<ClinicalResponse> clinicResponse = ClinicalResponse.empty().obs;
  Rx<bool> proceedToDashboardIsClicked = false.obs;
  Rx<bool> enableHeyNuraVoice = false.obs;
  final appService = AppService.instance;
  GlobalKey<FormState> onboardingFormKey = GlobalKey<FormState>();
  Rx<String>? selectedValue;
  Rx<bool> enableAppointmentReminders = false.obs;
  Rx<bool> enableMessageAlerts = false.obs;
  Rx<bool> enable2Fa = false.obs;
  final TextEditingController editName = TextEditingController();
  final TextEditingController editEmail = TextEditingController();
  final TextEditingController editPhone = TextEditingController();


  @override
  void onInit(){
    super.onInit();
    enableAppointmentReminders.value = settings.value.notifications.appointmentReminders;
    enableMessageAlerts.value = settings.value.notifications.messageAlerts;
    enable2Fa.value = settings.value.security.twoFactorAuth;
    _initializeController();
  }

  Future<void> _initializeController() async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    print('Hey this is the token $token');

  }

  int getAge(DateTime? date) {
    int dateNow =
    (DateTime.now().microsecondsSinceEpoch / (31.536 * math.pow(10, 12)))
        .toInt();
    int dateThen = (date!.microsecondsSinceEpoch / (31.536 * math.pow(10, 12)))
        .toInt();

    return dateNow - dateThen;
  }


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
        print('Hey this !!!!!!!!!!!!!!!!!! is the token $token');
        final imageUrl = await appService.uploadImage('Patient/Profile/', image);
        patient.value.profilePicture = imageUrl;
        patient.refresh();
        print('This is it${patient.value.profilePicture}');
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


  Future<void> proceedToDashboard() async {
    final isConnected = await AppNetworkManager.instance.isConnected();
    if (!isConnected) {
      AppScreenLoader.stopLoading();
      AppToasts.warningSnackBar(
        title: 'No Internet Connection',
        message: 'Connect to the internet to continue',
      );
      return;
    }
    try {
      AppScreenLoader.openLoadingDialog('Setting up ');
      if (!onboardingFormKey.currentState!.validate() ||
          !enableHeyNuraVoice.value) {
        AppScreenLoader.stopLoading();
        return;
      }
      final currentUser = FirebaseAuth.instance.currentUser;
      final newPatient = await appService.fetchPatientRecord(currentUser);
      final settings = await appService.fetchPatientSettings(currentUser);

      patient.value = newPatient;
      enableMessageAlerts.value = settings.notifications.messageAlerts;
      enableAppointmentReminders.value = settings.notifications.appointmentReminders;
      enable2Fa.value = settings.security.twoFactorAuth;
      Get.offAll(() => NavigationMenu(), duration: Duration(seconds: 0));
    } catch (e) {
      AppScreenLoader.stopLoading();
      throw AppToasts.errorSnackBar(title: 'Something went wrong ${e.toString()}');
    }
  }

  void saveSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      AppScreenLoader.openLoadingDialog('Saving setting');
      final token = await user?.getIdToken();
      print('Hey this is the token $token');
      final newSettings = SettingsModel(notifications: NotificationModel(
          appointmentReminders: enableAppointmentReminders.value,
          messageAlerts: enableMessageAlerts.value),
          security: SecurityModel(twoFactorAuth: enable2Fa.value));
      print(newSettings.notifications.appointmentReminders);
      print(newSettings.notifications.messageAlerts);
      print(newSettings.security.twoFactorAuth);
      await appService.savePatientSettings(newSettings,user);
      print('This is the settings ${settings}');
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