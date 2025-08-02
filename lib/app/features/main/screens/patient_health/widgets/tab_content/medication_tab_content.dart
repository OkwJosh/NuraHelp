import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/uil.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nurahelp/app/common/custom_switch/custom_switch.dart';
import 'package:nurahelp/app/common/rounded_containers/rounded_container.dart';
import 'package:nurahelp/app/common/search_bar/search_bar.dart';
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
          width: 150,
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
                  Icon(Symbols.pill),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amoxicillin 250mg'),
                      SizedBox(height: 2),
                      Text(
                        'Antibiotic for bacterial infection',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins-ExtraLight',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 50),
                  Iconify(Uil.ellipsis_v),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  RoundedContainer(
                    padding: 10,
                    backgroundColor: AppColors.secondaryColor.withOpacity(0.15),
                    child: Text(
                      '14 capsules',
                      style: TextStyle(color: AppColors.deepSecondaryColor),
                    ),
                  ),
                  SizedBox(width: 25),
                  RoundedContainer(
                    padding: 10,
                    backgroundColor: AppColors.secondaryColor.withOpacity(0.15),
                    child: Text(
                      '14 - 30 May, 2024',
                      style: TextStyle(color: AppColors.deepSecondaryColor),
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
