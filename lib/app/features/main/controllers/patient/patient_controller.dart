import 'dart:convert';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:nurahelp/app/data/models/patient_model.dart';
import 'package:nurahelp/app/data/models/settings_model/notification_model.dart';
import 'package:nurahelp/app/data/models/settings_model/security_model.dart';
import 'package:nurahelp/app/data/models/settings_model/settings_model.dart';
import 'package:nurahelp/app/data/services/cache_service.dart';
import 'package:nurahelp/app/data/services/network_manager.dart';
import 'package:nurahelp/app/utilities/loaders/loaders.dart';
import 'package:nurahelp/app/utilities/popups/screen_loader.dart';
import '../../../../data/services/app_service.dart';
import '../../../../nav_menu.dart';
import 'package:flutter/material.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';
import 'package:nurahelp/app/utilities/validators/validation.dart';
import 'package:nurahelp/app/data/models/appointment_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PatientController extends GetxController {
  static PatientController get instance => Get.find();

  final imageLoading = false.obs;
  Rx<PatientModel> patient = PatientModel.empty().obs;
  Rx<SettingsModel> settings = SettingsModel.empty().obs;
  final String baseUrl = dotenv.env['NEXT_PUBLIC_API_URL']!;
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
  final formKey = GlobalKey<FormState>();
  final doctorCodeController = TextEditingController();

  // Track canceled appointments locally since backend doesn't return status field
  final RxSet<String> canceledAppointmentIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    enableAppointmentReminders.value =
        settings.value.notifications.appointmentReminders;
    enableMessageAlerts.value = settings.value.notifications.messageAlerts;
    enable2Fa.value = settings.value.security.twoFactorAuth;
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
  void onReady() {
    super.onReady();
    editName.text = patient.value.name;
    editEmail.text = patient.value.email;
    editPhone.text = patient.value.phone;
  }

  formatDate(DateTime? date) {
    String dateSuffix;
    if (date?.day == 1 || date?.day == 21 || date?.day == 31) {
      dateSuffix = 'st';
    } else if (date?.day == 2 || date?.day == 22) {
      dateSuffix = 'nd';
    } else if (date?.day == 3 || date?.day == 23) {
      dateSuffix = 'rd';
    } else {
      dateSuffix = 'th';
    }
    return '${date?.day}$dateSuffix ${date?.month}, ${date?.year}';
  }

  uploadProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 512,
        maxWidth: 512,
      );
      if (image != null) {
        imageLoading.value = true;
        final currentUser = FirebaseAuth.instance.currentUser;
        final imageUrl = await appService.uploadImage(
          'Patient/Profile/',
          image,
        );
        patient.value.profilePicture = imageUrl;
        patient.refresh();
        await appService.updatePatientField(
          user: currentUser,
          patient: patient.value,
        );
        AppToasts.successSnackBar(
          title: 'Congratulations',
          message: 'Your profile image has been updated',
        );
      }
    } catch (e) {
      AppToasts.errorSnackBar(
        title: 'Oh Snap',
        message: 'Something went wrong $e',
      );
    } finally {
      imageLoading.value = false;
    }
  }

  updatePersonalInfo() async {
    try {} catch (e) {
      AppToasts.errorSnackBar(
        title: 'Oh Snap',
        message: 'Something went wrong $e',
      );
    }
  }

  Future<void> proceedToDashboard() async {
    final isConnected = await AppNetworkManager.instance.isConnected();
    if (!isConnected) {
      AppToasts.warningSnackBar(
        title: 'No Internet',
        message: 'Please connect to continue.',
      );
      return;
    }

    try {
      AppScreenLoader.openLoadingDialog('Syncing Medical Records...');
      final currentUser = FirebaseAuth.instance.currentUser;

      // 🔥 PARALLEL FETCH: All requests start at the same time
      final results = await Future.wait([
        appService.fetchPatientRecord(currentUser),
        appService.fetchPatientSettings(currentUser),
        appService.fetchAppointments(currentUser), // The new pure fetcher
      ]);

      final newPatient = results[0] as PatientModel;
      final freshAppointments = results[2] as List<AppointmentModel>;

      // Merge data into the reactive model
      newPatient.appointments = freshAppointments;
      patient.value = newPatient;
      patient.refresh();

      // Cache the fully merged object ONCE
      await CacheService.instance.cachePatient(newPatient.toJson());

      AppScreenLoader.stopLoading();
      Get.offAll(() => NavigationMenu());
    } catch (e) {
      AppScreenLoader.stopLoading();
      AppToasts.errorSnackBar(title: 'Sync Failed', message: e.toString());
    }
  }

  void saveSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      AppScreenLoader.openLoadingDialog('Saving setting');
      final newSettings = SettingsModel(
        notifications: NotificationModel(
          appointmentReminders: enableAppointmentReminders.value,
          messageAlerts: enableMessageAlerts.value,
        ),
        security: SecurityModel(twoFactorAuth: enable2Fa.value),
      );
      await appService.savePatientSettings(newSettings, user);
      AppScreenLoader.stopLoading();
      AppToasts.successSnackBar(title: 'Settings has been saved!');
    } catch (e) {
      AppScreenLoader.stopLoading();
      AppToasts.errorSnackBar(title: 'Something went wrong ${e.toString()}');
    }
  }

  void savePersonalInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      AppScreenLoader.openLoadingDialog('Saving Personal Info');
      patient.value.name = editName.text.trim();
      patient.value.email = editEmail.text.trim();
      patient.value.phone = editPhone.text.trim();
      patient.refresh();
      final newPatient = patient.value;
      await appService.updatePatientField(user: user, patient: newPatient);
      AppScreenLoader.stopLoading();
      AppToasts.successSnackBar(title: 'Personal Info has been saved!');
    } catch (e) {
      AppScreenLoader.stopLoading();
      AppToasts.errorSnackBar(title: 'Something went wrong ${e.toString()}');
    }
  }

  Future<void> linkDoctor(String inviteCode) async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      AppScreenLoader.openLoadingDialog('Linking Doctor');
      await appService.linkDoctorToPatient(inviteCode, user);
      final updatedPatient = await appService.fetchPatientRecord(user);
      patient.value = updatedPatient;
      patient.refresh();
      AppScreenLoader.stopLoading();
      AppToasts.successSnackBar(title: 'Doctor has been linked successfully!');
    } catch (e) {
      AppScreenLoader.stopLoading();
      AppToasts.errorSnackBar(title: 'Something went wrong ${e.toString()}');
    }
  }

  void showLinkDoctorBottomSheet(BuildContext context) {
    final _controller = Get.find<PatientController>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgIcon(AppIcons.health, size: 30),
                    const SizedBox(width: 10),
                    const Text(
                      'Link Doctor',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins-SemiBold',
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Enter your doctor\'s unique code to link them to your account',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins-Regular',
                    color: AppColors.black300,
                  ),
                ),
                const SizedBox(height: 25),
                Form(
                  key: _controller.formKey,
                  child: TextFormField(
                    controller: _controller.doctorCodeController,
                    validator: (value) =>
                        AppValidator.validateTextField('Doctor code', value),
                    cursorColor: AppColors.black,
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontFamily: 'Poppins-Regular',
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Enter doctor code',
                      hintStyle: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            _controller.doctorCodeController.clear();
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.black300),
                            overlayColor: AppColors.black300.withOpacity(0.1),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 14,
                              fontFamily: 'Poppins-Medium',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_controller.formKey.currentState!.validate()) {
                              await _controller.linkDoctor(
                                _controller.doctorCodeController.text,
                              );
                              _controller.doctorCodeController.clear();
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: 'Poppins-Medium',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, String>> _getHeaders(User? user, bool acceptValue) async {
    String? token;
    try {
      token = await user?.getIdToken().timeout(const Duration(seconds: 5));
    } catch (e) {
      token = await user?.getIdToken();
    }

    return {
      if (token != null) 'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': acceptValue ? '*/*' : 'application/json',
    };
  }

  Future<void> cancelAppointment(String appointmentId) async {
    AppScreenLoader.openLoadingDialog('Canceling appointment...');
    try {
      final user = FirebaseAuth.instance.currentUser;
      final response = await http.put(
        Uri.parse('$baseUrl/api/v1/appointments/cancel/'),
        headers: await _getHeaders(user, false),
        body: jsonEncode({'appointmentId': appointmentId}),
      );

      if (response.statusCode == 200) {
        // 1. Update the local reactive list
        final index =
            patient.value.appointments?.indexWhere(
              (a) => a.id == appointmentId,
            ) ??
            -1;
        if (index != -1) {
          // Use copyWith if available, otherwise modify the object
          patient.value.appointments![index].status = 'Canceled';
          canceledAppointmentIds.add(appointmentId);

          // 2. Trigger GetX refresh
          patient.refresh();

          // 3. 🔥 CRITICAL: Update Cache so the status persists
          await CacheService.instance.cachePatient(patient.value.toJson());
        }

        AppScreenLoader.stopLoading();
        AppToasts.successSnackBar(
          title: 'Success',
          message: 'Appointment canceled',
        );
      }
    } catch (e) {
      AppScreenLoader.stopLoading();
      AppToasts.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}
