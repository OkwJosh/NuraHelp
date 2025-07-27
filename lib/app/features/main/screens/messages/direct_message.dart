import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/common/appbar/appbar.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';
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
                  CircleAvatar(radius: 20),
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
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.phone_outlined,size: 30),
                    ),
                    SizedBox(width: 10),
                    IconButton(onPressed: (){},icon: Icon(Icons.more_vert,size: 30,weight: 2)),
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

