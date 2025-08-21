import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/uil.dart';
import 'package:nurahelp/app/common/custom_switch/custom_switch.dart';
import 'package:nurahelp/app/common/rounded_containers/rounded_container.dart';
import 'package:nurahelp/app/common/search_bar/search_bar.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';
import '../../../../../../utilities/constants/colors.dart';

class MedicationTabContent extends StatelessWidget {
  const MedicationTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        SizedBox(
          height: 40,
          width: 170,
          child: CustomSwitch(
            firstOptionText: 'Ongoing',
            secondOptionText: 'History',
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 45,
          child: AppSearchBar(hintText: 'Start typing medication name'),
        ),
        SizedBox(height: 10),
        MedicationCard(),
        SizedBox(height: 10),
        MedicationCard(),
        SizedBox(height: 10),
        MedicationCard(),
        SizedBox(height: 100),
      ],
    );
  }
}

class MedicationCard extends StatelessWidget {
  const MedicationCard({super.key});

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
                  SvgIcon(AppIcons.medication,size: 32),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amoxicillin 250mg',style: TextStyle(fontFamily: 'Poppins-Medium',fontSize: 15)),
                      SizedBox(height: 2),
                      Text(
                        'Antibiotic for bacterial infection',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins-Regular',
                          color: AppColors.black300,
                          letterSpacing: -0.3
                        ),
                      ),
                    ],
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
                      '14 capsules',
                      style: TextStyle(color: AppColors.deepSecondaryColor),
                    ),
                  ),
                  SizedBox(width: 25),
                  RoundedContainer(
                    padding: 10,
                    backgroundColor: AppColors.lightsecondaryColor,
                    child: Text(
                      '14 - 30 May, 2024',
                      style: TextStyle(color: AppColors.deepSecondaryColor,fontSize: 16,letterSpacing: 0),
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
