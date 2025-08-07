import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/common/dropdown/app_dropdown.dart';
import 'package:nurahelp/app/features/auth/screens/sign_up/widget/sign_up_progress_bar.dart';
import 'package:nurahelp/app/nav_menu.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';

import '../../../../utilities/constants/colors.dart';
import '../../../../utilities/constants/icons.dart';

class FirstTimeOnBoardingScreen extends StatefulWidget {
  const FirstTimeOnBoardingScreen({super.key});

  @override
  State<FirstTimeOnBoardingScreen> createState() => _FirstTimeOnBoardingScreenState();
}

class _FirstTimeOnBoardingScreenState extends State<FirstTimeOnBoardingScreen> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: SignUpProgressBar(
          firstBarColor: AppColors.secondaryColor,
          secondBarColor: AppColors.secondaryColor,
          thirdBarColor: AppColors.secondaryColor,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, top: 80),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'First-Time\nOnboarding',
                style: TextStyle(fontFamily: 'Poppins-Medium', fontSize: 38),
              ),
              SizedBox(height: 10),
              Text(
                'please fill in your details below',
                style: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  color: AppColors.black300,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Add profile picture',
                        style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 16,
                          color: AppColors.black300,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        overlayColor: Colors.black.withOpacity(0.2),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.greyColor.withOpacity(0.6),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white,
                        child: SvgIcon(AppIcons.profile, size: 100),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              SizedBox(
                height: 56,
                width: double.infinity,
                child: AppDropdown(menuItems: ['English', 'French'],
                verticalPadding: 15,
                  hintText: 'Choose Language Preference',
                  borderRadius: 10,

                ),
              ),
              // SizedBox(
              //   child: DropdownButtonFormField<String>(
              //     icon: Icon(Icons.keyboard_arrow_down,color: AppColors.black),
              //     hint: Text(
              //       'Choose Language Preference',
              //       style: TextStyle(
              //         fontSize: 14,
              //         fontFamily: 'Poppins-ExtraLight',
              //         color: AppColors.black,
              //         letterSpacing: 0,
              //       ),
              //     ),
              //     decoration: InputDecoration(
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //         borderSide: BorderSide(
              //           color: AppColors.black,
              //           width: 0.3,
              //         ),
              //       ),
              //       enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //         borderSide: BorderSide(
              //           color: AppColors.black,
              //           width: 0.3,
              //         ),
              //       ),
              //       disabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //         borderSide: BorderSide(
              //           color: AppColors.black,
              //           width: 0.3,
              //         ),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //         borderSide: BorderSide(
              //           color: AppColors.black,
              //           width: 0.3,
              //         ),
              //       ),
              //     ),
              //     items: [
              //       DropdownMenuItem(value: 'en', child: Text('English')),
              //       DropdownMenuItem(value: 'fr', child: Text('French')),
              //     ],
              //     onChanged: (value) {
              //       print("Selected: $value");
              //     },
              //   ),
              // ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox.square(
                    dimension: 20,
                    child: Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        setState((){
                          isChecked = value!;
                        });
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Enable \"Hey Nura\" voice activation (optional)',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins-Regular',
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAll(
                    () => NavigationMenu(),
                    duration: Duration(seconds: 0),
                  ),
                  child: Text(
                    'Go to Dashboard',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins-Medium',
                      color: Colors.white,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
