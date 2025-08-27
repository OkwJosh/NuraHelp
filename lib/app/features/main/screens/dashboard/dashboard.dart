import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/common/appbar/appbar_with_bell.dart';
import 'package:nurahelp/app/common/message_field/message_field.dart';
import 'package:nurahelp/app/common/shimmer/shimmer_effect.dart';
import 'package:nurahelp/app/features/main/controllers/nura_bot/nura_bot_controller.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/features/main/screens/nura_bot/nura_bot.dart';
import '../../../../common/appointment_card/appointment_card.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final controller = Get.find<PatientController>();
  final nuraController = Get.find<NuraBotController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBell(showSearchBar: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
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
                            ? const AppShimmerEffect(width: 300, height: 30, radius: 5)
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


                const Text('Quick Access Panel', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 15),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      AppointmentCard(patientController: controller,isVirtual: false,),
                    ],
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.2),

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
                        hint: 'Hey ${controller.patient.value.name.split(" ").first}, type to ask anything',
                        onSendButtonPressed: () async {
                          final focusScope = FocusScope.of(context);
                          focusScope.unfocus();
                          await Future.delayed(const Duration(milliseconds: 250));
                          Get.to(() => const NuraBot(), transition: Transition.rightToLeftWithFade);
                          nuraController.sendBotMessage(patient: controller.patient.value);
                        },
                        onMicButtonPressed: () {},
                        onAttachButtonPressed: () {},
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
    );
  }
}
