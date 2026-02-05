import 'package:flutter/material.dart';
import 'package:nurahelp/app/common/shimmer/shimmer_effect.dart';

/// Shimmer loading screen for Settings
class SettingsShimmer extends StatelessWidget {
  const SettingsShimmer({super.key});

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
              // Profile section
              Center(
                child: Column(
                  children: [
                    const AppShimmerEffect(width: 100, height: 100, radius: 50),
                    const SizedBox(height: 16),
                    AppShimmerEffect(width: 150, height: 20, radius: 4),
                    const SizedBox(height: 8),
                    AppShimmerEffect(width: 200, height: 16, radius: 4),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Settings sections
              _buildSectionShimmer(screenWidth, 'Account Settings', 4),
              const SizedBox(height: 24),
              _buildSectionShimmer(screenWidth, 'Notifications', 3),
              const SizedBox(height: 24),
              _buildSectionShimmer(screenWidth, 'Security', 2),
              const SizedBox(height: 24),
              _buildSectionShimmer(screenWidth, 'About', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionShimmer(double screenWidth, String title, int itemCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppShimmerEffect(width: 150, height: 18, radius: 4),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  const AppShimmerEffect(width: 40, height: 40, radius: 20),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppShimmerEffect(width: 140, height: 16, radius: 4),
                        const SizedBox(height: 6),
                        AppShimmerEffect(width: 200, height: 12, radius: 4),
                      ],
                    ),
                  ),
                  const AppShimmerEffect(width: 20, height: 20, radius: 4),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
