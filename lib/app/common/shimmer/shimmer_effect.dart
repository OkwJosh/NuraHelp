import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../utilities/constants/colors.dart';

class AppShimmerEffect extends StatelessWidget {
  const AppShimmerEffect(
      {super.key,
        required this.width,
        required this.height,
        this.radius = 15,
        this.color});

  final double width, height, radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[850]!,
        highlightColor: Colors.grey[700]! ,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color??(AppColors.greyColor),
            borderRadius: BorderRadius.circular(radius),
          ),
        ));
  }
}
