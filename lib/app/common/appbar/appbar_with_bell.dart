import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/common/search_bar/search_bar.dart';
import 'package:nurahelp/app/features/main/screens/notification/notification.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';

import '../../utilities/constants/colors.dart';

class AppBarWithBell extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWithBell({
  this.showSearchBar = true,
    super.key
  });

  final bool showSearchBar;



  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0.5,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
            color: Colors.white
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0,right: 20.0,top: 35),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              showSearchBar?
              Expanded(child: AppSearchBar(hintText: 'Hey Nura, type to ask anything')):
                  SizedBox.shrink(),
              SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5,),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.black,width: 0.3)
                    ),
                    child: IconButton(onPressed:() => Get.to(() => NotificationScreen()),icon: SvgIcon(AppIcons.notification,color: AppColors.black,size: 25,))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override

  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
