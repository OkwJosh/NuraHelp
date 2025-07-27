import 'package:flutter/material.dart';
import 'package:nurahelp/app/features/main/screens/appointments/widgets/tabs_content/canceled_appointment_tab.dart';
import 'package:nurahelp/app/features/main/screens/appointments/widgets/tabs_content/pending_appointment_tab.dart';
import 'package:nurahelp/app/features/main/screens/appointments/widgets/tabs_content/upcoming_appointment_tab.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';
import '../../../../common/appbar/appbar_with_bell.dart';


class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, child: AppBarWithBell()),
          Positioned.fill(
            top: 100,
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                      DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            Container(
                              color:  AppColors.primaryColor,
                              child: TabBar(
                                indicatorColor: Colors.black,
                                dividerColor: Colors.transparent,
                                isScrollable: true,
                                tabAlignment: TabAlignment.start,
                                labelColor: Colors.black,
                                unselectedLabelColor: Colors.grey[600],
                                tabs: const [
                                  Tab(child: Text("Upcoming",style: TextStyle(fontFamily: 'Poppins-Medium'),)),
                                  Tab(child: Text("Pending",style: TextStyle(fontFamily: 'Poppins-Medium'),)),
                                  Tab(child: Text("Canceled",style: TextStyle(fontFamily: 'Poppins-Medium'),)),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            // 🔹 TabBarView (newly added)
                            SizedBox(
                              height: 850,
                              child: TabBarView(
                                children: [
                                  // Tab 1: Overview
                                  UpcomingAppointmentTabContent(),
                                  // Tab 2: Test Result
                                  PendingAppointmentTabContent(),
                                  // Tab 3: Medication
                                  CanceledAppointmentTabContent(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
