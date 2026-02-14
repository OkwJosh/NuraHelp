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
  
  // Attachment fields
  String? attachmentPath; // Firebase Storage URL or local path
  String? attachmentName;
  String? attachmentType; // file type: pdf, doc, image, etc.
  double uploadProgress; // 0.0 to 1.0
  bool isUploading;
  String? attachmentSize; // File size as string (e.g., "2.5 MB")

  BotMessageModel({
    this.userId,
    this.threadId,
    this.message,
    this.documentFile,
    this.messageType,
    this.sender,
    this.isLoading = false,
    this.attachmentPath,
    this.attachmentName,
    this.attachmentType,
    this.uploadProgress = 0.0,
    this.isUploading = false,
    this.attachmentSize,
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
  
  // Helper getters
  bool get hasAttachment => attachmentPath != null && attachmentPath!.isNotEmpty;
  bool get isImage => attachmentType?.startsWith('image/') ?? false;
  bool get isDocument => attachmentType?.startsWith('application/') ?? false;
  bool get isPdf => attachmentType == 'application/pdf';
}







