import 'package:flutter/material.dart';

import '../../utilities/constants/colors.dart';

class RoundedContainer extends StatelessWidget {
  RoundedContainer({
    super.key,
    required this.child,
    this.padding = 5.0,
    this.borderRadius = 5.0,
    this.backgroundColor,

  });

  final Widget child;
  final double padding;
  final double borderRadius;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.greyColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.only(left: padding,top: 5,bottom: 5,right: padding),
        child: child
    );
  }
}