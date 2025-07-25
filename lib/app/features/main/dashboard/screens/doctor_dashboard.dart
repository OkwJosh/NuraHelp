import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/common/dropdown/app_dropdown.dart';
import 'package:nurahelp/app/features/main/dashboard/screens/widgets/appointment_card/appointment_card.dart';
import 'package:nurahelp/app/features/main/dashboard/screens/widgets/chart/chart.dart';
import 'package:nurahelp/app/features/main/dashboard/screens/widgets/dashboard_card/dashboard_card.dart';
import 'package:nurahelp/app/features/main/messages/screens/direct_message.dart';
import '../../../../common/list_tiles/message_list_tile.dart';
import '../../../../common/list_tiles/patient_list_tile.dart';
import '../../../../common/search_bar/search_bar.dart';
import '../../../../utilities/constants/colors.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  String? selectedValue;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Positioned.fill(
            top: 120,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              DashboardCard(),
                              SizedBox(width: 15),
                              DashboardCard(),
                              SizedBox(width: 15),
                              DashboardCard(),
                            ],
                          ),
                          SizedBox(height: 32),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.greyColor.withOpacity(0.6),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 10,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Patient Visit",
                                    style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                AppDropdown(selectedValue: 'Monthly', menuItems: ['Daily', 'Monthly', 'Yearly']),
                              ],
                            ),
                          ),
                          AppChart(),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.greyColor.withOpacity(0.6),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 10,
                          top: 15,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 10.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Messages',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Poppins-Regular',
                                    ),
                                  ),
                                  Text(
                                    'mark all as read',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins-Light',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            MessageListTile(onPressed: () => Get.to(DirectMessagePage(),duration: Duration(seconds: 0)),contactName: 'Charles Dickson', lastMessage:'You: Let\'s make this official', unreadMessagesNumber: 2),
                            MessageListTile(onPressed: (){},contactName: 'Monte Catherine', lastMessage:'You: Hello, how\'re you?', unreadMessagesNumber: 5),
                            MessageListTile(onPressed: (){},contactName: 'Charles Dickson', lastMessage:'You: Let\'s make this official', unreadMessagesNumber: 2),
                            MessageListTile(onPressed: (){},contactName: 'Monte Catherine', lastMessage:'You: Hello, how\'re you?', unreadMessagesNumber: 5),
                            MessageListTile(onPressed: (){},contactName: 'Charles Dickson', lastMessage:'You: Let\'s make this official', unreadMessagesNumber: 2),
                            MessageListTile(onPressed: (){},contactName: 'Monte Catherine', lastMessage:'You: Hello, how\'re you?', unreadMessagesNumber: 5),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.greyColor.withOpacity(0.6),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 10,
                          top: 15,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 10.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Patient List',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Poppins-Regular',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Material(
                              elevation: 1,
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              child: Container(
                                margin: EdgeInsets.only(bottom: 0),
                                decoration: BoxDecoration(color: Colors.white),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.bluishWhiteColor,
                                        border: Border(
                                          bottom: BorderSide(
                                            color: AppColors.greyColor,
                                            width: 0.2,
                                          ),
                                        ),
                                      ),
                                      margin: EdgeInsets.zero,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 25,
                                        horizontal: 20,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'PATIENT NAME',
                                            style: TextStyle(
                                              fontFamily: "Poppins-Medium",
                                            ),
                                          ),
                                          Text(
                                            'CONTACT DETAILS',
                                            style: TextStyle(
                                              fontFamily: "Poppins-SemiBold",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PatientListTile(),
                                    PatientListTile(),
                                    PatientListTile(),
                                    PatientListTile(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.greyColor.withOpacity(0.6),
                          
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          // bottom: 10,
                          top: 15,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 10.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Appointments',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Poppins-Regular',
                                    ),
                                  ),
                                  Text(
                                    'see all',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins-Light',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AppointmentCard(),
                            AppointmentCard(),
                            AppointmentCard(),
                            AppointmentCard(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Material(
              elevation: 1,
              child: Container(
                height: 110,
                color: Colors.white,
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Expanded(child: AppSearchBar(hintText: "Hey Nura,type to ask anything")),
                              SizedBox(width: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: AppColors.greyColor.withOpacity(0.6),
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.notifications_none_outlined,
                                    weight: 5,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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

