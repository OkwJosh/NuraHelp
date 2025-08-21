import 'package:nurahelp/app/data/models/settings_model/notification_model.dart';
import 'package:nurahelp/app/data/models/settings_model/security_model.dart';

class SettingsModel {
  final NotificationModel notifications;
  final SecurityModel security;

  SettingsModel({required this.notifications, required this.security});

  Map<dynamic, dynamic> toJson() {
    return {
      'security': security.toJson(),
      'notification': notifications.toJson(),
    };
  }

  factory SettingsModel.fromJson(json) {
    return SettingsModel(
      notifications: NotificationModel.fromJson(json['notifications']),
      security: SecurityModel.fromJson(json['security']),
    );
  }
}
