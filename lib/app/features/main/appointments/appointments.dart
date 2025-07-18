import 'package:flutter/material.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';

import '../../../common/appbar/appbar_with_bell.dart';
import '../../../common/custom_switch/custom_switch.dart';
import '../../../common/list_tiles/appoint_list_tile.dart';


class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, child: AppBarWithBell()),
          Positioned.fill(
            top: 130,
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  style: IconButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: AppColors.greyColor,
                                        width: 0.5,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {},
                                  icon: Icon(Icons.arrow_back_ios_sharp,),
                                ),
                                SizedBox(width: 10),
                                IconButton(
                                  style: IconButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: AppColors.greyColor,
                                        width: 0.5,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {},
                                  icon: Icon(Icons.arrow_forward_ios_sharp,),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Text(
                              '17th June, 2025',
                              style: TextStyle(
                                fontFamily: "Poppins-Light",
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height:35,
                              width:100,
                              child: CustomSwitch(
                                firstOptionText: 'Day',
                                secondOptionText: 'Week',
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                backgroundColor: AppColors.secondaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'New appointment',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: "Poppins-Light",
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
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
                              vertical: 10,
                              horizontal: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: false,
                                      onChanged: (value) {},
                                    ),
                                    Text(
                                      'TIME',
                                      style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        fontSize: 12
                                      ),
                                    ),
                                    Icon(Icons.call_received, size: 10),
                                  ],
                                ),
                                Transform.translate(
                                  offset: Offset(-70, 0),
                                  child: Text(
                                    'PATIENT',
                                    style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                        fontSize: 12

                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppointmentListTile(),
                          AppointmentListTile(),
                          AppointmentListTile(),
                          AppointmentListTile(),
                          AppointmentListTile(),
                          AppointmentListTile(),
                          AppointmentListTile(),
                          AppointmentListTile(),
                          AppointmentListTile(),
                          SizedBox(height: 100),
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
