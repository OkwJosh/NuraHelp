import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nurahelp/app/common/appbar/appbar_with_bell.dart';
import 'package:nurahelp/app/common/dropdown/app_dropdown.dart';
import 'package:nurahelp/app/features/main/screens/settings/widgets/profile_info_section.dart';
import 'package:nurahelp/app/nav_menu.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../../utilities/constants/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  dynamic sliderValue = 2.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Row(
              children: [
                IconButton(onPressed: () => Get.offAll(() => NavigationMenu()), icon: Icon(Icons.arrow_back_ios)),
                Text('Settings',style: TextStyle(fontSize: 18),)
              ],
                        ),
            )),
          Positioned.fill(
            top: 90,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Material(
                      elevation: 1,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileInfoSection(),
                            SizedBox(height: 20),
                            Divider(),
                            SizedBox(height: 20),
                            Text(
                              'Voice & Language Preferences',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Enable "Hey Nura" Voice Wake',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Light',
                                    fontSize: 14,
                                  ),
                                ),
                                Switch(
                                  value: true,
                                  onChanged: (value) {},
                                  activeTrackColor: AppColors.secondaryColor,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Voice feedback',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Light',
                                    fontSize: 14,
                                  ),
                                ),
                                Switch(
                                  value: true,
                                  onChanged: (value) {},
                                  activeTrackColor: AppColors.secondaryColor,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Voice Command Sensitivity',style: TextStyle(fontFamily: 'Poppins-Light'),),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Transform.translate(
                                        offset: Offset(-22, 0),
                                        child: SfSliderTheme(
                                          data: SfSliderThemeData(
                                            tooltipBackgroundColor:
                                                AppColors.secondaryColor,

                                            thumbRadius: 5,
                                            thumbColor:
                                                AppColors.secondaryColor,
                                            activeDividerRadius: 3,
                                            activeTrackColor:
                                                AppColors.secondaryColor,
                                            inactiveTrackColor: AppColors
                                                .greyColor
                                                .withOpacity(0.4),
                                            inactiveDividerRadius: 3,
                                            activeDividerColor:
                                                AppColors.secondaryColor,
                                            inactiveDividerColor: AppColors
                                                .greyColor
                                                .withOpacity(0.4),
                                          ),
                                          child: SfSlider(
                                            stepSize: 25,
                                            enableTooltip: true,
                                            value: sliderValue,
                                            onChanged: (dynamic value) {
                                              setState(() {
                                                sliderValue = value;
                                              });
                                            },
                                            showDividers: true,
                                            interval: 25,
                                            min: 0,
                                            max: 100,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 70,
                                    child: AppDropdown(
                                      verticalPadding: 15,
                                      selectedValue: 'English',
                                      menuItems: ['English', 'French'],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Divider(),
                            SizedBox(height: 20),
                            Text('Notifications and Alerts'),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Appointment Reminders',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Light',
                                    fontSize: 14,
                                  ),
                                ),
                                Switch(
                                  value: true,
                                  onChanged: (value) {},
                                  activeTrackColor: AppColors.secondaryColor,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Message Alerts',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Light',
                                    fontSize: 14,
                                  ),
                                ),
                                Row(
                                  spacing: 10,
                                  children: [
                                    IntrinsicWidth(
                                      child: AppDropdown(
                                        menuItems: ['Email', 'Phone'],
                                        hintText: '',
                                        selectedValue: 'Email',
                                        verticalPadding: 5,
                                      ),
                                      stepHeight: 20,
                                    ),
                                    Switch(
                                      value: true,
                                      onChanged: (value) {},
                                      activeTrackColor:
                                          AppColors.secondaryColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Divider(),
                            SizedBox(height: 20),
                            Text('Security and Access'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Two-Factor Authentication',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Light',
                                    fontSize: 14,
                                  ),
                                ),
                                Switch(
                                  value: true,
                                  onChanged: (value) {},
                                  activeTrackColor: AppColors.secondaryColor,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Export Account Data',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Light',
                                    fontSize: 14,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: IntrinsicWidth(
                                    stepHeight: 20,
                                    child: AppDropdown(
                                      menuItems: ['Email', 'Storage'],
                                      hintText: '',
                                      selectedValue: 'Email',
                                      verticalPadding: 5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {},
                              child: Text(
                                'Change Password',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {},
                              child: Text(
                                'Delete Account',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                            SizedBox(height: 5),
                            SizedBox(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5)
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Save and Update',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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

