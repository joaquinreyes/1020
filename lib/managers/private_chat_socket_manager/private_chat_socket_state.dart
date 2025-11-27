import '../../models/private_chat_conversation_model.dart';
import '../../models/private_chat_message_model.dart';

/// State for private chat socket connection
class PrivateChatSocketState {
  final List<PrivateChatMessage> messages;
  final List<PrivateChatConversation> conversations;
  final bool isConnected;
  final String? error;
  final bool hasMoreMessages;
  final bool isLoadingHistory;
  final bool isLoadingConversations;
  final int unreadSenderCount;

  PrivateChatSocketState({
    required this.messages,
    required this.conversations,
    required this.isConnected,
    this.error,
    this.hasMoreMessages = false,
    this.isLoadingHistory = false,
    this.isLoadingConversations = false,
    this.unreadSenderCount = 0,
  });

  factory PrivateChatSocketState.initial() {
    return PrivateChatSocketState(
      messages: [],
      conversations: [],
      isConnected: false,
      error: null,
      hasMoreMessages: false,
      isLoadingHistory: false,
      isLoadingConversations: false,
      unreadSenderCount: 0,
    );
  }

  PrivateChatSocketState copyWith({
    List<PrivateChatMessage>? messages,
    List<PrivateChatConversation>? conversations,
    bool? isConnected,
    String? error,
    bool? hasMoreMessages,
    bool? isLoadingHistory,
    bool? isLoadingConversations,
    int? unreadSenderCount,
    bool clearError = false,
  }) {
    return PrivateChatSocketState(
      messages: messages ?? this.messages,
      conversations: conversations ?? this.conversations,
      isConnected: isConnected ?? this.isConnected,
      error: clearError ? null : (error ?? this.error),
      hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
      isLoadingConversations: isLoadingConversations ?? this.isLoadingConversations,
      unreadSenderCount: unreadSenderCount ?? this.unreadSenderCount,
    );
  }
}
