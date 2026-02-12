import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/features/main/controllers/dashboard/dashboard_controller.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_health_controller.dart';
import 'package:nurahelp/app/features/main/screens/patient_health/widgets/patient_info_header.dart';
import 'package:nurahelp/app/features/main/screens/patient_health/widgets/tab_content/medication_tab_content.dart';
import 'package:nurahelp/app/features/main/screens/patient_health/widgets/tab_content/overview_tab_content.dart';
import 'package:nurahelp/app/features/main/screens/patient_health/widgets/tab_content/test_result_tab_content.dart';
import 'package:nurahelp/app/modules/patient/views/health/health_shimmer.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';
import '../../../../common/appbar/appbar_with_bell.dart';

class PatientHealthScreen extends StatelessWidget {
  PatientHealthScreen({super.key}) {
    // Ensure PatientHealthController is available for child widgets
    Get.put(PatientHealthController());
  }

  final _controller = Get.find<PatientController>();
  final _dashboardController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 360;
    final baseFontSize = isSmall ? 13.0 : 14.0;
    final titleFontSize = isSmall ? 14.0 : 16.0;
    final horizontalPadding = isSmall ? 10.0 : 15.0;

    return Obx(() {
      if (_dashboardController.isLoading.value) {
        return const HealthShimmer();
      }
      return Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: AppBarWithBell(),
        body: SafeArea(
          child: RefreshIndicator(
            backgroundColor: Colors.white,
            color: AppColors.secondaryColor,
            onRefresh: () => _dashboardController.refreshDashboardData(),
            child: CustomScrollView(
              slivers: [
                /// Header Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PatientInfoHeader(patientController: _controller),
                          const Divider(
                            color: AppColors.black300,
                            thickness: 0.3,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _controller.patient.value.email,
                                      style: TextStyle(
                                        fontFamily: 'Poppins-Regular',
                                        fontSize: baseFontSize,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _controller.patient.value.phone,
                                      style: TextStyle(
                                        fontFamily: 'Poppins-Regular',
                                        fontSize: baseFontSize,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),

                /// TabBar and Content
                SliverFillRemaining(
                  hasScrollBody: true,
                  child: DefaultTabController(
                    length: 3,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: Column(
                        children: [
                          Container(
                            color: AppColors.primaryColor,
                            child: TabBar(
                              indicatorColor: Colors.black,
                              dividerColor: Colors.transparent,
                              isScrollable: true,
                              tabAlignment: TabAlignment.center,
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelColor: Colors.black,
                              unselectedLabelColor: AppColors.black300,
                              tabs: [
                                Tab(
                                  child: Text(
                                    'Overview',
                                    style: TextStyle(
                                      fontFamily: 'Poppins-Medium',
                                      fontSize: titleFontSize,
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'Test Result',
                                    style: TextStyle(
                                      fontFamily: 'Poppins-Medium',
                                      fontSize: titleFontSize,
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'Medication',
                                    style: TextStyle(
                                      fontFamily: 'Poppins-Medium',
                                      fontSize: titleFontSize,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          /// Tab Content
                          Expanded(
                            child: TabBarView(
                              children: [
                                OverviewTabContent(
                                  patientController: _controller,
                                ),
                                TestResultTabContent(
                                  patientController: _controller,
                                ),
                                MedicationTabContent(
                                  patientController: _controller,
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
          ),
        ),
      );
    });
  }
}
