import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';

import '../../../../nav_menu.dart';
import '../../../../utilities/constants/icons.dart';


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Text('Notifications', style: TextStyle(fontSize: 18)),
          leading: IconButton(
              onPressed: () => Get.offAll(() => NavigationMenu()),
              icon: Icon(Icons.arrow_back_ios)),
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15), child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Center(
              heightFactor: 4.5,
              child: Column(
                children: [
                  SvgIcon(AppIcons.notification_2,size: 48,),
                  SizedBox(height: 15),
                  Text('No Notifications Yet',style: TextStyle(fontSize: 18),),
                  SizedBox(height: 10),
                  Text('You\'ll be notified here once\n there\'s something new',style: TextStyle(fontSize: 14,fontFamily: 'Poppins-Light'),textAlign: TextAlign.center,)
                ],
              ),
            ),
          ),
        ),
        ),
    );
  }
}
