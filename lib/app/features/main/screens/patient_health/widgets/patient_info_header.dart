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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 360;
    final avatarSize = isSmall ? 38.0 : 45.0;
    final nameFontSize = isSmall ? 14.0 : 16.0;
    final detailFontSize = isSmall ? 12.0 : 14.0;

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
                        child: AppShimmerEffect(
                          height: avatarSize,
                          width: avatarSize,
                          radius: 150,
                        ),
                      )
                    : Container(
                        width: avatarSize,
                        height: avatarSize,
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
                                radius: avatarSize / 2,
                                backgroundColor: Colors.white,
                                child: SvgIcon(AppIcons.profile, size: 100),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(90),
                                child: CachedNetworkImage(
                                  height: avatarSize,
                                  width: avatarSize,
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
                                            child: AppShimmerEffect(
                                              width: avatarSize,
                                              height: avatarSize,
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
            SizedBox(width: isSmall ? 6 : 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patientController.patient.value.name,
                    style: TextStyle(
                      fontFamily: 'Poppins-Semibold',
                      fontSize: nameFontSize,
                      color: AppColors.black600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Wrap(
                    spacing: 10,
                    children: [
                      Text(
                        'Age ${patientController.getAge(patientController.patient.value.DOB)}',
                        style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: detailFontSize,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
