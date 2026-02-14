import 'package:flutter/material.dart';

class MessageStatusTick extends StatelessWidget {
  final bool delivered;
  final bool read;
  final bool isUploading; // Add this
  final Color? color;
  final double size;

  const MessageStatusTick({
    super.key,
    required this.delivered,
    required this.read,
    this.isUploading = false, // Default false
    this.color,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Uploading State (Clock Icon)
    if (isUploading) {
      return Icon(
        Icons.access_time,
        color: color ?? Colors.grey[400],
        size: size,
      );
    }

    // 2. Read State (Blue/Green Double Tick)
    if (read) {
      return _buildDoubleTick(Colors.blueAccent, size); // WhatsApp uses Blue
    }

    // 3. Delivered State (Grey Double Tick)
    if (delivered) {
      return _buildDoubleTick(color ?? Colors.grey[400]!, size);
    }

    // 4. Sent State (Single Grey Tick)
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
