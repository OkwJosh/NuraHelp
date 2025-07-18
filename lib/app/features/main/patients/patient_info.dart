import 'package:flutter/material.dart';
import 'package:nurahelp/app/common/dropdown/app_dropdown.dart';
import 'package:nurahelp/app/features/main/patients/widgets/patient_info_header.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';

import '../../../common/appbar/appbar_with_bell.dart';

class PatientInfo extends StatelessWidget {
  const PatientInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, child: AppBarWithBell()),
          Positioned.fill(
            top: 110,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PatientInfoHeader(),
                    Divider(),
                    
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


