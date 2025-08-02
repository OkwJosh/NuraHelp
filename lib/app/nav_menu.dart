import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:nurahelp/app/common/misc/coming_soon.dart';
import 'package:nurahelp/app/features/auth/screens/login/login.dart';
import 'package:nurahelp/app/features/main/screens/patient_health/patient_health.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';
import 'features/main/screens/appointments/appointments.dart';
import 'features/main/screens/dashboard/dashboard.dart';
import 'features/main/screens/doctors/doctors.dart';
import 'features/main/screens/messages_and_calls/messages.dart';
import 'features/main/screens/settings/settings.dart';
import 'features/main/screens/symptom_insights/symtom_insights.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 35,left: 15,right: 15),
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
                    fontFamily: "Poppins-Regular",
                    fontWeight: FontWeight.w500,
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
                    fontFamily: "Poppins-Regular",
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  iconColor: AppColors.greyColor,
                  iconActiveColor: Colors.white,
                  onPressed: () {
                    controller.selectedIndex.value = 1;
                    controller.togglePanel.value = false;
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
                    fontFamily: "Poppins-Regular",
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  iconColor: AppColors.greyColor,
                  iconActiveColor: Colors.white,
                  onPressed: () {
                    controller.selectedIndex.value = 2;
                    controller.togglePanel.value = false;
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
                    fontFamily: "Poppins-Regular",
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  iconColor: AppColors.greyColor,
                  iconActiveColor: Colors.white,
                  onPressed: () {
                    controller.selectedIndex.value = 3;
                    controller.togglePanel.value = false;
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
                    fontFamily: "Poppins-Regular",
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  iconColor: AppColors.greyColor,
                  iconActiveColor: Colors.white,
                  onPressed: () {
                    controller.selectedIndex.value = 4;
                    controller.togglePanel.value = false;
                  },
                ),
                GButton(
                  icon: AppIcons.navMore,
                  text: 'More',
                  gap: 5,
                  textStyle: TextStyle(
                    fontFamily: "Poppins-Regular",
                    fontWeight: FontWeight.w500,
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
                  onPressed: () => controller.togglePanel.value = true,
                ),
              ],
            ),
          ),

        ),
      ),
      body: Stack(
        children: [
          // Screens
          Obx(() {
            return IndexedStack(
              index: controller.selectedIndex.value,
              children: controller.screens,
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
                        blurRadius: 10,
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
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: SvgIcon(AppIcons.profile),
                            ),
                            SizedBox(width: 15),
                            Text(
                              "Aldred N",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Poppins-Regular",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Divider(color: AppColors.greyColor.withOpacity(0.4)),
                        NavListTiles(title: "Nura Assistant", icon: SvgIcon(AppIcons.star,color: AppColors.greyColor), onPressed: () => Get.to(() => ComingSoon())),
                        SizedBox(height: 10),
                        NavListTiles(title: "Messages", icon: SvgIcon(AppIcons.messages,color: AppColors.greyColor), onPressed: () => Get.to(() => MessagesScreen())),
                        SizedBox(height: 10),
                        NavListTiles(title: 'Settings', icon: SvgIcon(AppIcons.settings,color: AppColors.greyColor), onPressed: () => Get.to(() => SettingsScreen())),
                        SizedBox(height: 10),
                        NavListTiles(title: 'Logout', icon: SvgIcon(AppIcons.logout,color: AppColors.greyColor,size: 20,), onPressed: () => Get.offAll(() => LoginScreen())),

                        
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
      ),
    );
  }
}

class NavListTiles extends StatelessWidget {
  const NavListTiles({
    super.key,
    required this.title,
    required this.icon,
    this.showTrailing = false,
    this.trailingIcon = Icons.keyboard_arrow_down, required this.onPressed,
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
        trailing: showTrailing?Icon(trailingIcon):null,
        iconColor: AppColors.greyColor,
        title: Text(title, maxLines: 1),
        titleTextStyle: TextStyle(
          fontSize: 14,
          fontFamily: "Poppins-Regular",
          color: Colors.black.withOpacity(0.7),
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final Rx<bool> togglePanel = false.obs;

  final screens = [
    const DashboardScreen(),
    const PatientHealthScreen(),
    const DoctorsScreen(),
    const SymptomInsightsScreen(),
    const AppointmentsScreen(),
  ];
}
