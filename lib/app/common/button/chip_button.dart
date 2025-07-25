import 'package:flutter/material.dart';

import '../../utilities/constants/colors.dart';

class ChipButton extends StatelessWidget {
  const ChipButton({super.key, required this.buttonText});

  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.greyColor.withOpacity(0.1),
          elevation: 0,
          padding: EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),

        child: Text(
          buttonText,
          style: TextStyle(
            fontFamily: 'Poppins-Regular',
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
