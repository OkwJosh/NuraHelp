import 'package:flutter/material.dart';
import 'package:nurahelp/app/common/shimmer/shimmer_effect.dart';

/// Shimmer loading screen for Direct Message/Chat screen
class DirectMessageShimmer extends StatelessWidget {
  const DirectMessageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(12.0),
          child: AppShimmerEffect(width: 40, height: 40, radius: 8),
        ),
        title: Row(
          children: [
            const AppShimmerEffect(width: 40, height: 40, radius: 20),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmerEffect(width: 120, height: 16, radius: 4),
                const SizedBox(height: 4),
                AppShimmerEffect(width: 80, height: 12, radius: 4),
              ],
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: AppShimmerEffect(width: 40, height: 40, radius: 20),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 8,
              itemBuilder: (context, index) {
                // Alternate between sender and receiver messages
                final isReceived = index % 3 != 0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: isReceived
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      if (isReceived) ...[
                        const AppShimmerEffect(
                          width: 32,
                          height: 32,
                          radius: 16,
                        ),
                        const SizedBox(width: 8),
                      ],
                      AppShimmerEffect(
                        width: screenWidth * 0.6,
                        height: 60,
                        radius: 12,
                      ),
                      if (!isReceived) const SizedBox(width: 8),
                    ],
                  ),
                );
              },
            ),
          ),
          // Message input bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppShimmerEffect(
                    width: double.infinity,
                    height: 50,
                    radius: 25,
                  ),
                ),
                const SizedBox(width: 12),
                const AppShimmerEffect(width: 50, height: 50, radius: 25),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
