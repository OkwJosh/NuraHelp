import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/models/message_models/message_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService extends GetxService {
  static SocketService get instance => Get.find();

  late IO.Socket socket;
  final RxBool isConnected = false.obs;
  String? _baseUrl;
  String? _userId;

  // Lists of callbacks for different events (support multiple listeners)
  final List<Function(MessageModel)> _newMessageListeners = [];
  final List<Function(String)> _userTypingListeners = [];
  final List<Function(String)> _userStoppedTypingListeners = [];
  final List<Function(String)> _messagesReadListeners = [];
  final List<Function(String messageId)> _messageDeliveredListeners = [];
  final List<Function(String messageId)> _messageReadListeners = [];
  final List<Function(String messageId)> _messageDeletedListeners = [];
  final List<Function(String messageId, String newText)>
  _messageEditedListeners = [];

  // Backward compatibility with single callbacks
  Function(MessageModel)? onNewMessage;
  Function(String)? onUserTyping;
  Function(String)? onUserStoppedTyping;
  Function(String)? onMessagesRead;
  Function(String messageId)? onMessageDelivered;
  Function(String messageId)? onMessageRead;

  // Add listener methods
  void addNewMessageListener(Function(MessageModel) listener) {
    if (!_newMessageListeners.contains(listener)) {
      _newMessageListeners.add(listener);
    }
  }

  void removeNewMessageListener(Function(MessageModel) listener) {
    _newMessageListeners.remove(listener);
  }

  void addMessageDeliveredListener(Function(String messageId) listener) {
    if (!_messageDeliveredListeners.contains(listener)) {
      _messageDeliveredListeners.add(listener);
    }
  }

  void removeMessageDeliveredListener(Function(String messageId) listener) {
    _messageDeliveredListeners.remove(listener);
  }

  void addMessageReadListener(Function(String messageId) listener) {
    if (!_messageReadListeners.contains(listener)) {
      _messageReadListeners.add(listener);
    }
  }

  void removeMessageReadListener(Function(String messageId) listener) {
    _messageReadListeners.remove(listener);
  }

  void addMessageDeletedListener(Function(String messageId) listener) {
    if (!_messageDeletedListeners.contains(listener)) {
      _messageDeletedListeners.add(listener);
    }
  }

  void removeMessageDeletedListener(Function(String messageId) listener) {
    _messageDeletedListeners.remove(listener);
  }

  void addMessageEditedListener(
    Function(String messageId, String newText) listener,
  ) {
    if (!_messageEditedListeners.contains(listener)) {
      _messageEditedListeners.add(listener);
    }
  }

  void removeMessageEditedListener(
    Function(String messageId, String newText) listener,
  ) {
    _messageEditedListeners.remove(listener);
  }

  Future<SocketService> init(String baseUrl, String userId) async {
    _baseUrl = baseUrl;
    _userId = userId;

    socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(5000)
          .build(),
    );

    _setupListeners(userId);

    return this;
  }

  /// Force reconnect the socket (e.g. when network is restored)
  void reconnect() {
    debugPrint('🔄 [SocketService] Reconnecting socket...');
    if (socket.connected) {
      debugPrint('🟢 [SocketService] Already connected, skipping reconnect');
      return;
    }
    socket.connect();
  }

  void _setupListeners(String userId) {
    socket.onConnect((_) {
      debugPrint('🟢 Socket connected');
      isConnected.value = true;
      // Join user's private room
      socket.emit('join', userId);
    });

    socket.onDisconnect((_) {
      debugPrint('🔴 Socket disconnected');
      isConnected.value = false;
    });

    socket.onReconnect((_) {
      debugPrint('🟢 Socket reconnected');
      isConnected.value = true;
      socket.emit('join', userId);
    });

    socket.onReconnectError((error) {
      debugPrint('🔴 Socket reconnect error: $error');
    });

    socket.onError((error) {
      debugPrint('Socket error: $error');
    });

    // Listen for new messages
    socket.on('newMessage', (data) {
      debugPrint('📨 New message received: $data');
      final message = MessageModel.fromJson(data);

      // Call all registered listeners
      for (var listener in _newMessageListeners) {
        listener(message);
      }

      // Call single callback for backward compatibility
      if (onNewMessage != null) {
        onNewMessage!(message);
      }
    });

    // Listen for typing indicators
    socket.on('userTyping', (data) {
      debugPrint('✍️ User typing: $data');
      if (onUserTyping != null && data['sender'] != null) {
        onUserTyping!(data['sender']);
      }
    });

    socket.on('userStoppedTyping', (data) {
      debugPrint('🛑 User stopped typing: $data');
      if (onUserStoppedTyping != null && data['sender'] != null) {
        onUserStoppedTyping!(data['sender']);
      }
    });

    // Listen for read receipts
    socket.on('messagesReadBy', (data) {
      debugPrint('👁️ Messages read by: $data');
      if (onMessagesRead != null && data['reader'] != null) {
        onMessagesRead!(data['reader']);
      }
    });

    // Listen for message delivered event
    socket.on('messageDelivered', (data) {
      debugPrint('📬 Message delivered: $data');
      if (data['messageId'] != null) {
        final messageId = data['messageId'].toString();
        for (var listener in _messageDeliveredListeners) {
          listener(messageId);
        }
        if (onMessageDelivered != null) {
          onMessageDelivered!(messageId);
        }
      }
    });

    // Listen for message read event
    socket.on('messageRead', (data) {
      debugPrint('👓 Message read: $data');
      if (data['messageId'] != null) {
        final messageId = data['messageId'].toString();
        for (var listener in _messageReadListeners) {
          listener(messageId);
        }
        if (onMessageRead != null) {
          onMessageRead!(messageId);
        }
      }
    });

    // TODO: Uncomment when backend supports messageDeleted event
    // Listen for message deleted event
    // socket.on('messageDeleted', (data) {
    //   debugPrint('🗑️ Message deleted: $data');
    //   if (data['messageId'] != null) {
    //     final messageId = data['messageId'].toString();
    //     for (var listener in _messageDeletedListeners) {
    //       listener(messageId);
    //     }
    //   }
    // });

    // TODO: Uncomment when backend supports messageEdited event
    // Listen for message edited event
    // socket.on('messageEdited', (data) {
    //   debugPrint('✏️ Message edited: $data');
    //   if (data['messageId'] != null && data['message'] != null) {
    //     final messageId = data['messageId'].toString();
    //     final newText = data['message'].toString();
    //     for (var listener in _messageEditedListeners) {
    //       listener(messageId, newText);
    //     }
    //   }
    // });
  }

  // SocketService
  void sendMessage({
    required String sender,
    required String senderType,
    required String receiver,
    required String message,
    List<String>? attachments,
    String? attachmentType,
    String? replyToId,
    String? replyToMessage,
    String? replyToSender,
  }) {
    debugPrint('🟡 [SocketService] sendMessage called');

    if (!isConnected.value) {
      debugPrint('❌ [SocketService] Cannot send message: Socket not connected');
      return;
    }

    // Build the payload dynamically to include attachments if they exist
    final payload = <String, dynamic>{
      'sender': sender,
      'senderType': senderType,
      'receiver': receiver,
      'message': message,
      'attachments': attachments ?? [],
      'attachmentType': attachmentType ?? 'text',
      // TODO: Uncomment when backend supports reply fields
      // if (replyToId != null) 'replyToId': replyToId,
      // if (replyToMessage != null) 'replyToMessage': replyToMessage,
      // if (replyToSender != null) 'replyToSender': replyToSender,
    };

    debugPrint(
      '📤 [SocketService] Emitting sendMessage event with payload: $payload',
    );

    socket.emit('sendMessage', payload);

    debugPrint(
      '✅ [SocketService] Message (with attachments) sent to $receiver',
    );
  }

  // Send typing indicator
  void sendTyping(String sender, String receiver) {
    if (!isConnected.value) return;

    socket.emit('typing', {'sender': sender, 'receiver': receiver});
  }

  // Send stop typing indicator
  void sendStopTyping(String sender, String receiver) {
    if (!isConnected.value) return;

    socket.emit('stopTyping', {'sender': sender, 'receiver': receiver});
  }

  // Mark messages as read
  void markMessagesAsRead(String reader, String sender) {
    if (!isConnected.value) return;

    socket.emit('messagesRead', {'reader': reader, 'sender': sender});
  }

  /// Delete a message for everyone
  /// TODO: Uncomment when backend supports deleteMessage
  // void deleteMessage(String messageId, String sender, String receiver) {
  //   if (!isConnected.value) return;
  //
  //   socket.emit('deleteMessage', {
  //     'messageId': messageId,
  //     'sender': sender,
  //     'receiver': receiver,
  //   });
  // }

  /// Edit a message
  /// TODO: Uncomment when backend supports editMessage
  // void editMessage(
  //   String messageId,
  //   String newText,
  //   String sender,
  //   String receiver,
  // ) {
  //   if (!isConnected.value) return;
  //
  //   socket.emit('editMessage', {
  //     'messageId': messageId,
  //     'message': newText,
  //     'sender': sender,
  //     'receiver': receiver,
  //   });
  // }

  // Disconnect
  void disconnect() {
    socket.disconnect();
    socket.dispose();
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
