import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/features/main/screens/settings/edit_personal_information.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';

import '../../../../../common/shimmer/shimmer_effect.dart';
import '../../../../../utilities/constants/colors.dart';

class ProfileInfoSection extends StatelessWidget {
  const ProfileInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final _controller = Get.find<PatientController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Personal Info',
              style: TextStyle(fontFamily: 'Poppins-Regular', fontSize: 16),
            ),
            OutlinedButton(
              onPressed: () => Get.to(() => EditPersonalInformation()),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
        Obx(
          ()=> Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: _controller.imageLoading.value
                  ? AppShimmerEffect(
                height: 170,
                width: 170,
                radius: 150,
              )
                  : _controller.patient.value.profilePicture!.isEmpty?Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: SvgIcon(
                      AppIcons.profile,
                      size: 100,
                    ),
                  ),
                ),
              ):SizedBox(
                height: 130,
                width: 130,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: Image.network(
                    _controller.patient.value.profilePicture!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
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
              _controller.patient.value.name ?? '',
              style: TextStyle(fontFamily: 'Poppins-Medium', fontSize: 16),
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
              style: TextStyle(fontFamily: 'Poppins-Medium', fontSize: 16),
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
              _controller.patient.value.phone ?? '',
              style: TextStyle(fontFamily: 'Poppins-Medium', fontSize: 16),
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
              _controller.patient.value.email ?? '',
              style: TextStyle(fontFamily: 'Poppins-Medium', fontSize: 16),
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
                fontSize: 15,
              ),
            ),
            Row(
              spacing: 5,
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: SvgIcon(AppIcons.profile),
                ),
                Text(
                  'Dr John Smith',
                  style: TextStyle(fontFamily: 'Poppins-Medium', fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
