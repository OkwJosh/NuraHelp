import 'package:flutter/material.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';

class TextFieldWithHeader extends StatelessWidget {
  const TextFieldWithHeader({
    super.key, required this.headerText,
  });

  final String headerText;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(headerText,style: TextStyle(fontFamily: 'Poppins-Light',color: AppColors.greyColor,fontSize: 13),),
        SizedBox(
          height: 45,
        child: TextField()),
      ],
    );
  }
}