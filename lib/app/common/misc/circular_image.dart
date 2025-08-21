import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../shimmer/shimmer_effect.dart';

class AppCircularImage extends StatelessWidget {
  const AppCircularImage({
    super.key,
    this.width = 56,
    this.height = 56,
    this.overlayColor,
    this.backgroundColor,
    this.padding = 8,
    this.radius = 56,
    this.fit = BoxFit.cover,
    required this.image,
    this.isNetworkImage = false,
  });

  final BoxFit fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding,radius;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: backgroundColor ??(Colors.transparent),
        ),
        child: isNetworkImage?ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: CachedNetworkImage(
            fit: fit,
            color: overlayColor,
            imageUrl: image,
            progressIndicatorBuilder: (context,url,downloadProgress) => const AppShimmerEffect(width: 50, height: 50,radius: 45),
            errorWidget: (context,url,error) => const Icon(Icons.error),
          ),
        ):Image(
          fit: fit,
          image: isNetworkImage? NetworkImage(image):AssetImage(image) as ImageProvider,
          color: overlayColor,
        )
    );
  }
}
