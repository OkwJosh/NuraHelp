import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nurahelp/app/common/appbar/appbar.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';

import 'messages.dart';

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
              leadingOnPressed: () => Get.to(() => MessagesScreen()),
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
          Positioned(bottom: 15, right: 0, left: 0, child: CustomTextField()),
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.secondaryColor.withOpacity(0.3)),
        color: AppColors.secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          TextField(
            minLines: 1,
            maxLines: 3,
            style: TextStyle(
              color: AppColors.greyColor.withOpacity(0.8),
              fontFamily: 'Poppins-ExtraLight',
              fontSize: 14,
            ),
            cursorColor: AppColors.greyColor,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                left: 20,
                right: 10,
                top: 10,
                bottom: 10,
              ),
              hint: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      " Send a Message",
                      style: TextStyle(
                        fontFamily: "Poppins-ExtraLight",
                        fontWeight: FontWeight.w600,
                        color: AppColors.greyColor.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              hintStyle: TextStyle(
                color: AppColors.greyColor.withOpacity(0.6),
                fontFamily: "Poppins",
              ),
              fillColor: Colors.transparent,
              filled: true,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.attach_file)),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.mic_none_outlined),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.send, color: AppColors.secondaryColor),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
