import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nurahelp/app/common/custom_switch/custom_switch.dart';
import 'package:nurahelp/app/common/search_bar/search_bar.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/features/main/screens/doctors/widgets/doctor_card.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';
import '../../../../common/appbar/appbar_with_bell.dart';

class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PatientController>();

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, child: AppBarWithBell()),
          Positioned.fill(
            top: 120,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 150,
                      child: CustomSwitch(
                        firstOptionText: 'Current',
                        secondOptionText: 'Previous',
                      ),
                    ),
                    SizedBox(height: 30),
                    AppSearchBar(hintText: 'Search doctor by name'),
                    SizedBox(height: 15),
                    Obx(
                      () => controller.patient.value.doctor == null
                          ? _buildNoDoctorView(context, controller)
                          : Column(
                              children: [
                                DoctorCard(
                                  doctor: controller.patient.value.doctor!,
                                ),
                              ],
                            ),
                    ),
                    SizedBox(height: 90),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDoctorView(
    BuildContext context,
    PatientController patientController,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Symbols.medical_services_rounded,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 20),
            const Text(
              'No Doctors Yet',
              style: TextStyle(fontSize: 20, fontFamily: 'Poppins-SemiBold'),
            ),
            const SizedBox(height: 10),
            Text(
              'You haven\'t linked any doctor to your account yet',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins-Regular',
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () =>
                    patientController.showLinkDoctorBottomSheet(context),
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
}
