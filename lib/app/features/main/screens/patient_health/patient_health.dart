import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:nurahelp/app/features/main/screens/patient_health/widgets/patient_info_header.dart';
import 'package:nurahelp/app/features/main/screens/patient_health/widgets/tab_content/medication_tab_content.dart';
import 'package:nurahelp/app/features/main/screens/patient_health/widgets/tab_content/overview_tab_content.dart';
import 'package:nurahelp/app/features/main/screens/patient_health/widgets/tab_content/test_result_tab_content.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';

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
            top: 120,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PatientInfoHeader(),
                    Divider(color: AppColors.black300,thickness: 0.3),
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
                                  style: TextStyle(fontFamily: 'Poppins-Regular'),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '(234) 912 345 8080',
                                  style: TextStyle(fontFamily: 'Poppins-Regular'),
                                ),
                              ],
                            ),
                          ],
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
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelColor: Colors.black,
                              unselectedLabelColor: AppColors.black300,
                              tabs: const [
                                Tab(child: Text("Overview",style: TextStyle(fontFamily: 'Poppins-Medium',fontSize: 16),)),
                                Tab(child: Text("Test Result",style: TextStyle(fontFamily: 'Poppins-Medium',fontSize: 16),)),
                                Tab(child: Text("Medication",style: TextStyle(fontFamily: 'Poppins-Medium',fontSize: 16),)),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          // 🔹 TabBarView (newly added)
                          AutoScaleTabBarView(
                            children: [
                              // Tab 1: Overview
                              OverviewTabContent(),
                              // Tab 2: Test Result
                              TestResultTabContent(),
                              // Tab 3: Medication
                              MedicationTabContent(),
                            ],
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

