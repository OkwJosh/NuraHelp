import 'package:flutter/material.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';
import '../../../../../../common/button/custom_arrow_button.dart';
import '../../../../../../common/rounded_containers/rounded_container.dart';
import '../../../../../../utilities/constants/colors.dart';
import '../../../../../../utilities/constants/icons.dart';
import '../../../../controllers/patient/patient_controller.dart';

class OverviewTabContent extends StatelessWidget {
  const OverviewTabContent({super.key, required this.patientController});

  final PatientController patientController;

  @override
  Widget build(BuildContext context) {
    final clinicalResponse = patientController.patient.value.clinicalResponse;

    if (clinicalResponse?.vitals?.isEmpty != false) {
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

    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RoundedContainer(
              child: const Text(
                'Today',
                style: TextStyle(
                    fontFamily: 'Poppins-Regular',
                    fontSize: 14,
                    color: AppColors.black),
              ),
            ),
            const SizedBox(width: 15),
            const CustomArrowButton(icon: Icons.arrow_back_ios_sharp),
            const SizedBox(width: 5),
            const Text(
              '17 Jul 2024',
              style: TextStyle(fontFamily: 'Poppins-Regular', fontSize: 16),
            ),
            const SizedBox(width: 5),
            const CustomArrowButton(icon: Icons.arrow_forward_ios_sharp),
          ],
        ),
        const SizedBox(height: 10),

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
                                fontSize: 16, fontFamily: 'Poppins-Medium'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    RoundedContainer(
                      padding: 10,
                      child: const Text(
                        'June 17 ,2024',
                        style: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            fontSize: 16,
                            letterSpacing: -1),
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
                          clinicalResponse!.vitals.first.bglValue,
                          style: const TextStyle(
                              fontSize: 16, fontFamily: 'Poppins-Medium'),
                        ),
                        const Text(
                          'Blood glucose level',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.black300,
                              fontFamily: 'Poppins-Regular'),
                        ),
                      ],
                    ),
                    const SizedBox(width: 32),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clinicalResponse.vitals.first.weightValue,
                          style: const TextStyle(
                              fontSize: 16, fontFamily: 'Poppins-Medium'),
                        ),
                        const Text(
                          'Weight',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.black300,
                              fontFamily: 'Poppins-Regular'),
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
                          clinicalResponse.vitals.first.heartRate,
                          style: const TextStyle(
                              fontSize: 16, fontFamily: 'Poppins-Medium'),
                        ),
                        const Text(
                          'Heart rate',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.black300,
                              fontFamily: 'Poppins-Regular'),
                        ),
                      ],
                    ),
                    const SizedBox(width: 85),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clinicalResponse.vitals.first.oxygenSatValue,
                          style: const TextStyle(
                              fontSize: 16, fontFamily: 'Poppins-Medium'),
                        ),
                        const Text(
                          'Oxygen saturation',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.black300,
                              fontFamily: 'Poppins-Regular'),
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
                          clinicalResponse.vitals.first.bodyTempValue,
                          style: const TextStyle(
                              fontSize: 16, fontFamily: 'Poppins-Medium'),
                        ),
                        const Text(
                          'Body temperature',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.black300,
                              fontFamily: 'Poppins-Regular'),
                        ),
                      ],
                    ),
                    const SizedBox(width: 32),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clinicalResponse.vitals.first.bpValue,
                          style: const TextStyle(
                              fontSize: 16, fontFamily: 'Poppins-Medium'),
                        ),
                        const Text(
                          'Blood pressure',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.black300,
                              fontFamily: 'Poppins-Regular'),
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
        /// Test Results - Added proper null/empty check
        if(clinicalResponse.testResults?.isNotEmpty == true)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.black300,width: 0.3),
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
                            Text('Test Results',style: TextStyle(fontSize: 16,fontFamily:'Poppins-Medium',)),
                          ],
                        ),
                      ),
                      SizedBox(width: 15),
                      RoundedContainer(
                        padding: 10,
                        child: Text(
                          'June 17 ,2024',
                          style: TextStyle(fontFamily: 'Poppins-Regular',fontSize: 16,letterSpacing: -1),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(clinicalResponse.testResults.first.testName, style: TextStyle(fontSize: 16,fontFamily:'Poppins-Medium')),
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
                      Text(clinicalResponse.testResults.first.observation, style: TextStyle(fontSize: 16,fontFamily:'Poppins-Medium')),
                      SizedBox(height: 5),
                      Text(
                        clinicalResponse.testResults.first.description,
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
        ///Medications - Added proper null/empty check
        if(clinicalResponse.medications?.isNotEmpty == true)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.black300,width: 0.3),
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
                            Text('Medications',style: TextStyle(fontSize: 16,fontFamily:'Poppins-Medium'),),
                          ],
                        ),
                      ),
                      SizedBox(width: 15),
                      RoundedContainer(
                        padding: 10,
                        child: Text(
                          'June 17 ,2024',
                          style: TextStyle(fontFamily: 'Poppins-Regular',fontSize: 16,letterSpacing: -1),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(clinicalResponse.medications.first.medName, style: TextStyle(fontSize: 16,fontFamily:'Poppins-Regular')),
                      SizedBox(height: 5),
                      Text(
                        '${clinicalResponse.medications.first.noOfCapsules}. 02:00 PM',
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
                      Text('Routine Medicine', style: TextStyle(fontSize: 16,fontFamily:'Poppins-Regular')),
                      SizedBox(height: 5),
                      Text(
                        'No observations or notes',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.black300,
                          fontFamily: 'Poppins-Regular',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Indever 20', style: TextStyle(fontSize: 16,fontFamily:'Poppins-Regular')),
                      SizedBox(height: 5),
                      Text(
                        '1 Pill. 02:20 PM',
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
                      Text('Emergency', style: TextStyle(fontSize: 16,fontFamily:'Poppins-Regular')),
                      SizedBox(height: 5),
                      Text(
                        clinicalResponse.medications.first.observation,
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
        SizedBox(height: 100),
      ],
    );
  }
}