class MessageModel {
  final String id; // message ID from MongoDB
  final String sender; // sender user ID
  final String senderType; // "Doctor" or "Patient"
  final String receiver; // receiver user ID
  final String receiverType; // "Doctor" or "Patient"
  final String message; // message text
  final String? attachments; // file path in Firebase Storage
  final String? attachmentType;
  final String? attachmentPreview;
  final DateTime timestamp;
  final bool read;
  final bool delivered; // message delivered status

  MessageModel({
    required this.id,
    required this.sender,
    required this.senderType,
    required this.receiver,
    required this.receiverType,
    required this.message,
    this.attachments,
    this.attachmentType,
    this.attachmentPreview,
    required this.timestamp,
    required this.read,
    this.delivered = true, // default to true
  });

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'senderType': senderType,
      'receiver': receiver,
      'receiverType': receiverType,
      'message': message,
      'attachments': attachments,
      'attachmentType': attachmentType,
      'attachmentPreview': attachmentPreview,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'read': read,
      'delivered': delivered,
    };
  }

  // fromJson factory
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] ?? json['id'] ?? '',
      sender: json['sender'] ?? '',
      senderType: json['senderType'] ?? '',
      receiver: json['receiver'] ?? '',
      receiverType: json['receiverType'] ?? '',
      message: json['message'] ?? '',
      attachments: json['attachments'],
      attachmentType: json['attachmentType'],
      attachmentPreview: json['attachmentPreview'],
      timestamp: json['timestamp'] != null
          ? (json['timestamp'] is String
                ? DateTime.parse(json['timestamp'])
                : DateTime.fromMillisecondsSinceEpoch(json['timestamp']))
          : DateTime.now(),
      read: json['read'] ?? false,
      delivered: json['delivered'] ?? true,
    );
  }

  // Helper getters
  bool get isImage => attachmentType?.startsWith('image/') ?? false;
  bool get isDocument => attachmentType?.startsWith('application/') ?? false;
  bool get hasAttachment => attachments != null;
}
