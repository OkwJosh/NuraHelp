class MessageModel {
  final String id;
  final String sender;
  final String senderType;
  final String receiver;
  final String receiverType;
  final String message;
  // FIX: Changed from String? to List<String>? for future-proofing
  final List<String>? attachments;
  final String? attachmentType;
  final String? attachmentPreview;
  final DateTime timestamp;
  final bool read;
  final bool delivered;
  final bool isUploading; // Added for UI progress state

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
    this.delivered = true,
    this.isUploading = false,
  });

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
      'timestamp': timestamp.toIso8601String(), // ISO format is safer for APIs
      'read': read,
      'delivered': delivered,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    // Helper to handle single string or list from different API versions
    List<String>? parsedAttachments;
    if (json['attachments'] is String) {
      parsedAttachments = [json['attachments']];
    } else if (json['attachments'] is List) {
      parsedAttachments = List<String>.from(json['attachments']);
    }

    return MessageModel(
      id: json['_id'] ?? json['id'] ?? '',
      sender: json['sender'] ?? '',
      senderType: json['senderType'] ?? '',
      receiver: json['receiver'] ?? '',
      receiverType: json['receiverType'] ?? '',
      message: json['message'] ?? '',
      attachments: parsedAttachments,
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
  bool get isImage =>
      attachmentType == 'image' ||
      (attachmentType?.startsWith('image/') ?? false);
  bool get hasAttachment => attachments != null && attachments!.isNotEmpty;
}
