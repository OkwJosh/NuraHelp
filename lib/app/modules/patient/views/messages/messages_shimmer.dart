import 'package:flutter/material.dart';
import 'package:nurahelp/app/common/shimmer/shimmer_effect.dart';

/// Shimmer loading screen for Messages/Conversations
class MessagesShimmer extends StatelessWidget {
  const MessagesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 8,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Profile picture
              const AppShimmerEffect(width: 56, height: 56, radius: 28),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppShimmerEffect(width: 140, height: 16, radius: 4),
                        AppShimmerEffect(width: 50, height: 12, radius: 4),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AppShimmerEffect(
                      width: double.infinity,
                      height: 14,
                      radius: 4,
                    ),
                    const SizedBox(height: 4),
                    AppShimmerEffect(width: 180, height: 14, radius: 4),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
