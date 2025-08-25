import 'package:nurahelp/app/data/models/settings_model/notification_model.dart';
import 'package:nurahelp/app/data/models/settings_model/security_model.dart';

class SettingsModel {
  NotificationModel notifications;
  SecurityModel security;

  SettingsModel({required this.notifications, required this.security});

  Map<dynamic, dynamic> toJson() {
    return {
      'security': security.toJson(),
      'notifications': notifications.toJson(),
    };
  }

  static SettingsModel empty() =>
      SettingsModel(
          notifications: NotificationModel.empty(),
          security: SecurityModel.empty(),
      );

  factory SettingsModel.fromJson(json) {
    return SettingsModel(
      notifications: NotificationModel.fromJson(json['notifications']),
      security: SecurityModel.fromJson(json['security']),
    );
  }
}
