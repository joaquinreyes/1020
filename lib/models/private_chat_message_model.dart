/// Model for private chat messages
class PrivateChatMessage {
  String? id;
  String? conversationId;
  String? senderId;
  String? receiverId;
  String? message;
  bool? isRead;
  String? readAt;
  String? createdAt;

  PrivateChatMessage({
    this.id,
    this.conversationId,
    this.senderId,
    this.receiverId,
    this.message,
    this.isRead,
    this.readAt,
    this.createdAt,
  });

  factory PrivateChatMessage.fromJson(Map<String, dynamic> json) {
    return PrivateChatMessage(
      id: json['_id']?.toString(),
      conversationId: json['conversation_id']?.toString(),
      senderId: json['sender_id']?.toString(),
      receiverId: json['receiver_id']?.toString(),
      message: json['message']?.toString(),
      isRead: json['is_read'] as bool?,
      readAt: json['read_at']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'is_read': isRead,
      'read_at': readAt,
      'created_at': createdAt,
    };
  }

  PrivateChatMessage copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? receiverId,
    String? message,
    bool? isRead,
    String? readAt,
    String? createdAt,
  }) {
    return PrivateChatMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Response model when a message is sent
class PrivateMessageSentResponse {
  PrivateChatMessage? message;

  PrivateMessageSentResponse({this.message});

  factory PrivateMessageSentResponse.fromJson(Map<String, dynamic> json) {
    return PrivateMessageSentResponse(
      message: json['message'] != null
          ? PrivateChatMessage.fromJson(json['message'])
          : PrivateChatMessage.fromJson(json),
    );
  }
}

/// Response model when a message is received
class PrivateMessageReceivedResponse {
  PrivateChatMessage? message;

  PrivateMessageReceivedResponse({this.message});

  factory PrivateMessageReceivedResponse.fromJson(Map<String, dynamic> json) {
    return PrivateMessageReceivedResponse(
      message: json['message'] != null
          ? PrivateChatMessage.fromJson(json['message'])
          : PrivateChatMessage.fromJson(json),
    );
  }
}
