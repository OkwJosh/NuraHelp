import 'package:nurahelp/app/data/models/message_models/message_model.dart';

class ConversationModel {
  final String userId; // the other user's ID
  final String userName; // other user's name
  final String? userProfilePic; // other user's profile picture
  final String userType; // "Doctor" or "Patient"
  final String? userEmail; // other user's email
  final String? userPhone; // other user's phone
  final String? userHospital; // hospital (if doctor)
  final String? userSpecialty; // specialty (if doctor)
  final String lastMessage; // last message text
  final DateTime lastTimestamp; // when last message was sent
  final String lastSender; // who sent last message
  final int unreadCount; // number of unread messages
  final bool lastMessageDelivered; // delivery status of last message
  final bool lastMessageRead; // read status of last message

  ConversationModel({
    required this.userId,
    required this.userName,
    this.userProfilePic,
    required this.userType,
    this.userEmail,
    this.userPhone,
    this.userHospital,
    this.userSpecialty,
    required this.lastMessage,
    required this.lastTimestamp,
    required this.lastSender,
    required this.unreadCount,
    this.lastMessageDelivered = true,
    this.lastMessageRead = false,
  });

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      '_id': userId,
      'lastMessage': lastMessage,
      'lastTimestamp': lastTimestamp.toIso8601String(),
      'lastSender': lastSender,
      'unreadCount': unreadCount,
      'lastMessageDelivered': lastMessageDelivered,
      'lastMessageRead': lastMessageRead,
      'user': {
        '_id': userId,
        'name': userName,
        'profilePicture': userProfilePic,
        'type': userType,
        'email': userEmail,
        'phone': userPhone,
        'hospital': userHospital,
        'specialty': userSpecialty,
      },
    };
  }

  // fromJson factory - matches actual API response structure
  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    final userObject = json['user'] ?? {};

    return ConversationModel(
      userId: json['_id'] ?? '',
      userName: userObject['name'] ?? '',
      userProfilePic: userObject['profilePicture'],
      userType: userObject['type'] ?? '',
      userEmail: userObject['email'],
      userPhone: userObject['phone'],
      userHospital: userObject['hospital'],
      userSpecialty: userObject['specialty'],
      lastMessage: _resolveLastMessage(json['lastMessage'] ?? ''),
      lastTimestamp: json['lastTimestamp'] != null
          ? (json['lastTimestamp'] is String
                ? DateTime.parse(json['lastTimestamp'])
                : DateTime.fromMillisecondsSinceEpoch(json['lastTimestamp']))
          : DateTime.now(),
      lastSender: json['lastSender'] ?? '',
      unreadCount: json['unreadCount'] ?? 0,
      lastMessageDelivered: json['lastMessageDelivered'] ?? true,
      lastMessageRead: json['lastMessageRead'] ?? false,
    );
  }

  // Helper getters
  bool get hasUnread => unreadCount > 0;
  bool get isDoctor => userType == 'Doctor';
  bool get isPatient => userType == 'Patient';

  /// Converts internal filenames to friendly text for preview
  static String _resolveLastMessage(String text) {
    return MessageModel.friendlyPreview(text);
  }

  // Check if the last message was sent by the current user
  bool isLastMessageMine(String currentUserId) => lastSender == currentUserId;
}
