import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:nurahelp/app/features/main/patient_health/screens/patient_health.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';
import 'features/main/appointments/appointments.dart';
import 'features/main/dashboard/screens/doctor_dashboard.dart';
import 'features/main/dashboard/screens/dashboard.dart';
import 'features/main/symptom_insights/screens/symtom_insights.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
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
                bottom: 100,
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
                      left: 5,
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
                              foregroundColor: AppColors.secondaryColor,
                            ),
                            SizedBox(width: 15),
                            Text(
                              "Aldred N",
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Poppins-Regular",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Divider(color: AppColors.greyColor.withOpacity(0.4)),
                        NavListTiles(title: "Nura Assistant", icon: Icon(Symbols.star), onPressed: () {  },),
                        SizedBox(height: 10),
                        NavListTiles(title: "Messages", icon: Icon(Symbols.message_rounded), onPressed: () {  },),
                        SizedBox(height: 10),
                        NavListTiles(title: 'Language & Voice', icon: Icon(Symbols.globe),showTrailing: true, onPressed: () {  },),
                        SizedBox(height: 10),
                        NavListTiles(title: 'Settings', icon: Icon(Symbols.settings), onPressed: () {  },),
                        SizedBox(height: 10),
                        NavListTiles(title: 'Logout', icon: Icon(Symbols.logout), onPressed: () {  },),

                        
                      ],
                    ),
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          }),
          // Floating Nav Bar Section
          Positioned(
            left: 16,
            right: 16,
            bottom: 25,
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
                      icon: Symbols.dashboard_2,
                      margin: const EdgeInsets.only(left: 5),
                      text: 'Dashboard',
                      textStyle: TextStyle(
                        fontFamily: "Poppins-Regular",
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      iconColor: AppColors.greyColor,
                      iconActiveColor: Colors.white,
                      gap: 5,
                      padding: EdgeInsets.only(
                        right: 12,
                        bottom: 8,
                        top: 8,
                        left: 12,
                      ),
                      onPressed: () {
                        controller.selectedIndex.value = 0;
                        controller.togglePanel.value = false;
                      },
                    ),
                    GButton(
                      icon: Symbols.assignment,
                      text: 'Health',
                      padding: EdgeInsets.only(
                        right: 0,
                        bottom: 8,
                        top: 8,
                        left: 0,
                      ),
                      gap: 0,
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
                      icon: Symbols.groups,
                      text: 'Doctor',
                      padding: EdgeInsets.only(
                        right: 12,
                        bottom: 8,
                        top: 8,
                        left: 12,
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
                        controller.selectedIndex.value = 2;
                        controller.togglePanel.value = false;
                      },
                    ),
                    GButton(
                      icon: Symbols.insert_chart,
                      text: 'Insights',
                      padding: EdgeInsets.only(
                        right: 12,
                        bottom: 8,
                        top: 8,
                        left: 12,
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
                      icon: Symbols.menu,
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
        onTap: () => onPressed,
        minTileHeight: 0,
        contentPadding: EdgeInsets.only(left: 0),
        style: ListTileStyle.list,
        leading: icon,
        trailing: showTrailing?Icon(trailingIcon):null,
        iconColor: AppColors.greyColor,
        title: Text(title, maxLines: 1),
        titleTextStyle: TextStyle(
          fontSize: 12,
          fontFamily: "Poppins-Light",
          color: Colors.black,
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
    const AppointmentsScreen(),
    const SymptomInsightsScreen(),
  ];
}
