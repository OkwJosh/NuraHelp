import 'package:flutter/material.dart';
import 'package:nurahelp/app/common/appbar/appbar_with_bell.dart';

import '../../../../utilities/constants/colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Personal Info'),
                                OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 5,
                                    ),
                                  ),
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins-Light',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CircleAvatar(radius: 60),
                              ),
                            ),
                            SizedBox(height: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 15,
                              children: [
                                Text(
                                  'Full Name',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-ExtraLight',
                                    color: AppColors.greyColor,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  'John H. Doe',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Light',
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 15,
                              children: [
                                Text(
                                  'Date of Birth',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-ExtraLight',
                                    color: AppColors.greyColor,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  '20th August, 2000',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Light',
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 15,
                              children: [
                                Text(
                                  'Phone Number',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-ExtraLight',
                                    fontSize: 15,
                                    color: AppColors.greyColor,
                                  ),
                                ),
                                Text(
                                  '0123456789',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Light',
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 15,
                              children: [
                                Text(
                                  'Email Address',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-ExtraLight',
                                    color: AppColors.greyColor,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  'example@gmail.com',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Light',
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 15,
                              children: [
                                Text(
                                  'Linked Doctor(s)',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-ExtraLight',
                                    color: AppColors.greyColor,
                                  ),
                                ),
                                Row(
                                  spacing: 5,
                                  children: [
                                    CircleAvatar(radius: 15),
                                    Text(
                                      'Dr John Smith',
                                      style: TextStyle(
                                        fontFamily: 'Poppins-Light',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Divider(),
                            SizedBox(height: 20),
                            Text(
                              'Voice & Language Preferences',
                              style: TextStyle(fontSize: 16),
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
                                Text('Voice Command Sensitivity'),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    rangeThumbShape: RoundRangeSliderThumbShape(
                                      enabledThumbRadius: 0.5,
                                    )
                                  ),
                                  child: RangeSlider(
                                    values: RangeValues(0, 25),
                                    min: 0,
                                    max: 100,
                                    divisions: 4,
                                    onChanged: (value) {},
                                    
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Divider(),
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
