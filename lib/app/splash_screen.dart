import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:nurahelp/app/features/auth/screens/sign_up/sign_up.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';

import 'bindings/general_bindings.dart';
import 'features/auth/screens/login/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );


    _controller.forward();

    Timer(const Duration(milliseconds: 4200), () {
      Get.offAll(()=>LoginScreen(),transition: Transition.fadeIn,duration: Duration(seconds: 2),binding: GeneralBindings()); // or Navigator.pushReplacement...
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepSecondaryColor, // Or your app theme color
      body: SizedBox.expand(
          child: FittedBox(
              fit: BoxFit.cover,
              child: Image.asset(
                  width: 334,
                  height: 734,
                  'assets/logo/logo_animation.gif',fit: BoxFit.cover)))
    );
  }
}
