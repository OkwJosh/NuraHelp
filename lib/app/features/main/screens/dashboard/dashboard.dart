import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/common/appbar/appbar_with_bell.dart';
import 'package:nurahelp/app/common/message_field/message_field.dart';
import 'package:nurahelp/app/common/shimmer/shimmer_effect.dart';
import 'package:nurahelp/app/common/widgets/coming_soon_screen.dart';
import 'package:nurahelp/app/common/widgets/no_internet_screen.dart';
import 'package:nurahelp/app/data/controllers/file_controller.dart';
import 'package:nurahelp/app/features/main/controllers/dashboard/dashboard_controller.dart';
import 'package:nurahelp/app/features/main/controllers/nura_bot/nura_bot_controller.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/features/main/screens/messages_and_calls/direct_message.dart';
import 'package:nurahelp/app/features/main/screens/nura_bot/nura_bot.dart';
import 'package:nurahelp/app/modules/patient/views/dashboard/dashboard_shimmer.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import '../../../../common/appointment_card/appointment_card.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final PatientController controller;
  late final NuraBotController nuraController;
  late final DashboardController dashboardController;
  late final FileController fileController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<PatientController>();
    nuraController = Get.find<NuraBotController>();
    dashboardController = Get.put(DashboardController());
    fileController = Get.find<FileController>();

    // Unfocus text field when entering dashboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _unfocusKeyboard();
    });
  }

  void _unfocusKeyboard() {
    FocusScope.of(context).unfocus();
    // Also clear the text to prevent keyboard activation on return
    nuraController.messageController.clear();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 1. Critical Error: No Internet and NO cached data
      if (dashboardController.hasNoInternet.value &&
          controller.patient.value.name.isEmpty) {
        return NoInternetScreen(
          onRetry: () => dashboardController.refreshDashboardData(),
        );
      }

      // 2. Loading State: Show shimmer if we're loading and have no cached data to show
      if (dashboardController.isLoading.value &&
          controller.patient.value.name.isEmpty) {
        return const DashboardShimmer();
      }

      // 3. Reactive UI: Show the dashboard (it will update live as parallel calls finish)
      return _buildDashboard(context);
    });
  }

  Widget _buildDashboard(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBell(showSearchBar: false, dynamicAppIcon: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: RefreshIndicator(
            backgroundColor: Colors.white,
            color: AppColors.secondaryColor,
            onRefresh: () => dashboardController.refreshDashboardData(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    elevation: 0.2,
                    child: Container(
                      height: 65,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Obx(
                        () => Center(
                          child: controller.patient.value.name == ''
                              ? const AppShimmerEffect(
                                  width: 300,
                                  height: 30,
                                  radius: 5,
                                )
                              : Text(
                                  'Welcome back, ${controller.patient.value.name.split(" ").first}',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins-SemiBold',
                                    fontSize: 18,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Quick Access Panel',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 15),

                  Obx(
                    () => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (controller.patient.value.doctor == null)
                            _buildAddDoctorCard(context, controller)
                          else ...[
                            // Show appointment card if there are appointments
                            if (controller
                                    .patient
                                    .value
                                    ?.appointments
                                    .isNotEmpty ==
                                true) ...[
                              AppointmentCard(
                                patientController: controller,
                                isVirtual: false,
                                appointment: controller
                                    .patient
                                    .value!
                                    .appointments
                                    .first,
                                showStatus: true,
                              ),
                              const SizedBox(width: 10),
                            ],
                            // Always show quick action cards when doctor is linked
                            _buildMessageDoctorCard(context, controller),
                            const SizedBox(width: 10),
                            _buildCheckBPCard(context, controller),
                          ],
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.17),

                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'What\'s on the agenda today ?',
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Poppins-Medium',
                            letterSpacing: -2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          showBorder: false,
                          controller: nuraController.messageController,
                          hint:
                              'Hey ${controller.patient.value.name.split(" ").first}, type to ask anything',
                          onSendButtonPressed: () async {
                            final focusScope = FocusScope.of(context);
                            focusScope.unfocus();
                            await Future.delayed(
                              const Duration(milliseconds: 250),
                            );
                            Get.to(
                              () => const NuraBot(),
                              transition: Transition.rightToLeftWithFade,
                            );
                            nuraController.sendBotMessage(
                              patient: controller.patient.value,
                            );
                          },
                          onMicButtonPressed: () {
                            // Navigate to NuraBot then start recording
                            Get.to(
                              () => const NuraBot(),
                              transition: Transition.rightToLeftWithFade,
                            );
                            // Small delay so the NuraBot screen mounts first
                            Future.delayed(
                              const Duration(milliseconds: 300),
                              () => nuraController.startVoiceRecording(),
                            );
                          },
                          onAttachButtonPressed: () {
                            nuraController.showAttachmentOptions();
                          },
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddDoctorCard(
    BuildContext context,
    PatientController patientController,
  ) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      elevation: 0.3,
      shadowColor: Colors.black,
      child: Container(
        width: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'No Doctor Assigned Yet',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-SemiBold'),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your primary care doctor to get started',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins-Light',
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              // height: 45,
              child: ElevatedButton.icon(
                onPressed: () =>
                    patientController.showLinkDoctorBottomSheet(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.link, color: Colors.white),
                label: const Text(
                  'Link Doctor',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins-Medium',
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageDoctorCard(
    BuildContext context,
    PatientController patientController,
  ) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      elevation: 0.3,
      shadowColor: Colors.black,
      child: Container(
        width: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Message Your Doctor',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-SemiBold'),
            ),
            const SizedBox(height: 8),
            Text(
              'Send a message to Dr. ${patientController.patient.value.doctor?.name.split(" ").first ?? ""}',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins-Light',
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final doctor = patientController.patient.value.doctor;
                  if (doctor != null) {
                    Get.to(() => DirectMessagePage(doctor: doctor));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: SvgPicture.asset(
                  AppIcons.messages,
                  color: Colors.white,
                  width: 20,
                  height: 20,
                ),
                label: const Text(
                  'Send Message',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins-Medium',
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckBPCard(
    BuildContext context,
    PatientController patientController,
  ) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      elevation: 0.3,
      shadowColor: Colors.black,
      child: Container(
        width: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Check Your BP',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-SemiBold'),
            ),
            const SizedBox(height: 8),
            Text(
              'Monitor your blood pressure readings',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins-Light',
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.to(
                    () => const ComingSoonScreen(featureName: 'Blood Pressure'),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.favorite_outline, color: Colors.white),
                label: const Text(
                  'Check BP',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins-Medium',
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
