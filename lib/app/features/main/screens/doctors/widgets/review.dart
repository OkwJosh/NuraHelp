import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

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
                CircleAvatar(radius: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(patientName,style: TextStyle(fontFamily: 'Poppins-Light'),),
                    Text(
                      date,
                      style: TextStyle(fontFamily: 'Poppins-ExtraLight',fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            RatingStars(
              valueLabelVisibility: false,
              starColor: AppColors.secondaryColor,
              starSize: 15,
              value: 5,
            ),
          ],
        ),
        Text(
          reviewBody,
          style: TextStyle(fontFamily: 'Poppins-ExtraLight',fontSize: 12),

        ),
      ],
    );
  }
}