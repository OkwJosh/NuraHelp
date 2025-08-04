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
        Text(headerText,style: TextStyle(fontFamily: 'Poppins-Regular',color: AppColors.black300,fontSize: 14)),
        SizedBox(
          height: 52,
        child: TextField()),
      ],
    );
  }
}