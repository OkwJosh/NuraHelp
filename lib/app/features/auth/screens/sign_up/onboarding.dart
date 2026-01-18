import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/common/dropdown/app_dropdown.dart';
import 'package:nurahelp/app/features/auth/controllers/sign_up_controllers/sign_up_controller.dart';
import 'package:nurahelp/app/features/auth/screens/sign_up/widget/sign_up_progress_bar.dart';
import 'package:nurahelp/app/utilities/validators/validation.dart';
import '../../../../common/shimmer/shimmer_effect.dart';
import '../../../../utilities/constants/colors.dart';
import '../../../../utilities/constants/icons.dart';
import '../../../../utilities/constants/svg_icons.dart';
import '../../../main/controllers/patient/patient_controller.dart';

class FirstTimeOnBoardingScreen extends StatelessWidget {
  FirstTimeOnBoardingScreen({super.key});

  final controller = Get.find<PatientController>();
  final proceedController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: SignUpProgressBar(
          firstBarColor: AppColors.secondaryColor,
          secondBarColor: AppColors.secondaryColor,
          thirdBarColor: AppColors.secondaryColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 80),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'First-Time\nOnboarding',
                style: const TextStyle(fontFamily: 'Poppins-Medium', fontSize: 38),
              ),
              const SizedBox(height: 10),
              Text(
                'Please fill in your details below',
                style: const TextStyle(
                  fontFamily: 'Poppins-Regular',
                  color: AppColors.black300,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),

              /// ✅ Profile Picture Section
              Center(
                child: Column(
                  children: [
                    Obx(() {
                      final networkImage = controller.patient.value.profilePicture ?? '';
                      if (controller.imageLoading.value) {
                        return Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.greyColor.withOpacity(0.6)),
                          ),
                          child: const AppShimmerEffect(
                            height: 170,
                            width: 170,
                            radius: 150,
                          ),
                        );
                      } else if (networkImage.isEmpty) {
                        return Container(
                          width: 165,
                          height: 165,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black),
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: SvgIcon(AppIcons.profile, size: 100),
                          ),
                        );
                      } else {
                        return SizedBox(
                          width: 165,
                          height: 165,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(90),
                            child: CachedNetworkImage(
                              imageUrl: networkImage,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const AppShimmerEffect(
                                height: 130,
                                width: 130,
                                radius: 90,
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                        );
                      }
                    }),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () async => await controller.uploadProfilePicture(),
                      style: TextButton.styleFrom(
                        overlayColor: Colors.black.withOpacity(0.2),
                      ),
                      child: const Text(
                        'Add profile picture',
                        style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 16,
                          color: AppColors.black300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              /// ✅ Language Preference Dropdown
              Column(
                children: [
                  Form(
                    key: controller.onboardingFormKey,
                    child: SizedBox(
                      width: double.infinity,
                      child: AppDropdown(
                        menuItems: const ['English'],
                        verticalPadding: 15,
                        selectedValue: controller.selectedValue?.value,
                        hintText: 'Choose Language Preference',
                        borderRadius: 10,
                        validator: (String? value) =>
                            AppValidator.validateDropdown(value),
                        onChanged: (String? value) {
                          controller.selectedValue?.value = value!;
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// ✅ Voice Activation Checkbox
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox.square(
                    dimension: 20,
                    child: Obx(() {
                      bool showCheckboxError = (controller.proceedToDashboardIsClicked.value &&
                          !controller.enableHeyNuraVoice.value);
                      return Checkbox(
                        isError: showCheckboxError,
                        value: controller.enableHeyNuraVoice.value,
                        onChanged: (value) {
                          controller.enableHeyNuraVoice.value = value!;
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    }),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Enable "Hey Nura" voice activation (optional)',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins-Regular',
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// ✅ Proceed Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.proceedToDashboardIsClicked.value = true;
                    controller.proceedToDashboard();
                  },
                  child: const Text(
                    'Go to Dashboard',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins-Medium',
                      color: Colors.white,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
