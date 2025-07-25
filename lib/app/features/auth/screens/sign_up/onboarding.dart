import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nurahelp/app/common/dropdown/app_dropdown.dart';
import 'package:nurahelp/app/features/auth/screens/sign_up/widget/sign_up_progress_bar.dart';
import 'package:nurahelp/app/nav_menu.dart';

import '../../../../utilities/constants/colors.dart';

class FirstTimeOnBoardingScreen extends StatelessWidget {
  const FirstTimeOnBoardingScreen({super.key});

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
        padding: EdgeInsets.only(left: 15, right: 15, top: 50),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'LOGO',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
              Text(
                'First-Time Onboarding',
                style: TextStyle(fontFamily: 'Poppins-SemiBold', fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(
                'please fill in your details below',
                style: TextStyle(fontFamily: 'Poppins-Light', fontSize: 14),
              ),
              SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Add profile picture',
                      style: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.greyColor.withOpacity(0.6),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      child: CircleAvatar(radius: 70),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              TextField(
                decoration: InputDecoration(
                  hint: Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins-Regular',
                        color: AppColors.greyColor.withOpacity(0.6),
                        letterSpacing: 0,
                      ),
                      text: 'Medical License ID',
                      children: [
                        TextSpan(
                          style: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            color: Colors.red,
                          ),
                          text: ' *',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                child: DropdownButtonFormField<String>(
                  icon: Icon(Icons.keyboard_arrow_down),
                  hint: Text(
                    'Choose Language Preference',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins-Regular',
                      color: AppColors.greyColor.withOpacity(0.6),
                      letterSpacing: 0,
                    ),
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.greyColor.withOpacity(0.2),
                      ),
                    ), // optional, for better UI
                  ),
                  items: [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'fr', child: Text('French')),
                  ],
                  onChanged: (value) {
                    print("Selected: $value");
                  },
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox.square(
                    dimension: 20,
                    child: Checkbox(
                      value: (true),
                      onChanged: (value) {},
                      materialTapTargetSize:
                      MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text('Enable \"Hey Nura\" voice activation (optional)',style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins-Regular',
                    letterSpacing: 0,
                  ),),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: ()=> Get.offAll(()=> NavigationMenu(),duration: Duration(seconds: 0)), child: Text('Go to Dashboard',style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins-Regular',
                    color: Colors.white,
                    letterSpacing: 0,
                  ),)))
            ],
          ),
        ),
      ),
    );
  }
}
