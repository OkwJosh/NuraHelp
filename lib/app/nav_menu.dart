import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:nurahelp/app/common/widgets/no_internet_screen.dart';
import 'package:nurahelp/app/data/services/network_manager.dart';
import 'package:nurahelp/app/features/auth/controllers/sign_up_controllers/sign_up_controller.dart';
import 'package:nurahelp/app/features/main/controllers/dashboard/dashboard_controller.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/features/main/screens/patient_health/patient_health.dart';
import 'package:nurahelp/app/routes/app_routes.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';
import 'common/shimmer/shimmer_effect.dart';
import 'features/main/screens/appointments/appointments.dart';
import 'features/main/screens/dashboard/dashboard.dart';
import 'features/main/screens/doctors/doctors.dart';
import 'features/main/screens/messages_and_calls/messages.dart';
import 'features/main/screens/nura_bot/nura_bot.dart';
import 'features/main/screens/settings/settings.dart';
import 'features/main/screens/symptom_insights/symptom_insights.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final _authController = Get.put(SignUpController());
    final patientController = Get.find<PatientController>();
    final dashboardController = Get.put(DashboardController());
    final networkManager = Get.find<AppNetworkManager>();

    void showLogoutDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.all(10),
          title: Text('Logout Confirmation', style: TextStyle(fontSize: 18)),
          content: SizedBox(
            height: 100,
            child: Column(
              children: [
                Text('Are you sure you want to log out?'),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: AppColors.black),
                      ),
                    ),
                    SizedBox(width: 40),
                    SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                        ),
                        onPressed: () => _authController.logout(),
                        child: Text(
                          'Log out',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: Obx(
        () => AbsorbPointer(
          absorbing:
              dashboardController.isLoading.value ||
              FirebaseAuth.instance.currentUser == null,
          child: Padding(
            padding: EdgeInsets.only(bottom: 35, left: 15, right: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                    blurStyle: BlurStyle.outer,
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Obx(
                () => GNav(
                  selectedIndex: controller.selectedIndex.value,
                  backgroundColor: Colors.white,
                  tabBackgroundColor: AppColors.secondaryColor,
                  tabBorderRadius: 8,
                  tabs: [
                    GButton(
                      icon: AppIcons.navDashboard,
                      margin: const EdgeInsets.only(left: 5),
                      text: 'Dashboard',
                      textStyle: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      iconColor: AppColors.greyColor,
                      iconActiveColor: Colors.white,
                      gap: 3,
                      padding: EdgeInsets.only(
                        right: 5,
                        bottom: 8,
                        top: 8,
                        left: 5,
                      ),
                      onPressed: () {
                        controller.selectedIndex.value = 0;
                        controller.togglePanel.value = false;
                        controller.absorbTouch.value = false;
                      },
                    ),
                    GButton(
                      icon: AppIcons.navHeart,
                      text: 'Health',
                      padding: EdgeInsets.only(
                        right: 5,
                        bottom: 8,
                        top: 8,
                        left: 5,
                      ),
                      gap: 3,
                      textStyle: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      iconColor: AppColors.greyColor,
                      iconActiveColor: Colors.white,
                      onPressed: () {
                        controller.selectedIndex.value = 1;
                        controller.togglePanel.value = false;
                        controller.absorbTouch.value = false;
                      },
                    ),
                    GButton(
                      icon: Symbols.medical_services_rounded,
                      text: 'Doctors',
                      padding: EdgeInsets.only(
                        right: 5,
                        bottom: 8,
                        top: 8,
                        left: 5,
                      ),
                      gap: 3,
                      textStyle: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      iconColor: AppColors.greyColor,
                      iconActiveColor: Colors.white,
                      onPressed: () {
                        controller.selectedIndex.value = 2;
                        controller.togglePanel.value = false;
                        controller.absorbTouch.value = false;
                      },
                    ),
                    GButton(
                      icon: AppIcons.navChart,
                      text: 'Insights',
                      padding: EdgeInsets.only(
                        right: 5,
                        bottom: 8,
                        top: 8,
                        left: 5,
                      ),
                      gap: 5,
                      textStyle: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      iconColor: AppColors.greyColor,
                      iconActiveColor: Colors.white,
                      onPressed: () {
                        controller.selectedIndex.value = 3;
                        controller.togglePanel.value = false;
                        controller.absorbTouch.value = false;
                      },
                    ),
                    GButton(
                      icon: AppIcons.navClipboard,
                      text: 'Appointments',
                      padding: EdgeInsets.only(
                        right: 2,
                        bottom: 8,
                        top: 8,
                        left: 2,
                      ),
                      gap: 2,
                      textStyle: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      iconColor: AppColors.greyColor,
                      iconActiveColor: Colors.white,
                      onPressed: () {
                        controller.selectedIndex.value = 4;
                        controller.togglePanel.value = false;
                        controller.absorbTouch.value = false;
                      },
                    ),
                    GButton(
                      icon: AppIcons.navMore,
                      text: 'More',
                      gap: 5,
                      textStyle: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(right: 5),
                      padding: EdgeInsets.only(
                        right: 12,
                        bottom: 8,
                        top: 8,
                        left: 5,
                      ),
                      textColor: Colors.white,
                      iconColor: AppColors.greyColor,
                      iconActiveColor: Colors.white,
                      onPressed: () {
                        controller.togglePanel.value = true;
                        controller.absorbTouch.value = true;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        // Show no internet screen when there's no connection
        final hasInternet =
            networkManager.connectionStatus.value ==
                ConnectivityResult.mobile ||
            networkManager.connectionStatus.value == ConnectivityResult.wifi;

        if (!hasInternet) {
          return NoInternetScreen(
            onRetry: () {
              // Refresh dashboard data when internet is restored
              dashboardController.refreshDashboardData();
            },
          );
        }

        return Stack(
          children: [
            // Screens
            Obx(() {
              return AbsorbPointer(
                absorbing: controller.absorbTouch.value,
                child: IndexedStack(
                  index: controller.selectedIndex.value,
                  children: controller.screens,
                ),
              );
            }),
            Obx(() {
              if (controller.togglePanel.value == true) {
                return Positioned(
                  left: 140,
                  right: 20,
                  bottom: 110,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 300,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                          blurStyle: BlurStyle.outer,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 5,
                        top: 10,
                        bottom: 5,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Obx(
                                () => patientController.imageLoading.value
                                    ? const AppShimmerEffect(
                                        height: 50,
                                        width: 50,
                                        radius: 50,
                                      )
                                    : Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                        ),
                                        child:
                                            patientController
                                                .patient
                                                .value
                                                .profilePicture!
                                                .isEmpty
                                            ? CircleAvatar(
                                                radius: 30,
                                                backgroundColor: Colors.white,
                                                child: SvgIcon(
                                                  AppIcons.profile,
                                                  size: 30,
                                                ),
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(90),
                                                child: CachedNetworkImage(
                                                  imageUrl: patientController
                                                      .patient
                                                      .value
                                                      .profilePicture!,
                                                  fit: BoxFit.cover,
                                                  progressIndicatorBuilder:
                                                      (
                                                        context,
                                                        url,
                                                        downloadProgress,
                                                      ) =>
                                                          const AppShimmerEffect(
                                                            width: 100,
                                                            height: 100,
                                                            radius: 90,
                                                          ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const Icon(
                                                            Icons.error,
                                                          ),
                                                ),
                                              ),
                                      ),
                              ),
                              SizedBox(width: 15),
                              Text(
                                '${patientController.patient.value.name.split(" ").first} ${patientController.patient.value.nameParts?[1].split("").first.toUpperCase()}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Divider(color: AppColors.greyColor.withOpacity(0.4)),
                          NavListTiles(
                            title: 'Nura Assistant',
                            icon: SvgIcon(
                              AppIcons.star,
                              color: AppColors.greyColor,
                              size: 30,
                            ),
                            onPressed: () => Get.toNamed(AppRoutes.nuraBot),
                          ),
                          SizedBox(height: 10),
                          NavListTiles(
                            title: 'Messages',
                            icon: SvgIcon(
                              AppIcons.messages,
                              color: AppColors.greyColor,
                            ),
                            onPressed: () => Get.toNamed(AppRoutes.messages),
                          ),
                          SizedBox(height: 10),
                          NavListTiles(
                            title: 'Settings',
                            icon: SvgIcon(
                              AppIcons.settings,
                              color: AppColors.greyColor,
                            ),
                            onPressed: () => Get.toNamed(AppRoutes.settings),
                          ),
                          SizedBox(height: 10),
                          NavListTiles(
                            title: 'Log out',
                            icon: SvgIcon(
                              AppIcons.logout,
                              color: AppColors.greyColor,
                              size: 20,
                            ),
                            onPressed: () => showLogoutDialog(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return SizedBox.shrink();
            }),

            // Floating Nav Bar Section
          ],
        );
      }),
    );
  }
}

class NavListTiles extends StatelessWidget {
  const NavListTiles({
    super.key,
    required this.title,
    required this.icon,
    this.showTrailing = false,
    this.trailingIcon = Icons.keyboard_arrow_down,
    required this.onPressed,
  });

  final String title;
  final Widget icon;
  final bool showTrailing;
  final IconData trailingIcon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: ListTile(
        onTap: onPressed,
        minTileHeight: 0,
        contentPadding: EdgeInsets.only(left: 0),
        style: ListTileStyle.list,
        leading: icon,
        trailing: showTrailing ? Icon(trailingIcon) : null,
        iconColor: AppColors.greyColor,
        title: Text(title, maxLines: 1),
        titleTextStyle: TextStyle(
          fontSize: 14,
          fontFamily: 'Poppins-Regular',
          color: Colors.black.withOpacity(0.7),
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final Rx<bool> togglePanel = false.obs;
  final Rx<bool> absorbTouch = false.obs;

  // Using getter to ensure widgets are kept alive
  List<Widget> get screens => [
    _KeepAliveWrapper(child: DashboardScreen()),
    _KeepAliveWrapper(child: PatientHealthScreen()),
    const _KeepAliveWrapper(child: DoctorsScreen()),
    const _KeepAliveWrapper(child: SymptomInsightsScreen()),
    _KeepAliveWrapper(child: AppointmentsScreen()),
  ];
}

/// Wrapper to keep child widget alive in IndexedStack
class _KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const _KeepAliveWrapper({required this.child});

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
