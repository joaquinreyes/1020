/// Constants for private chat socket events and configuration
class PrivateChatSocketConstants {
  // Socket Event Names - Server to Client (Listen)
  static const String eventConnected = 'privateChat:connected';
  static const String eventPrivateMessage = 'privateMessage';
  static const String eventPrivateMessageSent = 'privateMessageSent';
  static const String eventConversationHistory = 'conversationHistory';
  static const String eventUserConversations = 'userConversations';
  static const String eventMessagesMarkedAsRead = 'messagesMarkedAsRead';
  static const String eventUnreadSenderCount = 'unreadSenderCount';
  static const String eventError = 'error';
  static const String eventConnect = 'connect';
  static const String eventConnectError = 'connect_error';
  static const String eventDisconnect = 'disconnect';

  // Socket Event Names - Client to Server (Emit)
  static const String emitPrivateMessage = 'privateMessage';
  static const String emitMarkAsRead = 'markAsRead';
  static const String emitGetConversationHistory = 'getConversationHistory';
  static const String emitGetUserConversations = 'getUserConversations';
  static const String emitGetUnreadSenderCount = 'getUnreadSenderCount';

  // Socket Event Payload Keys
  static const String keyReceiverId = 'receiver_id';
  static const String keySenderId = 'sender_id';
  static const String keyMessage = 'message';
  static const String keyConversationId = 'conversation_id';
  static const String keyOtherUserId = 'other_user_id';
  static const String keyLimit = 'limit';
  static const String keySkip = 'skip';
  static const String keyUserId = 'userId';
  static const String keyUserName = 'userName';
  static const String keyMessages = 'messages';
  static const String keyHasMore = 'has_more';
  static const String keyConversations = 'conversations';

  // Socket Connection Headers
  static const String headerAuthorization = 'Authorization';
  static const String headerAccessType = 'AccessType';

  // Socket Connection Values
  static const String accessTypeApp = 'app';
  static const String authorizationPrefix = 'Bearer ';

  // Socket Transport Types
  static const String transportWebSocket = 'websocket';
  static const String transportPolling = 'polling';

  // Default Values
  static const int defaultMessageLimit = 50;
  static const int defaultSkip = 0;

  // Error Messages
  static const String errorNotConnected = 'Not connected to chat';
  static const String errorConnectionFailed = 'Connection failed';
  static const String errorSendMessageFailed = 'Failed to send message';
  static const String errorLoadHistoryFailed = 'Failed to load history';
  static const String errorLoadConversationsFailed = 'Failed to load conversations';
  static const String errorProcessMessageFailed = 'Failed to process message';
}
