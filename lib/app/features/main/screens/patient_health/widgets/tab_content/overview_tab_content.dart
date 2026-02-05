import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';
import '../../../../../../common/button/custom_arrow_button.dart';
import '../../../../../../common/rounded_containers/rounded_container.dart';
import '../../../../../../utilities/constants/colors.dart';
import '../../../../../../utilities/constants/icons.dart';
import '../../../../controllers/patient/patient_controller.dart';
import '../../../../controllers/patient/patient_health_controller.dart';

class OverviewTabContent extends StatelessWidget {
  const OverviewTabContent({super.key, required this.patientController});

  final PatientController patientController;

  @override
  Widget build(BuildContext context) {
    final healthController = Get.find<PatientHealthController>();
    final clinicalResponse = patientController.patient.value.clinicalResponse;

    return Obx(() {
      if (clinicalResponse?.vitals.isEmpty != false) {
        return Column(
          children: [
            const Center(
              child: Column(
                children: [
                  SizedBox(height: 150),
                  Text(
                    'No clinical overview yet',
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

      return SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    healthController.setToday();
                  },
                  child: RoundedContainer(
                    child: const Text(
                      'Today',
                      style: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 14,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),

                CustomArrowButton(
                  icon: Icons.arrow_back_ios_sharp,
                  onPressed: () {
                    healthController.previousDay();
                  },
                ),
                const SizedBox(width: 5),
                Text(
                  healthController.formatDate(
                    healthController.selectedDate.value,
                  ),
                  style: const TextStyle(
                    fontFamily: 'Poppins-Regular',
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 5),
                CustomArrowButton(
                  icon: Icons.arrow_forward_ios_sharp,
                  onPressed: () {
                    healthController.nextDay();
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildContent(clinicalResponse, healthController),
          ],
        ),
      );
    });
  }

  Widget _buildContent(
    dynamic clinicalResponse,
    PatientHealthController healthController,
  ) {
    // Filter vitals by selected date
    final vitalsForDate = healthController.getVitalsForDate(
      clinicalResponse!.vitals,
    );

    // Filter test results by selected date
    final testResultsForDate = healthController.getTestResultsForDate(
      clinicalResponse.testResults,
    );

    // Filter medications by selected date
    final medicationsForDate = healthController.getMedicationsForDate(
      clinicalResponse.medications,
    );

    // If no data for selected date, show message
    if (vitalsForDate.isEmpty &&
        testResultsForDate.isEmpty &&
        medicationsForDate.isEmpty) {
      return Column(
        children: [
          const SizedBox(height: 50),
          Center(
            child: Text(
              'No data available for ${healthController.formatDate(healthController.selectedDate.value)}',
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins-Regular',
                color: AppColors.black300,
              ),
            ),
          ),
          const SizedBox(height: 150),
        ],
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Show vitals only if available for selected date
          if (vitalsForDate.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.black300, width: 0.3),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        RoundedContainer(
                          padding: 10,
                          borderRadius: 10,
                          child: Row(
                            children: [
                              SvgIcon(AppIcons.heart, size: 20),
                              const SizedBox(width: 10),
                              const Text(
                                'Vitals',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins-Medium',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        RoundedContainer(
                          padding: 10,
                          child: Text(
                            healthController.formatDate(
                              healthController.selectedDate.value,
                            ),
                            style: const TextStyle(
                              fontFamily: 'Poppins-Regular',
                              fontSize: 16,
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    /// ✅ Vital Values
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${vitalsForDate.first.bglValue} mg/dt',
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins-Medium',
                              ),
                            ),
                            const Text(
                              'Blood glucose level',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.black300,
                                fontFamily: 'Poppins-Regular',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 32),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${vitalsForDate.first.weightValue} kg',
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins-Medium',
                              ),
                            ),
                            const Text(
                              'Weight',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.black300,
                                fontFamily: 'Poppins-Regular',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${vitalsForDate.first.heartRate} bpm',
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins-Medium',
                              ),
                            ),
                            const Text(
                              'Heart rate',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.black300,
                                fontFamily: 'Poppins-Regular',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 85),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${vitalsForDate.first.oxygenSatValue}%',
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins-Medium',
                              ),
                            ),
                            const Text(
                              'Oxygen saturation',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.black300,
                                fontFamily: 'Poppins-Regular',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${vitalsForDate.first.bodyTempValue}°F',
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins-Medium',
                              ),
                            ),
                            const Text(
                              'Body temperature',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.black300,
                                fontFamily: 'Poppins-Regular',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 32),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${vitalsForDate.first.bpValue} mmHg',
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins-Medium',
                              ),
                            ),
                            const Text(
                              'Blood pressure',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.black300,
                                fontFamily: 'Poppins-Regular',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 20),

          /// Test Results - Show only if available for selected date
          if (testResultsForDate.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.black300, width: 0.3),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 15,
                  bottom: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        RoundedContainer(
                          padding: 10,
                          borderRadius: 10,
                          child: Row(
                            children: [
                              SvgIcon(AppIcons.clipboard),
                              SizedBox(width: 10),
                              Text(
                                'Test Results',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins-Medium',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 15),
                        RoundedContainer(
                          padding: 10,
                          child: Text(
                            healthController.formatDate(
                              healthController.selectedDate.value,
                            ),
                            style: TextStyle(
                              fontFamily: 'Poppins-Regular',
                              fontSize: 16,
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          testResultsForDate.first.testName,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins-Medium',
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '02: 00 PM',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.black300,
                            fontFamily: 'Poppins-Regular',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          testResultsForDate.first.observation,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins-Medium',
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          testResultsForDate.first.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.black300,
                            fontFamily: 'Poppins-Regular',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          SizedBox(height: 20),

          ///Medications - Show only if available for selected date
          if (medicationsForDate.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.black300, width: 0.3),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 15,
                  bottom: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        RoundedContainer(
                          padding: 10,
                          borderRadius: 10,
                          child: Row(
                            children: [
                              SvgIcon(AppIcons.clipboard),
                              SizedBox(width: 10),
                              Text(
                                'Medications',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins-Medium',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 15),
                        RoundedContainer(
                          padding: 10,
                          child: Text(
                            healthController.formatDate(
                              healthController.selectedDate.value,
                            ),
                            style: TextStyle(
                              fontFamily: 'Poppins-Regular',
                              fontSize: 16,
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicationsForDate.first.medName,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins-Regular',
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${medicationsForDate.first.noOfCapsules}. 02:00 PM',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.black300,
                            fontFamily: 'Poppins-Regular',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    // SizedBox(height: 10),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       'Routine Medicine',
                    //       style: TextStyle(
                    //         fontSize: 16,
                    //         fontFamily: 'Poppins-Regular',
                    //       ),
                    //     ),
                    //     SizedBox(height: 5),
                    //     Text(
                    //       'No observations or notes',
                    //       style: TextStyle(
                    //         fontSize: 14,
                    //         color: AppColors.black300,
                    //         fontFamily: 'Poppins-Regular',
                    //       ),
                    //     ),
                    //     SizedBox(height: 20),
                    //     Text(
                    //       'Indever 20',
                    //       style: TextStyle(
                    //         fontSize: 16,
                    //         fontFamily: 'Poppins-Regular',
                    //       ),
                    //     ),
                    //     SizedBox(height: 5),
                    //     Text(
                    //       '1 Pill. 02:20 PM',
                    //       style: TextStyle(
                    //         fontSize: 14,
                    //         color: AppColors.black300,
                    //         fontFamily: 'Poppins-Regular',
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: 10),
                    // Divider(),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Observation',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins-Regular',
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          medicationsForDate.first.observation,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.black300,
                            fontFamily: 'Poppins-Regular',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          SizedBox(height: 210),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
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
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
