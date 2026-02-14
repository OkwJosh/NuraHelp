import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nurahelp/app/data/models/notification_item.dart';
import 'package:nurahelp/app/data/services/notification_service.dart';

/// Controller that persists and exposes in-app notification history.
class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();

  static const _storageKey = 'notification_history';
  static const _maxItems = 100;

  final notifications = <NotificationItem>[].obs;
  final unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  // ─── PUBLIC API ───────────────────────────────────────────────────

  /// Add a new notification to the history list.
  void addNotification({
    required NotificationType type,
    required String title,
    required String body,
  }) {
    final item = NotificationItem(
      id: '${DateTime.now().millisecondsSinceEpoch}_${type.name}',
      type: type,
      title: title,
      body: body,
      timestamp: DateTime.now(),
    );

    notifications.insert(0, item);

    // Cap list size
    if (notifications.length > _maxItems) {
      notifications.removeRange(_maxItems, notifications.length);
    }

    _updateUnreadCount();
    _saveToStorage();
  }

  /// Mark a single notification as read.
  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index].isRead = true;
      notifications.refresh();
      _updateUnreadCount();
      _saveToStorage();
    }
  }

  /// Mark all notifications as read.
  void markAllAsRead() {
    for (final item in notifications) {
      item.isRead = true;
    }
    notifications.refresh();
    _updateUnreadCount();
    _saveToStorage();
  }

  /// Clear all notification history.
  void clearAll() {
    notifications.clear();
    _updateUnreadCount();
    _saveToStorage();
  }

  /// Remove a single notification.
  void removeNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
    _updateUnreadCount();
    _saveToStorage();
  }

  // ─── PERSISTENCE ─────────────────────────────────────────────────

  void _updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw != null && raw.isNotEmpty) {
        notifications.value = NotificationItem.decodeList(raw);
        _updateUnreadCount();
      }
    } catch (_) {}
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _storageKey,
        NotificationItem.encodeList(notifications),
      );
    } catch (_) {}
  }
}
