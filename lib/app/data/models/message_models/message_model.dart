import 'dart:io';

class ChatModel {
  String sender;
  String senderType;
  String message;
  final bool read;
  final DateTime timestamp;
  final File? attachments;
  final String? attachmentType;
  final String receiver;
  final String receiverType;

  ChatModel({
    required this.sender,
    required this.senderType,
    required this.message,
    required this.read,
    required this.timestamp,
    required this.attachments,
    this.attachmentType,
    required this.receiver,
    this.receiverType = 'Doctor',
  });


  factory ChatModel.fromJson(Map<String, dynamic> json){
    return ChatModel(sender: json['sender'],
        senderType: json['senderType'],
        message: json['message'],
        read: json['read'],
        timestamp: DateTime.parse(json['timestamp']),
        attachments: json['attachments'],
        receiver: json['receiver']
    );
  }

}
