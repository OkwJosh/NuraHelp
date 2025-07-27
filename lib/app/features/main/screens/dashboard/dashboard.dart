import 'package:flutter/material.dart';
import 'package:nurahelp/app/common/appbar/appbar_with_bell.dart';
import 'package:nurahelp/app/common/message_field/message_field.dart';
import 'package:nurahelp/app/features/main/screens/dashboard/widgets/dashboard_card/dashboard_appointment_card.dart';
import 'package:nurahelp/app/nav_menu.dart';

import '../../../../utilities/constants/colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, child: AppBarWithBell()),
          Positioned.fill(
            top: 120,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: SingleChildScrollView(
                child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Center(
                      child: Text(
                        'Welcome back,Aldred!',
                        style: TextStyle(
                          fontFamily: 'Poppins-SemiBold',
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Quick Access Panel', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 15),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        DashboardAppointmentCard(),
                        SizedBox(width: 10),
                        DashboardAppointmentCard(),
                        SizedBox(width: 10),
                        DashboardAppointmentCard(),
                      ],
                    ),
                  ),
                  SizedBox(height: 180),
                  Column(
                    children: [
                      Text(
                        'What\'s on the agenda today ?',
                        style: TextStyle(fontSize: 20,fontFamily: "Poppins-Regular"),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15),
                      CustomTextField(showBorder: false,hint: 'Hey Nura, type to ask anything'),

                    ],
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
