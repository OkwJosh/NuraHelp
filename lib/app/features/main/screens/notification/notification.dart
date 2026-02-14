import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/models/notification_item.dart';
import 'package:nurahelp/app/data/services/notification_service.dart';
import 'package:nurahelp/app/features/main/controllers/notification/notification_controller.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';

import '../../../../utilities/constants/icons.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Notifications',
          style: TextStyle(fontSize: 18, fontFamily: 'Poppins-SemiBold'),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          Obx(() {
            if (controller.notifications.isEmpty) return const SizedBox();
            return PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'read_all') {
                  controller.markAllAsRead();
                } else if (value == 'clear_all') {
                  controller.clearAll();
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'read_all',
                  child: Text(
                    'Mark all as read',
                    style: TextStyle(fontFamily: 'Poppins-Regular'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'clear_all',
                  child: Text(
                    'Clear all',
                    style: TextStyle(fontFamily: 'Poppins-Regular'),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
      body: Obx(() {
        final items = controller.notifications;

        if (items.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _NotificationTile(
              item: item,
              onTap: () {
                controller.markAsRead(item.id);
                _navigateToType(item.type);
              },
              onDismiss: () => controller.removeNotification(item.id),
            );
          },
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgIcon(AppIcons.notification_2, size: 48),
            const SizedBox(height: 15),
            const Text(
              'No Notifications Yet',
              style: TextStyle(fontSize: 18, fontFamily: 'Poppins-Medium'),
            ),
            const SizedBox(height: 10),
            const Text(
              'You\'ll be notified here once\nthere\'s something new',
              style: TextStyle(fontSize: 14, fontFamily: 'Poppins-Light'),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToType(NotificationType type) {
    switch (type) {
      case NotificationType.appointment:
        Get.toNamed('/appointments');
        break;
      case NotificationType.symptomReminder:
        Get.toNamed('/symptom-insights');
        break;
      case NotificationType.doctorMessage:
        Get.toNamed('/messages');
        break;
      case NotificationType.medication:
      case NotificationType.testResult:
        Get.toNamed('/patient-health');
        break;
    }
  }
}

// ─── NOTIFICATION TILE WIDGET ──────────────────────────────────────

class _NotificationTile extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationTile({
    required this.item,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.error400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: item.isRead ? Colors.white : AppColors.lightsecondaryColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: item.isRead
                  ? Colors.grey.shade200
                  : AppColors.secondaryColor.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _iconBgColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: _buildIcon()),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: item.isRead
                                  ? 'Poppins-Medium'
                                  : 'Poppins-SemiBold',
                              color: AppColors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!item.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.secondaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.body,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Poppins-Regular',
                        color: AppColors.black300,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatTimeAgo(item.timestamp),
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: 'Poppins-Light',
                        color: AppColors.black200,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    switch (item.type) {
      case NotificationType.appointment:
        return SvgIcon(AppIcons.calender_2, size: 20, color: _iconColor);
      case NotificationType.symptomReminder:
        return Icon(Icons.monitor_heart_outlined, size: 20, color: _iconColor);
      case NotificationType.doctorMessage:
        return SvgIcon(AppIcons.messages, size: 20, color: _iconColor);
      case NotificationType.medication:
        return SvgIcon(AppIcons.pill, size: 20, color: _iconColor);
      case NotificationType.testResult:
        return Icon(Icons.science_outlined, size: 20, color: _iconColor);
    }
  }

  Color get _iconColor {
    switch (item.type) {
      case NotificationType.appointment:
        return AppColors.secondaryColor;
      case NotificationType.symptomReminder:
        return AppColors.warning500;
      case NotificationType.doctorMessage:
        return AppColors.deepSecondaryColor;
      case NotificationType.medication:
        return const Color(0xFF2ECC71);
      case NotificationType.testResult:
        return const Color(0xFF9B59B6);
    }
  }

  Color get _iconBgColor => _iconColor;

  String _formatTimeAgo(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}
