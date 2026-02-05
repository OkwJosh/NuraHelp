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
    final clinicalResponse = patientController.patient.value.clinicalResponse;

    return Obx(() {
      if (clinicalResponse?.testResults.isEmpty != false) {
        return Column(
          children: [
            const Center(
              child: Column(
                children: [
                  SizedBox(height: 150),
                  Text(
                    'No test results yet',
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
                onTap: () {
                  healthController.setToday();
                },
                child: const RoundedContainer(
                  child: Text(
                    'Today',
                    style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: 14,
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
          if (testResultsForDate.isEmpty)
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Text(
                    'No test results for ${healthController.formatDate(healthController.selectedDate.value)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins-Regular',
                      color: AppColors.black300,
                    ),
                  ),
                  const SizedBox(height: 150),
                ],
              ),
            )
          else
            SingleChildScrollView(
              child: Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                ],
              ),
            ),
        ],
      );
    });
  }
}
