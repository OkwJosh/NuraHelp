import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/features/main/controllers/dashboard/dashboard_controller.dart';
import 'package:nurahelp/app/features/main/controllers/nura_bot/nura_bot_controller.dart';
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
  PatientHealthScreen({super.key});

  final _controller = Get.find<PatientController>();
  final _nuraBotController = Get.find<NuraBotController>();
  final _dashboardController = Get.find<DashboardController>();
  final _healthController = Get.put(PatientHealthController());

  @override
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsets.symmetric(horizontal: 15),
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _controller.patient.value.email,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins-Regular',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _controller.patient.value.phone,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins-Regular',
                                    ),
                                  ),
                                ],
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
                SliverToBoxAdapter(
                  child: DefaultTabController(
                    length: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Container(
                            color: AppColors.primaryColor,
                            child: const TabBar(
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
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'Test Result',
                                    style: TextStyle(
                                      fontFamily: 'Poppins-Medium',
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'Medication',
                                    style: TextStyle(
                                      fontFamily: 'Poppins-Medium',
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          /// ✅ Tab Content
                          SizedBox(
                            height: MediaQuery.of(context).size.height - 250,
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
