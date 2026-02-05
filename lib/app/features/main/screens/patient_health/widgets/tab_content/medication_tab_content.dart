import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/uil.dart';
import 'package:nurahelp/app/common/custom_switch/custom_switch.dart';
import 'package:nurahelp/app/common/rounded_containers/rounded_container.dart';
import 'package:nurahelp/app/data/models/medication_model.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_health_controller.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';
import '../../../../../../utilities/constants/colors.dart';

class MedicationTabContent extends StatefulWidget {
  const MedicationTabContent({super.key, required this.patientController});

  final PatientController patientController;

  @override
  State<MedicationTabContent> createState() => _MedicationTabContentState();
}

class _MedicationTabContentState extends State<MedicationTabContent> {
  late Rx<bool> isOngoing;

  @override
  void initState() {
    super.initState();
    isOngoing = true.obs;
  }

  @override
  Widget build(BuildContext context) {
    final healthController = Get.find<PatientHealthController>();
    final clinicalResponse =
        widget.patientController.patient.value.clinicalResponse;

    if (clinicalResponse?.medications.isEmpty != false) {
      return Column(
        children: [
          const Center(
            child: Column(
              children: [
                SizedBox(height: 150),
                Text(
                  'No medications prescribed yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins-Regular',
                    color: AppColors.black300,
                  ),
                ),
                SizedBox(height: 250),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Obx(
          () => GestureDetector(
            onTap: () {
              isOngoing.value = !isOngoing.value;
            },
            child: SizedBox(
              height: 40,
              width: 170,
              child: CustomSwitch(
                firstOptionText: 'Ongoing',
                secondOptionText: 'History',
                firstOptionActive: isOngoing.value,
                secondOptionActive: !isOngoing.value,
                onChanged: (option) {
                  isOngoing.value = option == 1;
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Obx(() {
          // Filter medications based on Ongoing/History toggle
          final filteredMedications = healthController.getMedicationsByStatus(
            clinicalResponse!.medications,
            isOngoing.value,
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (filteredMedications.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(
                    child: Text(
                      isOngoing.value
                          ? 'No ongoing medications'
                          : 'No medication history',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins-Regular',
                        color: AppColors.black300,
                      ),
                    ),
                  ),
                )
              else
                ...filteredMedications
                    .map(
                      (medication) => Column(
                        children: [
                          MedicationCard(medication: medication),
                          const SizedBox(height: 10),
                        ],
                      ),
                    )
                    .toList(),
              const SizedBox(height: 100),
            ],
          );
        }),
      ],
    );
  }
}

class MedicationCard extends StatelessWidget {
  const MedicationCard({super.key, required this.medication});

  final MedicationModel medication;

  String _formatDateRange() {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final startMonth = months[medication.startDate.month - 1];
    final endMonth = months[medication.endDate.month - 1];

    // If same month and year, show: "1 - 16 Feb, 2026"
    if (medication.startDate.month == medication.endDate.month &&
        medication.startDate.year == medication.endDate.year) {
      return '${medication.startDate.day} - ${medication.endDate.day} $endMonth, ${medication.endDate.year}';
    }

    // If different months, show: "1 Feb - 16 Mar, 2026"
    return '${medication.startDate.day} $startMonth - ${medication.endDate.day} $endMonth, ${medication.endDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      elevation: .1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            children: [
              Row(
                children: [
                  SvgIcon(AppIcons.medication, size: 32),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medication.medName,
                          style: TextStyle(
                            fontFamily: 'Poppins-Medium',
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          medication.description,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins-Regular',
                            color: AppColors.black300,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Iconify(Uil.ellipsis_v),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  RoundedContainer(
                    padding: 10,
                    backgroundColor: AppColors.lightsecondaryColor,
                    child: Text(
                      '${medication.noOfCapsules} capsules',
                      style: TextStyle(color: AppColors.deepSecondaryColor),
                    ),
                  ),
                  SizedBox(width: 25),
                  RoundedContainer(
                    padding: 10,
                    backgroundColor: AppColors.lightsecondaryColor,
                    child: Text(
                      _formatDateRange(),
                      style: TextStyle(
                        color: AppColors.deepSecondaryColor,
                        fontSize: 16,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
