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
    return Container(
      width: 350,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 20),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dr John Smith',style: TextStyle(fontSize: 16,fontFamily: "Poppins-Regular")),
                      Text('Cardiologist',style: TextStyle(fontFamily: "Poppins-ExtraLight",fontSize: 14)),
                    ],
                  ),
                ],
              ),
              Iconify(Uil.ellipsis_v),
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
                      Text('12 Nov,12:00 - 12:45 PM')
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Symbols.desktop_mac,color: AppColors.secondaryColor),
                      SizedBox(width: 10),
                      Text('Virtual Visit')
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 45,
                child: ElevatedButton(onPressed: (){},
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 15)
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
    );
  }
}
