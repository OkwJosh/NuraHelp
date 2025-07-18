import 'package:flutter/material.dart';

class RoundedIconContainer extends StatelessWidget {
  const RoundedIconContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height:40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(
          Radius.circular(7),
        ),
      ),
      child: Icon(Icons.person),
    );
  }
}