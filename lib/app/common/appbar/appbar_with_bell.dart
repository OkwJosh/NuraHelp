import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nurahelp/app/features/main/screens/notification/notification.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';

import '../../utilities/constants/colors.dart';

class AppBarWithBell extends StatelessWidget {
  const AppBarWithBell({
    this.showBackArrow = false,
    super.key,
  });

  final bool showBackArrow;



  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0.5,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
            color: Colors.white
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0,right: 20.0,top: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              showBackArrow?
              IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios,size: 25,)):
                  SizedBox.shrink(),
              IconButton(onPressed:() => Get.to(() => NotificationScreen()),icon: SvgIcon(AppIcons.notification,color: AppColors.black,)),
            ],
          ),
        ),
      ),
    );
  }
}
