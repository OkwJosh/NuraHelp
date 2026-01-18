import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/features/main/screens/doctors/widgets/tab_contents/about_tab_content.dart';
import 'package:nurahelp/app/features/main/screens/doctors/widgets/tab_contents/reviews_tab_content.dart';

import '../../../../utilities/constants/colors.dart';


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
                                Tab(child: Text('About',style: TextStyle(fontFamily: 'Poppins-Medium',fontSize: 16),)),
                                Tab(child: Text('Reviews',style: TextStyle(fontFamily: 'Poppins-Medium',fontSize: 16),)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
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
