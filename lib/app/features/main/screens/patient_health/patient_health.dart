import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:nurahelp/app/features/main/screens/patient_health/widgets/patient_info_header.dart';
import 'package:nurahelp/app/features/main/screens/patient_health/widgets/tab_content/medication_tab_content.dart';
import 'package:nurahelp/app/features/main/screens/patient_health/widgets/tab_content/overview_tab_content.dart';
import 'package:nurahelp/app/features/main/screens/patient_health/widgets/tab_content/test_result_tab_content.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';

import '../../../../common/appbar/appbar_with_bell.dart';
import '../../../../common/button/chip_button.dart';
import '../../../../common/button/custom_arrow_button.dart';

class PatientHealthScreen extends StatelessWidget {
  const PatientHealthScreen({super.key});

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
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'example@gmail.com',
                                  style: TextStyle(fontFamily: 'Poppins-Light'),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '(234) 912 345 8080',
                                  style: TextStyle(fontFamily: 'Poppins-Light'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide.none,
                            ),
                            side: BorderSide(
                              width: 0.5,
                              color: Colors.grey[400]!,
                            ),
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 10,
                              bottom: 10,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Symbols.edit_square_rounded,
                                color: Colors.black,
                                size: 20,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Edit',
                                style: TextStyle(
                                  fontFamily: 'Poppins-Regular',
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          Container(
                            color:  AppColors.primaryColor,
                            child: TabBar(
                              indicatorColor: Colors.black,
                              dividerColor: Colors.transparent,
                              isScrollable: true,
                              tabAlignment: TabAlignment.start,
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.grey[600],
                              tabs: const [
                                Tab(child: Text("Overview",style: TextStyle(fontFamily: 'Poppins-Medium'),)),
                                Tab(child: Text("Test Result",style: TextStyle(fontFamily: 'Poppins-Medium'),)),
                                Tab(child: Text("Medication",style: TextStyle(fontFamily: 'Poppins-Medium'),)),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          // 🔹 TabBarView (newly added)
                          SizedBox(
                            height: 850,
                            child: TabBarView(
                              children: [
                                // Tab 1: Overview
                                OverviewTabContent(),
                                // Tab 2: Test Result
                                TestResultTabContent(),
                                // Tab 3: Medication
                                MedicationTabContent(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

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

