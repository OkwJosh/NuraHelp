import 'package:flutter/material.dart';
import 'package:nurahelp/app/common/shimmer/shimmer_effect.dart';

/// Shimmer loading screen for Symptom Insights
class SymptomInsightsShimmer extends StatelessWidget {
  const SymptomInsightsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              AppShimmerEffect(
                width: screenWidth - 40,
                height: 250,
                radius: 12,
              ),
              SizedBox(height: screenWidth * 0.1),
              AppShimmerEffect(
                width: screenWidth - 40,
                height: 300,
                radius: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
