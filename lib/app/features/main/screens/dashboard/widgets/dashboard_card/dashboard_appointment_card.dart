import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/carbon.dart';
import 'package:iconify_flutter_plus/icons/majesticons.dart';
import 'package:iconify_flutter_plus/icons/uil.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../../utilities/constants/colors.dart';


class DashboardAppointmentCard extends StatelessWidget {
  const DashboardAppointmentCard({
    super.key,
  });

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
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 20),
                    SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dr John Smith',style: TextStyle(fontSize: 14,fontFamily: "Poppins-Regular")),
                        Text('Cardiologist',style: TextStyle(fontFamily: "Poppins-ExtraLight",fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                Row(
                  spacing: 0,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                      child: Row(
                        spacing: 5,
                        children: [
                          CircleAvatar(backgroundColor: Colors.orangeAccent,radius: 5,),
                          Text('Pending',style: TextStyle(fontSize: 12,fontFamily: 'Poppins-Light'),),
                        ],
                      ),
                      ),

                    ),
                    IconButton(onPressed: (){}, icon: Iconify(Uil.ellipsis_v)),
                  ],
                )
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
                        Iconify(Carbon.calendar,color: AppColors.secondaryColor),
                        SizedBox(width: 10),
                        Text('12 Nov,12:00 - 12:45 PM',style: TextStyle(fontSize: 12,fontFamily: "Poppins-Light"))
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Symbols.desktop_mac,color: AppColors.secondaryColor),
                        SizedBox(width: 10),
                        Text('Virtual Visit',style: TextStyle(fontSize: 12,fontFamily: "Poppins-Light"))
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(onPressed: (){},
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 17)
                    ), child: Row(
                    children: [
                      Iconify(Majesticons.video_camera_line,color: Colors.white),
                      SizedBox(width: 3),
                      Text('Join',style: TextStyle(color: Colors.white)),
                    ],
                  ),

                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
