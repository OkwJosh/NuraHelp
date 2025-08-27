import 'package:flutter/material.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import '../../../../../../common/button/custom_arrow_button.dart';
import '../../../../../../common/rounded_containers/rounded_container.dart';
import '../../../../../../utilities/constants/colors.dart';
import '../test_result_card.dart';

class TestResultTabContent extends StatelessWidget {
  const TestResultTabContent({super.key, required this.patientController});

  final PatientController patientController;

  @override
  Widget build(BuildContext context) {
    final clinicalResponse = patientController.patient.value.clinicalResponse;

    if (clinicalResponse?.testResults?.isEmpty != false) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            RoundedContainer(
              child: Text(
                'Today',
                style: TextStyle(fontFamily: 'Poppins-Regular', fontSize: 14),
              ),
            ),
            SizedBox(width: 15),
            CustomArrowButton(icon: Icons.arrow_back_ios_sharp),
            SizedBox(width: 5),
            Text(
              '17 Jul 2024',
              style: TextStyle(fontFamily: 'Poppins-Regular', fontSize: 16),
            ),
            SizedBox(width: 5),
            CustomArrowButton(icon: Icons.arrow_forward_ios_sharp),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: MediaQuery.of(context).size.height - 500,
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 100),
            itemBuilder: (context, index) {
              return TestResultCard(
                testName: clinicalResponse!.testResults[index].testName,
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: clinicalResponse!.testResults.length,
          ),
        ),
      ],
    );
  }
}
