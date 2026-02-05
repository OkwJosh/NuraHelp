import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/common/search_bar/search_bar.dart';
import 'package:nurahelp/app/features/main/controllers/nura_bot/nura_bot_controller.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/features/main/screens/notification/notification.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';
import '../../features/main/screens/nura_bot/nura_bot.dart';
import '../../nav_menu.dart';
import '../../utilities/constants/colors.dart';

class AppBarWithBell extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWithBell({
    this.showSearchBar = true,
    super.key,
    this.dynamicAppIcon = true,
  });

  final bool showSearchBar;
  final bool dynamicAppIcon;

  @override
  Widget build(BuildContext context) {
    final _controller = Get.find<NuraBotController>();
    final _patientController = Get.find<PatientController>();
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => NavigationMenu());
        return false;
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(
          top: 40,
          left: 15,
          right: 15,
          bottom: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (showSearchBar)
              Expanded(
                child: AppSearchBar(
                  hintText: 'Hey Nura, type to ask anything',
                  textEditingController: _controller.messageController,
                ),
              ),
            if (showSearchBar) const SizedBox(width: 10),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller.messageController,
              builder: (context, value, child) {
                final hasText = value.text.trim().isNotEmpty;
                // Only show dynamic icon switching if dynamicAppIcon is true
                final shouldSwitch = dynamicAppIcon && hasText;

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.black, width: 0.3),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      if (hasText) {
                        final focusScope = FocusScope.of(context);
                        focusScope.unfocus();
                        await Future.delayed(const Duration(milliseconds: 350));
                        Get.to(
                          () => const NuraBot(),
                          transition: Transition.rightToLeftWithFade,
                        );
                        _controller.sendBotMessage(
                          patient: _patientController.patient.value,
                        );
                      } else {
                        Get.to(() => NotificationScreen());
                      }
                    },
                    icon: SvgIcon(
                      shouldSwitch ? AppIcons.send : AppIcons.notification,
                      color: shouldSwitch
                          ? AppColors.secondaryColor
                          : AppColors.black,
                      size: shouldSwitch ? 22 : 25,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}
