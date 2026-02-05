import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/routes/app_routes.dart';
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
              onPressed: () => Get.toNamed(AppRoutes.editPersonalInformation),
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
          () => Padding(
            padding: const EdgeInsets.all(10.0),
            child: _controller.imageLoading.value
                ? const AppShimmerEffect(height: 170, width: 170, radius: 150)
                : Container(
                    width: 165,
                    height: 165,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.black),
                    ),
                    child: _controller.patient.value.profilePicture!.isEmpty
                        ? CircleAvatar(
                            radius: 120,
                            backgroundColor: Colors.white,
                            child: SvgIcon(AppIcons.profile, size: 100),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(90),
                            child: CachedNetworkImage(
                              imageUrl:
                                  _controller.patient.value.profilePicture!,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      const AppShimmerEffect(
                                        width: 130,
                                        height: 130,
                                        radius: 90,
                                      ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
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
              _controller.patient.value.DOB != null
                  ? DateFormat(
                      'dd MMMM, yyyy',
                    ).format(_controller.patient.value.DOB!)
                  : 'Not provided',
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
          spacing: _controller.patient.value.doctor == null ? 5 : 10,
          children: [
            Text(
              'Linked Doctor(s)',
              style: TextStyle(
                fontFamily: 'Poppins-Regular',
                color: AppColors.black300,
                fontSize: 15,
              ),
            ),
            Builder(
              builder: (context) {
                if (_controller.patient.value.doctor == null) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('No Linked Doctors yet'),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                        ),
                        onPressed: () =>
                            _controller.showLinkDoctorBottomSheet(context),
                        child: Text(
                          'Link Now',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                }
                return Row(
                  spacing: 5,
                  children: [
                    Obx(() {
                      return _controller.imageLoading.value
                          ? const AppShimmerEffect(
                              height: 50,
                              width: 50,
                              radius: 50,
                            )
                          : Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child:
                                  _controller
                                      .patient
                                      .value
                                      .doctor!
                                      .profilePicture
                                      .isEmpty
                                  ? CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      child: SvgIcon(
                                        AppIcons.profile,
                                        size: 30,
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(90),
                                      child: CachedNetworkImage(
                                        imageUrl: _controller
                                            .patient
                                            .value
                                            .doctor!
                                            .profilePicture,
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                const AppShimmerEffect(
                                                  width: 100,
                                                  height: 100,
                                                  radius: 90,
                                                ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                            );
                    }),
                    Text(
                      'Dr ${_controller.patient.value.doctor?.name}',
                      style: TextStyle(
                        fontFamily: 'Poppins-Medium',
                        fontSize: 16,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
