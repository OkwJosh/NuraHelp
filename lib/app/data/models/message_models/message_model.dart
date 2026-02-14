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
  final String? replyToId; // ID of the message being replied to
  final String? replyToMessage; // Text preview of the replied message
  final String? replyToSender; // Sender of the replied message
  final bool isDeleted; // Whether this message was deleted for everyone
  final bool isEdited; // Whether this message was edited

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
    this.replyToId,
    this.replyToMessage,
    this.replyToSender,
    this.isDeleted = false,
    this.isEdited = false,
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
      if (replyToId != null) 'replyToId': replyToId,
      if (replyToMessage != null) 'replyToMessage': replyToMessage,
      if (replyToSender != null) 'replyToSender': replyToSender,
      'isDeleted': isDeleted,
      'isEdited': isEdited,
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

    // Resolve the actual content type from server data
    String? resolvedType = json['attachmentType'];
    final messageText = json['message'] ?? '';
    final preview = json['attachmentPreview'] ?? '';

    // Build a list of all paths to check for content type hints
    final allPaths = <String>[messageText, preview, ...?parsedAttachments];

    // Detect voice notes: server may return 'application/octet-stream'
    if (resolvedType != 'voice' &&
        resolvedType != null &&
        resolvedType != 'text') {
      final isVoiceNote = allPaths.any((p) {
        final lower = p.toLowerCase();
        return lower.contains('voice_note') ||
            (lower.endsWith('.m4a') && !lower.contains('|')) ||
            lower.endsWith('.aac') ||
            lower.endsWith('.opus');
      });
      if (isVoiceNote) resolvedType = 'voice';
    }

    // Detect images: server may return full MIME type like 'image/jpeg'
    if (resolvedType != 'image' &&
        resolvedType != null &&
        resolvedType != 'text') {
      if (resolvedType.startsWith('image/')) {
        resolvedType = 'image';
      } else {
        final isImage = allPaths.any((p) {
          final lower = p.toLowerCase();
          return lower.endsWith('.jpg') ||
              lower.endsWith('.jpeg') ||
              lower.endsWith('.png') ||
              lower.endsWith('.gif') ||
              lower.endsWith('.webp');
        });
        if (isImage) resolvedType = 'image';
      }
    }

    return MessageModel(
      id: json['_id'] ?? json['id'] ?? '',
      sender: json['sender'] ?? '',
      senderType: json['senderType'] ?? '',
      receiver: json['receiver'] ?? '',
      receiverType: json['receiverType'] ?? '',
      message: messageText,
      attachments: parsedAttachments,
      attachmentType: resolvedType,
      attachmentPreview: json['attachmentPreview'],
      timestamp: json['timestamp'] != null
          ? (json['timestamp'] is String
                ? DateTime.parse(json['timestamp'])
                : DateTime.fromMillisecondsSinceEpoch(json['timestamp']))
          : DateTime.now(),
      read: json['read'] ?? false,
      delivered: json['delivered'] ?? true,
      replyToId: json['replyToId'],
      replyToMessage: json['replyToMessage'],
      replyToSender: json['replyToSender'],
      isDeleted: json['isDeleted'] ?? false,
      isEdited: json['isEdited'] ?? false,
    );
  }

  // Helper getters
  bool get isImage =>
      attachmentType == 'image' ||
      (attachmentType?.startsWith('image/') ?? false);
  bool get isVoice => attachmentType == 'voice';
  bool get hasAttachment => attachments != null && attachments!.isNotEmpty;

  /// Whether the message can still be edited (within 5 minutes of sending)
  bool get canEdit =>
      !isDeleted && DateTime.now().difference(timestamp).inMinutes < 5;

  /// Returns a user-friendly preview text for conversation lists.
  /// Converts filenames and technical metadata to readable labels.
  String get displayText {
    if (isVoice) return '🎤 Voice note';
    if (isImage) return '📷 Photo';
    if (hasAttachment && attachmentType != null && attachmentType != 'text') {
      return '📎 ${_friendlyText(message)}';
    }
    return _friendlyText(message);
  }

  /// Converts internal message text to user-friendly form.
  /// e.g. "voice_note_1234.m4a" → "Voice note"
  static String friendlyPreview(String text) {
    return _friendlyTextStatic(text);
  }

  String _friendlyText(String text) => _friendlyTextStatic(text);

  static String _friendlyTextStatic(String text) {
    final lower = text.toLowerCase();
    // Voice note filenames
    if (lower.contains('voice_note') && lower.endsWith('.m4a')) {
      return '🎤 Voice note';
    }
    if (lower.endsWith('.m4a') ||
        lower.endsWith('.aac') ||
        lower.endsWith('.opus')) {
      return '🎤 Voice note';
    }
    // Image filenames
    if (lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp')) {
      return '📷 Photo';
    }
    return text;
  }
}
