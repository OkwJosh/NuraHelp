import 'package:flutter/material.dart';
import 'package:nurahelp/app/common/shimmer/shimmer_effect.dart';

/// Shimmer loading screen for Dashboard
/// Matches the exact layout of the actual dashboard
class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

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
              AppShimmerEffect(width: screenWidth - 40, height: 60, radius: 12),
              const SizedBox(height: 24),

              // Quick actions title
              AppShimmerEffect(width: 120, height: 18, radius: 4),
              const SizedBox(height: 16),

              // Quick actions grid
              AppShimmerEffect(width: 350, height: 170),
              SizedBox(height: screenHeight / 5),

              Align(
                alignment: Alignment.center,
                child: AppShimmerEffect(width: 250, height: 18, radius: 4),
              ),

              const SizedBox(height: 16),
              AppShimmerEffect(
                width: screenWidth - 40,
                height: 150,
                radius: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
