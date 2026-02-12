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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 360;
    final baseFontSize = isSmall ? 13.0 : 14.0;
    final titleFontSize = isSmall ? 14.0 : 16.0;

    return Obx(() {
      // Access clinicalResponse INSIDE Obx so it reacts to patient changes
      final clinicalResponse = patientController.patient.value.clinicalResponse;

      if (clinicalResponse?.vitals.isEmpty != false) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 100),
            child: Text(
              'No clinical overview yet',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins-Regular',
                color: AppColors.black300,
              ),
            ),
          ),
        );
      }

      // Filter data by selected date
      final vitalsForDate = healthController.getVitalsForDate(
        clinicalResponse!.vitals,
      );
      final testResultsForDate = healthController.getTestResultsForDate(
        clinicalResponse.testResults,
      );
      final medicationsForDate = healthController.getMedicationsForDate(
        clinicalResponse.medications,
      );

      return SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildDateNavRow(healthController, baseFontSize),
            const SizedBox(height: 10),
            if (vitalsForDate.isEmpty &&
                testResultsForDate.isEmpty &&
                medicationsForDate.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Center(
                  child: Text(
                    'No data available for ${healthController.formatDate(healthController.selectedDate.value)}',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontFamily: 'Poppins-Regular',
                      color: AppColors.black300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else ...[
              if (vitalsForDate.isNotEmpty)
                _buildVitalsCard(
                  vitalsForDate,
                  healthController,
                  baseFontSize,
                  titleFontSize,
                ),
              const SizedBox(height: 20),
              if (testResultsForDate.isNotEmpty)
                _buildTestResultsCard(
                  testResultsForDate,
                  healthController,
                  baseFontSize,
                  titleFontSize,
                ),
              const SizedBox(height: 20),
              if (medicationsForDate.isNotEmpty)
                _buildMedicationsCard(
                  medicationsForDate,
                  healthController,
                  baseFontSize,
                  titleFontSize,
                ),
              const SizedBox(height: 120),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildDateNavRow(
    PatientHealthController healthController,
    double baseFontSize,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () => healthController.setToday(),
          child: RoundedContainer(
            child: Text(
              'Today',
              style: TextStyle(
                fontFamily: 'Poppins-Regular',
                fontSize: baseFontSize,
                color: AppColors.black,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        CustomArrowButton(
          icon: Icons.arrow_back_ios_sharp,
          onPressed: () => healthController.previousDay(),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            healthController.formatDate(healthController.selectedDate.value),
            style: TextStyle(
              fontFamily: 'Poppins-Regular',
              fontSize: baseFontSize + 2,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        CustomArrowButton(
          icon: Icons.arrow_forward_ios_sharp,
          onPressed: () => healthController.nextDay(),
        ),
      ],
    );
  }

  Widget _buildVitalRow(
    String value1,
    String label1,
    String value2,
    String label2,
    double baseFontSize,
    double titleFontSize,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value1,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontFamily: 'Poppins-Medium',
                ),
              ),
              Text(
                label1,
                style: TextStyle(
                  fontSize: baseFontSize,
                  color: AppColors.black300,
                  fontFamily: 'Poppins-Regular',
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value2,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontFamily: 'Poppins-Medium',
                ),
              ),
              Text(
                label2,
                style: TextStyle(
                  fontSize: baseFontSize,
                  color: AppColors.black300,
                  fontFamily: 'Poppins-Regular',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVitalsCard(
    List vitalsForDate,
    PatientHealthController healthController,
    double baseFontSize,
    double titleFontSize,
  ) {
    final vital = vitalsForDate.first;

    return Container(
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
                Flexible(
                  child: RoundedContainer(
                    padding: 10,
                    borderRadius: 10,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgIcon(AppIcons.heart, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          'Vitals',
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontFamily: 'Poppins-Medium',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: RoundedContainer(
                    padding: 10,
                    child: Text(
                      healthController.formatDate(
                        healthController.selectedDate.value,
                      ),
                      style: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: titleFontSize,
                        letterSpacing: -1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            _buildVitalRow(
              '${vital.bglValue} mg/dt',
              'Blood glucose level',
              '${vital.weightValue} kg',
              'Weight',
              baseFontSize,
              titleFontSize,
            ),
            const SizedBox(height: 24),
            _buildVitalRow(
              '${vital.heartRate} bpm',
              'Heart rate',
              '${vital.oxygenSatValue}%',
              'Oxygen saturation',
              baseFontSize,
              titleFontSize,
            ),
            const SizedBox(height: 24),
            _buildVitalRow(
              '${vital.bodyTempValue}°F',
              'Body temperature',
              '${vital.bpValue} mmHg',
              'Blood pressure',
              baseFontSize,
              titleFontSize,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestResultsCard(
    List testResultsForDate,
    PatientHealthController healthController,
    double baseFontSize,
    double titleFontSize,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.black300, width: 0.3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: RoundedContainer(
                    padding: 10,
                    borderRadius: 10,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgIcon(AppIcons.clipboard),
                        const SizedBox(width: 10),
                        Text(
                          'Test Results',
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontFamily: 'Poppins-Medium',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: RoundedContainer(
                    padding: 10,
                    child: Text(
                      healthController.formatDate(
                        healthController.selectedDate.value,
                      ),
                      style: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: titleFontSize,
                        letterSpacing: -1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Text(
              testResultsForDate.first.testName,
              style: TextStyle(
                fontSize: titleFontSize,
                fontFamily: 'Poppins-Medium',
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '02: 00 PM',
              style: TextStyle(
                fontSize: baseFontSize,
                color: AppColors.black300,
                fontFamily: 'Poppins-Regular',
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            Text(
              testResultsForDate.first.observation,
              style: TextStyle(
                fontSize: titleFontSize,
                fontFamily: 'Poppins-Medium',
              ),
            ),
            const SizedBox(height: 5),
            Text(
              testResultsForDate.first.description,
              style: TextStyle(
                fontSize: baseFontSize,
                color: AppColors.black300,
                fontFamily: 'Poppins-Regular',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationsCard(
    List medicationsForDate,
    PatientHealthController healthController,
    double baseFontSize,
    double titleFontSize,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.black300, width: 0.3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: RoundedContainer(
                    padding: 10,
                    borderRadius: 10,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgIcon(AppIcons.clipboard),
                        const SizedBox(width: 10),
                        Text(
                          'Medications',
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontFamily: 'Poppins-Medium',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: RoundedContainer(
                    padding: 10,
                    child: Text(
                      healthController.formatDate(
                        healthController.selectedDate.value,
                      ),
                      style: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: titleFontSize,
                        letterSpacing: -1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Text(
              medicationsForDate.first.medName,
              style: TextStyle(
                fontSize: titleFontSize,
                fontFamily: 'Poppins-Regular',
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '${medicationsForDate.first.noOfCapsules}. 02:00 PM',
              style: TextStyle(
                fontSize: baseFontSize,
                color: AppColors.black300,
                fontFamily: 'Poppins-Regular',
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            Text(
              'Observation',
              style: TextStyle(
                fontSize: titleFontSize,
                fontFamily: 'Poppins-Regular',
              ),
            ),
            const SizedBox(height: 5),
            Text(
              medicationsForDate.first.observation,
              style: TextStyle(
                fontSize: baseFontSize,
                color: AppColors.black300,
                fontFamily: 'Poppins-Regular',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
