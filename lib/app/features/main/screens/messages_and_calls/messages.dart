import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/common/list_tiles/message_list_tile.dart';
import '../../../../common/appbar/appbar_with_bell.dart';
import '../../../../common/search_bar/search_bar.dart';
import '../../../../nav_menu.dart';
import '../../../../utilities/constants/colors.dart';
import 'direct_message.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Row(
                children: [
                  IconButton(onPressed: () => Get.offAll(() => NavigationMenu()), icon: Icon(Icons.arrow_back_ios)),
                  Text('Messages',style: TextStyle(fontSize: 18,fontFamily: 'Poppins-SemiBold'),)
                ],
              ),
            ),),
          Positioned.fill(
            top: 100,
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AppSearchBar(
                        hintText: "Search type of Keywords",
                      ),
                      SizedBox(height: 20),
                      MessageListTile(onPressed: () => Get.to(()=> DirectMessagePage()), contactName: 'Charles Dickson', lastMessage: 'It\'s Official, Thank you', unreadMessagesNumber: 3,backgroundColor: Colors.transparent),
                      MessageListTile(onPressed: (){}, contactName: 'Charles Dickson', lastMessage: 'It\'s Official, Thank you', unreadMessagesNumber: 3,backgroundColor: Colors.transparent),
                      MessageListTile(onPressed: (){}, contactName: 'Charles Dickson', lastMessage: 'It\'s Official, Thank you', unreadMessagesNumber: 3,backgroundColor: Colors.transparent),
                      MessageListTile(onPressed: (){}, contactName: 'Charles Dickson', lastMessage: 'It\'s Official, Thank you', unreadMessagesNumber: 3,backgroundColor: Colors.transparent),
                      MessageListTile(onPressed: (){}, contactName: 'Charles Dickson', lastMessage: 'It\'s Official, Thank you', unreadMessagesNumber: 3,backgroundColor: Colors.transparent),

                    ],
                  ),
                ),
              ),
          )
        ],
      ),
    );
  }
}
