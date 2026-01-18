import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nurahelp/app/common/dropdown/app_dropdown.dart';
import 'package:nurahelp/app/features/main/screens/settings/widgets/profile_info_section.dart';
import 'package:nurahelp/app/routes/app_routes.dart';
import '../../../../utilities/constants/colors.dart';
import '../../controllers/patient/patient_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // dynamic sliderValue = 2.0;

  @override
  Widget build(BuildContext context) {
    final _controller = Get.find<PatientController>();
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
                  IconButton(
                    onPressed: () => Get.offAllNamed(AppRoutes.navigationMenu),
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                  Text('Settings', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ),
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
                            // Divider(),
                            // SizedBox(height: 20),
                            // Text(
                            //   'Voice & Language Preferences',
                            //   style: TextStyle(
                            //     fontSize: 16,
                            //     fontFamily: 'Poppins-Semibold',
                            //   ),
                            // ),
                            // SizedBox(height: 15),
                            // Row(
                            //   mainAxisAlignment:
                            //       MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(
                            //       'Enable "Hey Nura" Voice Wake',
                            //       style: TextStyle(fontSize: 14),
                            //     ),
                            //     Switch(
                            //       value: true,
                            //       onChanged: (value) {},
                            //       activeTrackColor: AppColors.secondaryColor,
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(height: 10),
                            // Row(
                            //   mainAxisAlignment:
                            //       MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(
                            //       'Voice feedback',
                            //       style: TextStyle(fontSize: 14),
                            //     ),
                            //     Switch(
                            //       value: true,
                            //       onChanged: (value) {},
                            //       activeTrackColor: AppColors.secondaryColor,
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(height: 10),
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Text('Voice Command Sensitivity'),
                            //     Row(
                            //       children: [
                            //         Expanded(
                            //           child: Transform.translate(
                            //             offset: Offset(-22, 0),
                            //             child: SfSliderTheme(
                            //               data: SfSliderThemeData(
                            //                 tooltipBackgroundColor:
                            //                     AppColors.secondaryColor,
                            //
                            //                 thumbRadius: 5,
                            //                 thumbColor:
                            //                     AppColors.secondaryColor,
                            //                 activeDividerRadius: 3,
                            //                 activeTrackColor:
                            //                     AppColors.secondaryColor,
                            //                 inactiveTrackColor: AppColors
                            //                     .greyColor
                            //                     .withOpacity(0.4),
                            //                 inactiveDividerRadius: 3,
                            //                 activeDividerColor:
                            //                     AppColors.secondaryColor,
                            //                 inactiveDividerColor: AppColors
                            //                     .greyColor
                            //                     .withOpacity(0.4),
                            //               ),
                            //               child: SfSlider(
                            //                 stepSize: 25,
                            //                 enableTooltip: true,
                            //                 value: sliderValue,
                            //                 onChanged: (dynamic value) {
                            //                   setState(() {
                            //                     sliderValue = value;
                            //                   });
                            //                 },
                            //                 showDividers: true,
                            //                 interval: 25,
                            //                 min: 0,
                            //                 max: 100,
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(height: 15),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: SizedBox(
                            //         height: 70,
                            //         child: AppDropdown(
                            //           verticalPadding: 15,
                            //           selectedValue: 'English',
                            //           menuItems: ['English', 'French'],
                            //           validator: (String? value) {
                            //             return null;
                            //           },
                            //           onChanged: (String? value) {},
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(height: 20),
                            Divider(),
                            SizedBox(height: 20),
                            Text(
                              'Notifications and Alerts',
                              style: TextStyle(
                                fontFamily: 'Poppins-SemiBold',
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 10),
                            Obx(
                              () => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Appointment Reminders'),
                                  Switch(
                                    value: _controller
                                        .enableAppointmentReminders
                                        .value,
                                    onChanged: (value) {
                                      _controller
                                              .enableAppointmentReminders
                                              .value =
                                          value;
                                    },
                                    activeTrackColor: AppColors.secondaryColor,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Obx(
                              () => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Message Alerts'),
                                  Row(
                                    spacing: 10,
                                    children: [
                                      IntrinsicWidth(
                                        stepHeight: 20,
                                        child: AppDropdown(
                                          menuItems: ['Email', 'Phone'],
                                          hintText: '',
                                          selectedValue: 'Email',
                                          verticalPadding: 5,
                                          validator: (String? value) {},
                                          onChanged: (String? value) {},
                                        ),
                                      ),
                                      Switch(
                                        value: _controller
                                            .enableMessageAlerts
                                            .value,
                                        onChanged: (value) {
                                          _controller
                                                  .enableMessageAlerts
                                                  .value =
                                              value;
                                        },
                                        activeTrackColor:
                                            AppColors.secondaryColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Divider(),
                            SizedBox(height: 20),
                            Text(
                              'Security and Access',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins-SemiBold',
                              ),
                            ),
                            Obx(
                              () => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Two-Factor Authentication'),
                                  Switch(
                                    value: _controller.enable2Fa.value,
                                    onChanged: (value) {
                                      _controller.enable2Fa.value = value;
                                    },
                                    activeTrackColor: AppColors.secondaryColor,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Export Account Data'),
                                SizedBox(
                                  width: 70,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 0,
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      'Export',
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 14,
                                        fontFamily: 'Poppins-Regular',
                                      ),
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
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins-Medium',
                                ),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {},
                              child: Text(
                                'Delete Account',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontFamily: 'Poppins-Medium',
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            SizedBox(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                ),
                                onPressed: () => _controller.saveSettings(),
                                child: Text(
                                  'Save and Update',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
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
