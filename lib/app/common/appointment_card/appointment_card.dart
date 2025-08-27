import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';

import '../../utilities/constants/colors.dart';
import '../../utilities/constants/icons.dart';
import '../shimmer/shimmer_effect.dart';

class AppointmentCard extends StatefulWidget {
  AppointmentCard({
    super.key,
    required this.isVirtual,
    this.showStatus = false,
    this.status = 'pending',
    required this.patientController,
  });

  final bool isVirtual;
  final bool showStatus;
  final String status;
  bool showOptionsClicked = false;
  final PatientController patientController;

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      elevation: 0.3,
      shadowColor: Colors.black,

      child: Container(
        width: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => widget.patientController.imageLoading.value
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
                                      widget
                                          .patientController
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
                                          borderRadius: BorderRadius.circular(
                                            90,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: widget
                                                .patientController
                                                .patient
                                                .value
                                                .doctor!
                                                .profilePicture,
                                            fit: BoxFit.cover,
                                            progressIndicatorBuilder:
                                                (
                                                  context,
                                                  url,
                                                  downloadProgress,
                                                ) => const AppShimmerEffect(
                                                  width: 100,
                                                  height: 100,
                                                  radius: 90,
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dr ${widget.patientController.patient.value.doctor!.name}',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Poppins-Medium',
                              ),
                            ),
                            Text(
                              widget
                                  .patientController
                                  .patient
                                  .value
                                  .doctor!
                                  .specialty,
                              style: TextStyle(
                                fontFamily: 'Poppins-Light',
                                fontSize: 14,
                                color: AppColors.black300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        widget.showStatus
                            ? Container(
                                decoration: BoxDecoration(
                                  color: widget.status == 'pending'
                                      ? AppColors.warning50
                                      : AppColors.error50,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    spacing: 5,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            widget.status == 'pending'
                                            ? Colors.orangeAccent
                                            : Colors.redAccent,
                                        radius: 5,
                                      ),
                                      widget.status == 'pending'
                                          ? Text(
                                              'Pending',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Poppins-Regular',
                                                color: AppColors.warning500,
                                                letterSpacing: -1,
                                              ),
                                            )
                                          : Text(
                                              'Canceled',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Poppins-Regular',
                                                color: AppColors.error400,
                                                letterSpacing: -1,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(),
                        widget.status == 'canceled'
                            ? SizedBox.shrink()
                            : PopupMenuButton(
                                icon: SvgIcon(AppIcons.ellipsis),
                                color: Colors.white,
                                elevation: 2,
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      child: Text(
                                        'Cancel appointment',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ];
                                },
                              ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgIcon(AppIcons.calender, size: 20),
                            SizedBox(width: 10),
                            Text(
                              widget
                                          .patientController
                                          .patient
                                          .value
                                          .clinicalResponse
                                          ?.appointments
                                          ?.isNotEmpty ==
                                      true
                                  ? widget
                                        .patientController
                                        .patient
                                        .value
                                        .clinicalResponse!
                                        .appointments
                                        .map(
                                          (appointment) =>
                                              '${DateFormat('dd MMM').format(appointment.appointmentDate)}, ${appointment.appointmentStartTime} - ${appointment.appointmentFinishTime ?? ""}',
                                        )
                                        .join(
                                          '\n',
                                        ) // Use \n for new lines or ', ' for comma separation
                                  : 'No appointments',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins-Light',
                                color: AppColors.black300,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SvgIcon(AppIcons.computer, size: 20),
                            SizedBox(width: 10),
                            Text(
                              widget.isVirtual
                                  ? 'Virtual Visit'
                                  : 'In-person visit',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins-Light',
                                color: AppColors.black300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    widget.isVirtual
                        ? SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                              ),
                              child: Row(
                                children: [
                                  SvgIcon(AppIcons.camera, color: Colors.white),
                                  SizedBox(width: 3),
                                  Text(
                                    'Join',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins-Medium',
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
