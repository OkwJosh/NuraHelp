import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_health_controller.dart';
import '../../../../../../common/button/custom_arrow_button.dart';
import '../../../../../../common/rounded_containers/rounded_container.dart';
import '../../../../../../utilities/constants/colors.dart';
import '../test_result_card.dart';

class TestResultTabContent extends StatelessWidget {
  const TestResultTabContent({super.key, required this.patientController});

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

      if (clinicalResponse?.testResults.isEmpty != false) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 100),
            child: Text(
              'No test results yet',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins-Regular',
                color: AppColors.black300,
              ),
            ),
          ),
        );
      }

      // Filter test results by selected date
      final testResultsForDate = healthController.getTestResultsForDate(
        clinicalResponse!.testResults,
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
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
                  healthController.formatDate(
                    healthController.selectedDate.value,
                  ),
                  style: TextStyle(
                    fontFamily: 'Poppins-Regular',
                    fontSize: titleFontSize,
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
          ),
          const SizedBox(height: 10),
          if (testResultsForDate.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  'No test results for ${healthController.formatDate(healthController.selectedDate.value)}',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontFamily: 'Poppins-Regular',
                    color: AppColors.black300,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 100),
                itemBuilder: (context, index) {
                  return TestResultCard(
                    testName: testResultsForDate[index].testName,
                    observation: testResultsForDate[index].observation,
                    description: testResultsForDate[index].description,
                    date: testResultsForDate[index].date,
                    viewLink: testResultsForDate[index].viewLink,
                    downloadLink: testResultsForDate[index].downloadLink,
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: testResultsForDate.length,
              ),
            ),
        ],
      );
    });
  }
}
