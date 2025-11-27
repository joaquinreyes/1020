import 'private_chat_message_model.dart';

/// Model for conversation history response
class ConversationHistoryResponse {
  String? conversationId;
  List<PrivateChatMessage>? messages;
  bool? hasMore;

  ConversationHistoryResponse({
    this.conversationId,
    this.messages,
    this.hasMore,
  });

  factory ConversationHistoryResponse.fromJson(Map<String, dynamic> json) {
    return ConversationHistoryResponse(
      conversationId: json['conversation_id']?.toString(),
      messages: json['messages'] != null
          ? List<PrivateChatMessage>.from(
              json['messages'].map((x) => PrivateChatMessage.fromJson(x)))
          : null,
      hasMore: json['has_more'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversation_id': conversationId,
      'messages': messages?.map((x) => x.toJson()).toList(),
      'has_more': hasMore,
    };
  }
}

/// Response model when messages are marked as read
class MessagesMarkedAsReadResponse {
  String? conversationId;

  MessagesMarkedAsReadResponse({this.conversationId});

  factory MessagesMarkedAsReadResponse.fromJson(Map<String, dynamic> json) {
    return MessagesMarkedAsReadResponse(
      conversationId: json['conversation_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversation_id': conversationId,
    };
  }
}
