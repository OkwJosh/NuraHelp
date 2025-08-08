import 'package:flutter/material.dart';


class SignUpProgressBar extends StatelessWidget {
  const SignUpProgressBar({
    super.key, required this.firstBarColor, required this.secondBarColor, required this.thirdBarColor,
  });


  final Color firstBarColor;
  final Color secondBarColor;
  final Color thirdBarColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          child: Text(''),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: firstBarColor
          ),
          width: 100,
          height: 5,
        ),
        Container(
          child: Text(''),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: secondBarColor
          ),
          width: 100,
          height: 5,
        ),
        Container(
          child: Text(''),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: thirdBarColor
          ),
          width: 100,
          height: 5,
        ),
      ],
    );
  }
}