import 'package:flutter/material.dart';
import 'package:nurahelp/app/common/list_tiles/message_list_tile.dart';

import '../../../../common/appbar/appbar_with_bell.dart';
import '../../../../common/search_bar/search_bar.dart';
import '../../../../utilities/constants/colors.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, child: AppBarWithBell()),
          Positioned.fill(
            top: 130,
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AppSearchBar(
                        hintText: "Search type of Keywords",
                      ),
                      SizedBox(height: 32),
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
