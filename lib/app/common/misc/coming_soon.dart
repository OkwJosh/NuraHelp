import 'package:flutter/material.dart%20';
import 'package:nurahelp/app/utilities/constants/colors.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Text('Coming Soon',style: TextStyle(fontSize: 18)),
      ),
    );
  }
}

