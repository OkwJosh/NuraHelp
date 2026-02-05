import 'package:flutter/material.dart';
import 'package:nurahelp/app/common/shimmer/shimmer_effect.dart';

/// Shimmer loading screen for Health section
class HealthShimmer extends StatelessWidget {
  const HealthShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                spacing: 10,
                children: [
                  AppShimmerEffect(width: 50, height: 50, radius: 20),
                  Column(
                    children: [
                      AppShimmerEffect(width: 150, height: 24, radius: 4),
                      const SizedBox(height: 8),
                      AppShimmerEffect(width: 150, height: 16, radius: 4),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 35),

              // Recent activities section
              AppShimmerEffect(width: 180, height: 10, radius: 4),
              const SizedBox(height: 10),
              AppShimmerEffect(width: 150, height: 10, radius: 4),
              const SizedBox(height: 80),
              AppShimmerEffect(width: screenWidth - 60, height: 25, radius: 4),
              SizedBox(height: screenHeight * 0.06),
              AppShimmerEffect(
                width: screenWidth - 40,
                height: 200,
                radius: 16,
              ),
              SizedBox(height: screenHeight * 0.03),
              AppShimmerEffect(
                width: screenWidth - 40,
                height: 200,
                radius: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
