import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIcon extends StatelessWidget {
  final String assetName;
  final double size;
  final Color? color;

  const SvgIcon(
      this.assetName, {
        super.key,
        this.size = 24,
        this.color,
      });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
