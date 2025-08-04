import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utilities/device/device_utility.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key,
    this.title,
    this.showBackArrow = false,
    this.leadingIcon,
    this.actions,
    this.leadingOnPressed, this.backgroundColor});

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: AppBar(
          backgroundColor: backgroundColor,
          automaticallyImplyLeading: false,
          leading: showBackArrow
              ? IconButton(
              onPressed: () => Get.back(), icon: Icon(Icons.arrow_back,color:Colors.black))
              : leadingIcon != null
              ? IconButton(
              onPressed: leadingOnPressed, icon: Icon(leadingIcon))
              : null,
          title: title,
          actions: actions,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppDeviceUtils.getAppBarHeight());
}
