import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/features/main/screens/appointments/widgets/tabs_content/canceled_appointment_tab.dart';
import 'package:nurahelp/app/features/main/screens/appointments/widgets/tabs_content/pending_appointment_tab.dart';
import 'package:nurahelp/app/features/main/screens/appointments/widgets/tabs_content/upcoming_appointment_tab.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';
import '../../../../common/appbar/appbar_with_bell.dart';
import '../../../../data/models/patient_model.dart';


class AppointmentsScreen extends StatelessWidget {
  AppointmentsScreen({super.key});

  final _controller = Get.find<PatientController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, child: AppBarWithBell()),
          Positioned.fill(
            top: 110,
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                      DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            Container(
                              color:  AppColors.primaryColor,
                              child: TabBar(
                                indicatorColor: Colors.black,
                                dividerColor: Colors.transparent,
                                isScrollable: true,
                                indicatorSize: TabBarIndicatorSize.tab,
                                tabAlignment: TabAlignment.center,
                                labelColor: Colors.black,
                                unselectedLabelColor: Colors.grey[600],
                                tabs: const [
                                  Tab(child: Text('Upcoming',style: TextStyle(fontFamily: 'Poppins-Regular'))),
                                  // Tab(child: Text('Pending',style: TextStyle(fontFamily: 'Poppins-Regular'),)),
                                  Tab(child: Text('Canceled',style: TextStyle(fontFamily: 'Poppins-Regular'),)),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            AutoScaleTabBarView(
                              children: [

                                UpcomingAppointmentTabContent(patientController: _controller),
                                // PendingAppointmentTabContent(),
                                CanceledAppointmentTabContent(),
                              ],
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
