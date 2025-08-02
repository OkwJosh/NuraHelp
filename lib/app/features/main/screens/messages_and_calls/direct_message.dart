import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/common/appbar/appbar.dart';
import 'package:nurahelp/app/features/main/screens/messages_and_calls/call.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';
import '../../../../common/message_field/message_field.dart';

class DirectMessagePage extends StatelessWidget {
  const DirectMessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: CustomAppBar(
              backgroundColor: Colors.white,
              leadingIcon: Icons.arrow_back_ios_sharp,
              leadingOnPressed: () => Get.back(),
              title: Row(
                children: [
                  CircleAvatar(radius: 20,backgroundColor: Colors.transparent,child: SvgIcon(AppIcons.profile)),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Charles Dickson',style: TextStyle(fontSize: 14,fontFamily: 'Poppins-Regular')),
                      Text('online',style: TextStyle(fontSize: 14,fontFamily: 'Poppins-Light',color: AppColors.greyColor.withOpacity(0.6))),
                    ],
                  ),
                ],
              ),
              actions: [
                Row(
                  children: [
                    SizedBox(
                      width: 45,
                      height: 45,
                      child: OutlinedButton(
                        onPressed: () => Get.to(()=> CallScreen()),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                          padding: EdgeInsets.all(5),
                          backgroundColor: AppColors.greyColor.withOpacity(0.1),
                          overlayColor: AppColors.greyColor,
                        ),

                        child: SvgIcon(AppIcons.phone,size: 30,),
                      ),
                    ),
                    IconButton(onPressed: (){},icon: SvgIcon(AppIcons.ellipsis)),
                  ],
                ),
              ],
            ),
          ),
          Positioned(bottom: 20, right: 0, left: 0, child: CustomTextField()),
        ],
      ),
    );
  }
}

