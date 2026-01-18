import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nurahelp/app/common/shimmer/shimmer_effect.dart';
import 'package:nurahelp/app/data/models/doctor_model.dart';
import 'package:nurahelp/app/features/main/screens/doctors/about_doctor.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';
import '../../../../../utilities/constants/colors.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({super.key, required this.doctor});

  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      elevation: 0.1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: doctor.profilePicture.isEmpty
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.secondaryColor,
                            ),
                            width: 150,
                            height: 150,
                            child: Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.white,
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: doctor.profilePicture,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const AppShimmerEffect(
                                  width: 150,
                                  height: 150,
                                  radius: 10,
                                ),
                            errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.secondaryColor,
                              ),
                              width: 150,
                              height: 150,
                              child: Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        child: Row(
                          children: [
                            SvgIcon(AppIcons.reviewStar, size: 15),
                            SizedBox(width: 5),
                            Text('5.0', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dr. ${doctor.name}',
                    style: TextStyle(
                      fontFamily: 'Poppins-Medium',
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    doctor.specialty,
                    style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: 14,
                      color: AppColors.lightgrey,
                    ),
                  ),
                ],
              ),
              Transform.translate(
                offset: Offset(15, 100),
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    ),
                    onPressed: () => Get.to(() => AboutDoctorScreen()),
                    child: SvgIcon(AppIcons.arrowUpRight, size: 25),
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
