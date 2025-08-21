import 'dart:io';

class MessageModel {
  String message;
  String status;
  final bool read;
  final DateTime timestamp;
  final File? attachments;
  final String? attachmentType;
  final String receiver;
  final String receiverType;

  MessageModel({
    required this.message,
    required this.status,
    required this.read,
    required this.timestamp,
    required this.attachments,
    this.attachmentType,
    required this.receiver,
    this.receiverType = 'Doctor',
}
  );
}
