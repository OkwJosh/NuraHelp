import 'package:flutter/material.dart';

import '../../utilities/constants/colors.dart';

class RoundedContainer extends StatelessWidget {
  const RoundedContainer({
    super.key,
    required this.child,
    this.padding = 5.0,
    this.borderRadius = 5.0,
  });

  final Widget child;
  final double padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: AppColors.greyColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.only(left: padding,top: 5,bottom: 5,right: padding),
        child: child
    );
  }
}