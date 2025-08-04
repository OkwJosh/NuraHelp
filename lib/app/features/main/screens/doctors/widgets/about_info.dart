import 'package:flutter/material.dart';

class AboutInfoColumn extends StatelessWidget {
  const AboutInfoColumn({
    super.key, required this.headerText, required this.bodyText, required this.icon,
  });

  final String headerText;
  final String bodyText;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 5,
          children: [
            icon,
            Text(headerText,style: TextStyle(fontSize: 16,fontFamily: "Poppins-Regular")),
          ],
        ),
        Text(bodyText,style: TextStyle(fontFamily: 'Poppins-Light',fontSize: 16),)
      ],
    );
  }
}