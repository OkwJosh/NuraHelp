import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:nurahelp/app/common/appbar/appbar_with_bell.dart';
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
          Positioned(top: 0, left: 0, right: 0, child: AppBarWithBell()),
          Positioned.fill(
            top: 110,
            child: Padding(padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Container(
                      color:  AppColors.primaryColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TabBar(
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
                                Icon(
                                  Icons.message_outlined,
                                  color: AppColors.secondaryColor,
                                ),
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
