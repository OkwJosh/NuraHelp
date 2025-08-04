import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nurahelp/app/features/main/screens/settings/edit_personal_information.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';

import '../../../../../utilities/constants/colors.dart';

class ProfileInfoSection extends StatelessWidget {
  const ProfileInfoSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Personal Info',style: TextStyle(fontFamily: 'Poppins-Regular',fontSize: 16),),
            OutlinedButton(
              onPressed: () => Get.to(() => EditPersonalInformation()),
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
            child: CircleAvatar(radius: 60,backgroundColor:Colors.white,child: SvgIcon(AppIcons.profile,size: 100,),),
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
                fontFamily: 'Poppins-Regular',
                color: AppColors.greyColor,
                fontSize: 15,
              ),
            ),
            Text(
              'John H. Doe',
              style: TextStyle(
                fontFamily: 'Poppins-Medium',
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
                fontFamily: 'Poppins-Regular',
                color: AppColors.greyColor,
                fontSize: 15,
              ),
            ),
            Text(
              '20th August, 2000',
              style: TextStyle(
                fontFamily: 'Poppins-Medium',
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
                fontFamily: 'Poppins-Regular',
                fontSize: 15,
                color: AppColors.greyColor,
              ),
            ),
            Text(
              '0123456789',
              style: TextStyle(
                fontFamily: 'Poppins-Medium',
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
                fontFamily: 'Poppins-Regular',
                color: AppColors.greyColor,
                fontSize: 15,
              ),
            ),
            Text(
              'example@gmail.com',
              style: TextStyle(
                fontFamily: 'Poppins-Medium',
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
                  fontFamily: 'Poppins-Regular',
                  color: AppColors.black300,
                  fontSize: 15
              ),
            ),
            Row(
              spacing: 5,
              children: [
                CircleAvatar(radius: 15,backgroundColor: Colors.white, child: SvgIcon(AppIcons.profile)),
                Text(
                  'Dr John Smith',
                  style: TextStyle(
                    fontFamily: 'Poppins-Medium',
                    fontSize: 16
                  ),
                ),
              ],

            ),
          ],
        ),
      ],
    );
  }
}
