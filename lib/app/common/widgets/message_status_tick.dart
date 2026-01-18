import 'package:flutter/material.dart';

/// Widget to display message status ticks
/// - Single grey tick: Sent
/// - Double grey ticks: Delivered
/// - Double green ticks: Read
class MessageStatusTick extends StatelessWidget {
  final bool delivered;
  final bool read;
  final Color? color;
  final double size;

  const MessageStatusTick({
    super.key,
    required this.delivered,
    required this.read,
    this.color,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    // If read, show double green ticks
    if (read) {
      return _buildDoubleTick(Colors.green, size);
    }

    // If delivered, show double grey ticks
    if (delivered) {
      return _buildDoubleTick(color ?? Colors.grey[400]!, size);
    }

    // Otherwise, show single grey tick (sent)
    return _buildSingleTick(color ?? Colors.grey[400]!, size);
  }

  Widget _buildSingleTick(Color tickColor, double tickSize) {
    return Icon(Icons.check, color: tickColor, size: tickSize);
  }

  Widget _buildDoubleTick(Color tickColor, double tickSize) {
    return Stack(
      children: [
        Icon(Icons.check, color: tickColor, size: tickSize),
        Positioned(
          left: 4,
          child: Icon(Icons.check, color: tickColor, size: tickSize),
        ),
      ],
    );
  }
}
