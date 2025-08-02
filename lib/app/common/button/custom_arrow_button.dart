import 'package:flutter/material.dart';

import '../../utilities/constants/colors.dart';

class CustomArrowButton extends StatelessWidget {
  const CustomArrowButton({
    super.key,
    this.icon =  Icons.arrow_back_ios
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: AppColors.black,
            width: 0.3,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      ),
      onPressed: () {},
      icon: Icon(icon,color: AppColors.black),
    );
  }
}