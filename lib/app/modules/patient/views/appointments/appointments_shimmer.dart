import 'package:flutter/material.dart';
import 'package:nurahelp/app/common/shimmer/shimmer_effect.dart';

/// Shimmer loading screen for Appointments
class AppointmentsShimmer extends StatelessWidget {
  const AppointmentsShimmer({super.key});

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
              // Tab buttons
              Row(
                children: [
                  Expanded(
                    child: AppShimmerEffect(
                      width: double.infinity,
                      height: 44,
                      radius: 12,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: AppShimmerEffect(
                      width: double.infinity,
                      height: 44,
                      radius: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Appointment cards
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: AppShimmerEffect(
                      width: screenWidth - 40,
                      height: 140,
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
