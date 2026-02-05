import 'package:flutter/material.dart';
import 'package:nurahelp/app/common/shimmer/shimmer_effect.dart';

/// Shimmer loading screen for Doctors list
class DoctorsShimmer extends StatelessWidget {
  const DoctorsShimmer({super.key});

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
              // Search ba
              AppShimmerEffect(width: 120, height: 40, radius: 10),
              const SizedBox(height: 24),

              AppShimmerEffect(width: screenWidth - 40, height: 50, radius: 12),
              const SizedBox(height: 24),

              // Doctor cards
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: AppShimmerEffect(
                      width: screenWidth - 40,
                      height: 150,
                      radius: 16,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
