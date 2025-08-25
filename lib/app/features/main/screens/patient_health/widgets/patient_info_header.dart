import 'package:flutter/material.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';
import '../../../../../common/dropdown/app_dropdown.dart';
import '../../../../../utilities/constants/colors.dart';

class PatientInfoHeader extends StatelessWidget {
  const PatientInfoHeader({
    super.key, required this.patientController,
  });

  final PatientController patientController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(backgroundColor: Colors.transparent,child: SvgIcon(AppIcons.profile),),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patientController.patient.value.name,
                  style: TextStyle(
                    fontFamily: 'Poppins-Semibold',
                    fontSize: 16,
                    color: AppColors.black600
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Male',
                      style: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Age ${patientController.patient.value.age}',
                      style: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'O+',
                      style: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 5),

      ],
    );
  }
}
