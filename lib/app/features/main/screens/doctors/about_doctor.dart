import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nurahelp/app/common/appbar/appbar_with_bell.dart';
import 'package:nurahelp/app/features/main/screens/doctors/widgets/tab_contents/about_tab_content.dart';
import 'package:nurahelp/app/features/main/screens/doctors/widgets/tab_contents/reviews_tab_content.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';

import '../../../../utilities/constants/colors.dart';
import '../../../../utilities/constants/icons.dart';


class AboutDoctorScreen extends StatelessWidget {
  const AboutDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Positioned.fill(
            top: 50,
            child: Padding(padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Container(
                      color:  AppColors.primaryColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back_ios)),
                          Padding(
                            padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/5),
                            child: TabBar(
                              indicatorColor: Colors.black,
                              dividerColor: Colors.transparent,
                              isScrollable: true,
                              indicatorWeight: 1,
                              indicatorSize: TabBarIndicatorSize.tab,
                              tabAlignment: TabAlignment.start,
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.grey[600],
                              labelPadding: EdgeInsets.symmetric(horizontal: 20),
                              tabs: const [
                                Tab(child: Text("About",style: TextStyle(fontFamily: 'Poppins-Regular',fontSize: 14),)),
                                Tab(child: Text("Reviews",style: TextStyle(fontFamily: 'Poppins-Regular',fontSize: 14),)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('13 reviews'),
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              spacing: 5,
                              children: [
                                SvgIcon(AppIcons.review),
                                Text(
                                  'Leave a review',
                                  style: TextStyle(color: AppColors.secondaryColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.black26),
                    SizedBox(height: 10),
                    //  TabBarView (newly added)
                    AutoScaleTabBarView(
                      children: [
                        // Tab 1: About
                        SingleChildScrollView(child: AboutTabContent()),
                        // Tab 2: Test Result
                        SingleChildScrollView(child: ReviewsTabContent()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }
}
