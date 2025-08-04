import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';

import '../../../../../utilities/constants/colors.dart';


class Reviews extends StatelessWidget {
  const Reviews({super.key, required this.patientName, required this.date, required this.reviewBody});

  final String patientName;
  final String date;
  final String reviewBody;


  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 15,
              children: [
                CircleAvatar(radius: 20,backgroundColor: Colors.transparent,child: SvgIcon(AppIcons.profile)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(patientName,style: TextStyle(fontFamily: 'Poppins-Medium',fontSize: 16),),
                    Text(
                      date,
                      style: TextStyle(fontFamily: 'Poppins-Regular',fontSize: 16,color: AppColors.black300),
                    ),
                  ],
                ),
              ],
            ),
            RatingStars(
              starBuilder: (index, color) => SvgIcon(AppIcons.reviewStar,color: color),
              valueLabelVisibility: false,
              starColor: AppColors.secondaryColor,
              starSize: 20,
              starSpacing: 3,
              value: 5,
            ),
          ],
        ),
        Text(
          reviewBody,
          style: TextStyle(fontFamily: 'Poppins-Light',fontSize: 16),

        ),
      ],
    );
  }
}