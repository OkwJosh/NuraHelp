import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';
import '../../../../../common/shimmer/shimmer_effect.dart';
import '../../../../../utilities/constants/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PatientInfoHeader extends StatelessWidget {
  const PatientInfoHeader({super.key, required this.patientController});

  final PatientController patientController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(10.0),
                child: patientController.imageLoading.value
                    ? Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.black),
                        ),
                        child: const AppShimmerEffect(
                          height: 45,
                          width: 45,
                          radius: 150,
                        ),
                      )
                    : Container(
                        width: 45,
                        height: 45,
                        padding: EdgeInsets.all(
                          patientController
                                  .patient
                                  .value
                                  .profilePicture!
                                  .isEmpty
                              ? 10.0
                              : 0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color:
                                patientController
                                    .patient
                                    .value
                                    .profilePicture!
                                    .isEmpty
                                ? Colors.black
                                : Colors.transparent,
                          ),
                        ),
                        child:
                            patientController
                                .patient
                                .value
                                .profilePicture!
                                .isEmpty
                            ? CircleAvatar(
                                radius: 22.5,
                                backgroundColor: Colors.white,
                                child: SvgIcon(AppIcons.profile, size: 100),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(90),
                                child: CachedNetworkImage(
                                  height: 100,
                                  width: 100,
                                  imageUrl: patientController
                                      .patient
                                      .value
                                      .profilePicture!,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              border: Border.all(
                                                color: Colors.black,
                                              ),
                                            ),
                                            child: const AppShimmerEffect(
                                              width: 30,
                                              height: 30,
                                              radius: 90,
                                            ),
                                          ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                      ),
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patientController.patient.value.name,
                  style: TextStyle(
                    fontFamily: 'Poppins-Semibold',
                    fontSize: 16,
                    color: AppColors.black600,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Male',
                      style: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Age ${patientController.getAge(patientController.patient.value.DOB)}',
                      style: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'O+',
                      style: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
