import 'dart:io';

enum MessageType{text,document}
enum SenderType{user,bot}

class BotMessageModel {
  String? userId;
  String? threadId;
  String? message;
  SenderType? sender;
  MessageType? messageType;
  File? documentFile;
  bool isLoading;

  BotMessageModel({
    this.userId,
    this.threadId,
    this.message,
    this.documentFile,
    this.messageType,
    this.sender,
    this.isLoading = false,
  });

  static BotMessageModel empty() => BotMessageModel(
    userId: '',
    threadId: '',
    message: '',
    documentFile: null,
  );

  factory BotMessageModel.fromJson(json){
    return BotMessageModel(
      userId: '',
      threadId: json['thread_id'],
      message: json['response'],
      sender: SenderType.bot,
      messageType: MessageType.text,
    );
  }






}
