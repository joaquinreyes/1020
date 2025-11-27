import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../globals/constants.dart';
import '../../models/private_chat_conversation_model.dart';
import '../../models/private_chat_history_model.dart';
import '../../models/private_chat_message_model.dart';
import '../api_manager.dart';
import '../user_manager.dart';
import 'private_chat_socket_constants.dart';
import 'private_chat_socket_state.dart';

final privateChatSocketProvider =
    StateNotifierProvider<PrivateChatSocketNotifier, PrivateChatSocketState>(
  (ref) => PrivateChatSocketNotifier(ref),
);

class PrivateChatSocketNotifier extends StateNotifier<PrivateChatSocketState> {
  late io.Socket _socket;
  final Ref ref;
  String? _currentOtherUserId;

  PrivateChatSocketNotifier(this.ref) : super(PrivateChatSocketState.initial());

  /// Connect to private chat websocket
  void connect({required int clubId}) {
    final token = ref.read(userManagerProvider).user?.accessToken ?? "";
    final url = "$kChatBaseURL/$clubId/private-chat";

    myPrint('Connecting to Private Chat: $url');
    myPrint('Authorization: Bearer $token');

    _socket = io.io(
      url,
      io.OptionBuilder()
          .setTransports([
            kIsWeb
                ? PrivateChatSocketConstants.transportPolling
                : PrivateChatSocketConstants.transportWebSocket
          ])
          .enableForceNew()
          .enableReconnection()
          .setExtraHeaders({
            PrivateChatSocketConstants.headerAuthorization: token,
            PrivateChatSocketConstants.headerAccessType:
                PrivateChatSocketConstants.accessTypeApp,
          })
          .build(),
    );

    _socket.onConnect((_) {
      myPrint('✅ Connected to Private Chat');
      state = state.copyWith(isConnected: true, clearError: true);
    });

    _socket.on(
        PrivateChatSocketConstants.eventConnected, _onPrivateChatConnected);
    _socket.on(PrivateChatSocketConstants.eventPrivateMessage,
        _onPrivateMessageReceived);
    _socket.on(PrivateChatSocketConstants.eventPrivateMessageSent,
        _onPrivateMessageSent);
    _socket.on(PrivateChatSocketConstants.eventConversationHistory,
        _onConversationHistory);
    _socket.on(PrivateChatSocketConstants.eventUserConversations,
        _onUserConversations);
    _socket.on(PrivateChatSocketConstants.eventMessagesMarkedAsRead,
        _onMessagesMarkedAsRead);
    _socket.on(PrivateChatSocketConstants.eventUnreadSenderCount,
        _onUnreadSenderCount);
    _socket.on(PrivateChatSocketConstants.eventError, _onError);

    _socket.onConnectError((error) {
      myPrint('❌ Connection Error: $error');
      state = state.copyWith(
        isConnected: false,
        error: '${PrivateChatSocketConstants.errorConnectionFailed}: $error',
      );
    });

    _socket.onDisconnect((_) {
      myPrint('🔌 Disconnected from Private Chat');
      state = state.copyWith(isConnected: false);
    });

    _socket.connect();
  }

  /// Event Listeners

  void _onPrivateChatConnected(dynamic data) {
    myPrint('----------------- Private Chat Connected --------------------');
    myPrint(data);
    myPrint('-------------------------------------');

    // Load conversations and unread count on connect
    getUserConversations();
    getUnreadSenderCount();
  }

  void _onPrivateMessageReceived(dynamic data) {
    myPrint(
        '----------------- New Private Message Received --------------------');
    myPrint(data);
    myPrint('-------------------------------------');

    try {
      final message = PrivateChatMessage.fromJson(data);

      // Only add to current conversation if it matches
      if (_currentOtherUserId != null &&
          (message.senderId == _currentOtherUserId ||
              message.receiverId == _currentOtherUserId)) {
        state = state.copyWith(
          messages: [...state.messages, message],
        );

        // Auto mark as read if user is viewing this conversation
        if (message.senderId == _currentOtherUserId) {
          markAsRead(
            senderId: message.senderId ?? '',
          );
        }
      }

      // Update conversations list locally without server fetch
      _updateConversationsLocally(message);

      // Update unread count
      getUnreadSenderCount();
    } catch (e) {
      myPrint('Error parsing received message: $e');
      state = state.copyWith(
          error: PrivateChatSocketConstants.errorProcessMessageFailed);
    }
  }

  /// Update conversations list locally when a new message is received
  void _updateConversationsLocally(PrivateChatMessage message) {
    final userId = ref.read(userManagerProvider).user?.user?.id?.toString();
    if (userId == null) return;

    final conversations = [...state.conversations];
    final senderId = message.senderId;
    final receiverId = message.receiverId;

    // Determine the other user ID
    final otherUserId = senderId == userId ? receiverId : senderId;

    // Find existing conversation
    final existingIndex = conversations.indexWhere(
      (conv) => conv.otherUserId == otherUserId,
    );

    if (existingIndex != -1) {
      // Update existing conversation
      var conversation = conversations[existingIndex];

      // Increment unread count if message is from other user and not currently viewing
      int newUnreadCount = conversation.myUnreadCount ?? 0;
      if (senderId != userId && _currentOtherUserId != otherUserId) {
        newUnreadCount++;
      }

      // Update conversation with new message info
      conversation = conversation.copyWith(
        lastMessage: message.message,
        lastMessageAt: message.createdAt ?? DateTime.now().toIso8601String(),
        myUnreadCount: newUnreadCount,
      );

      // Remove from current position and add to top
      conversations.removeAt(existingIndex);
      conversations.insert(0, conversation);

      // Update state
      state = state.copyWith(conversations: conversations);
    } else {
      // New conversation - fetch full list from server
      getUserConversations();
    }
  }

  void _onPrivateMessageSent(dynamic data) {
    myPrint('----------------- Message Sent Confirmation --------------------');
    myPrint(data);
    myPrint('-------------------------------------');

    try {
      final message = PrivateChatMessage.fromJson(data);

      // Add to current conversation
      state = state.copyWith(
        messages: [...state.messages, message],
        clearError: true,
      );

      // Update conversations list locally without server fetch
      _updateConversationsLocally(message);
    } catch (e) {
      myPrint('Error parsing sent message: $e');
    }
  }

  void _onConversationHistory(dynamic data) {
    myPrint('----------------- Conversation History --------------------');
    myPrint(data);
    myPrint('-------------------------------------');

    try {
      final response = ConversationHistoryResponse.fromJson(data);

      if (response.messages != null) {
        // If loading more, append to existing messages, otherwise replace
        final isLoadingMore =
            state.isLoadingHistory && state.messages.isNotEmpty;
        final messages = isLoadingMore
            ? [...response.messages!, ...state.messages]
            : response.messages!;

        state = state.copyWith(
          messages: messages,
          hasMoreMessages: response.hasMore ?? false,
          isLoadingHistory: false,
          clearError: true,
        );

        // Mark messages as read when opening the conversation (only on initial load, not on load more)
        // Also verify we're still viewing this conversation
        if (_currentOtherUserId != null && !isLoadingMore && state.isConnected) {
          markAsRead(senderId: _currentOtherUserId!);
        }
      }
    } catch (e) {
      myPrint('Error parsing conversation history: $e');
      state = state.copyWith(
        error: PrivateChatSocketConstants.errorLoadHistoryFailed,
        isLoadingHistory: false,
      );
    }
  }

  void _onUserConversations(dynamic data) {
    myPrint('----------------- User Conversations --------------------');
    myPrint(data);
    myPrint('-------------------------------------');

    try {
      final response = UserConversationsResponse.fromJson(data);

      if (response.conversations != null) {
        // Enrich conversations with user info
        final userId = ref.read(userManagerProvider).user?.user?.id?.toString();
        final enrichedConversations = response.conversations!.map((conv) {
          final otherUserId = conv.participants?.firstWhere(
            (id) => id != userId,
            orElse: () => '',
          );
          final myUnreadCount =
              userId != null ? (conv.unreadCount?[userId] ?? 0) : 0;

          return conv.copyWith(
            otherUserId: otherUserId,
            myUnreadCount: myUnreadCount,
          );
        }).toList();

        // Sort by last message time (most recent first)
        enrichedConversations.sort((a, b) {
          final aTime = DateTime.tryParse(a.lastMessageAt ?? '');
          final bTime = DateTime.tryParse(b.lastMessageAt ?? '');
          if (aTime == null || bTime == null) return 0;
          return bTime.compareTo(aTime);
        });

        state = state.copyWith(
          conversations: enrichedConversations,
          isLoadingConversations: false,
          clearError: true,
        );
      }
    } catch (e) {
      myPrint('Error parsing user conversations: $e');
      state = state.copyWith(
        error: PrivateChatSocketConstants.errorLoadConversationsFailed,
        isLoadingConversations: false,
      );
    }
  }

  void _onMessagesMarkedAsRead(dynamic data) {
    myPrint('----------------- Messages Marked As Read --------------------');
    myPrint(data);
    myPrint('-------------------------------------');

    try {
      final response = MessagesMarkedAsReadResponse.fromJson(data);

      // Update local messages to mark as read
      final updatedMessages = state.messages.map((msg) {
        if (msg.conversationId == response.conversationId) {
          return msg.copyWith(
              isRead: true, readAt: DateTime.now().toIso8601String());
        }
        return msg;
      }).toList();

      // Update conversations list locally to reset unread count
      final conversations = [...state.conversations];

      // Try to find by conversation ID first, then by current other user ID
      int conversationIndex = conversations.indexWhere(
        (conv) => conv.id == response.conversationId,
      );

      // If not found by ID, try by current other user ID
      if (conversationIndex == -1 && _currentOtherUserId != null) {
        conversationIndex = conversations.indexWhere(
          (conv) => conv.otherUserId == _currentOtherUserId,
        );
      }

      if (conversationIndex != -1) {
        conversations[conversationIndex] = conversations[conversationIndex].copyWith(
          myUnreadCount: 0,
        );

        state = state.copyWith(
          messages: updatedMessages,
          conversations: conversations,
        );
      } else {
        state = state.copyWith(messages: updatedMessages);
      }

      // Update unread count
      getUnreadSenderCount();
    } catch (e) {
      myPrint('Error processing marked as read: $e');
    }
  }

  void _onUnreadSenderCount(dynamic data) {
    myPrint('----------------- Unread Sender Count --------------------');
    myPrint(data);
    myPrint('-------------------------------------');

    try {
      final unreadCount = data['unread_sender_count'] as int? ?? 0;
      state = state.copyWith(unreadSenderCount: unreadCount);
    } catch (e) {
      myPrint('Error parsing unread sender count: $e');
    }
  }

  void _onError(dynamic data) {
    myPrint('----------------- Socket Error --------------------');
    myPrint(data);
    myPrint('-------------------------------------');

    final errorMessage =
        data[PrivateChatSocketConstants.keyMessage]?.toString() ??
            'Unknown error';
    state = state.copyWith(error: errorMessage);
  }

  /// Emit Methods

  /// Send a message to another user
  bool sendMessage({required String receiverId, required String message}) {
    if (!state.isConnected) {
      state =
          state.copyWith(error: PrivateChatSocketConstants.errorNotConnected);
      return false;
    }

    if (message.trim().isEmpty) {
      return false;
    }

    try {
      _socket.emit(PrivateChatSocketConstants.emitPrivateMessage, {
        PrivateChatSocketConstants.keyReceiverId: receiverId,
        PrivateChatSocketConstants.keyMessage: message.trim(),
      });
      return true;
    } catch (e) {
      myPrint('Error sending message: $e');
      state = state.copyWith(
          error: PrivateChatSocketConstants.errorSendMessageFailed);
      return false;
    }
  }

  /// Mark messages as read in a conversation
  void markAsRead({
    required String senderId,
  }) {
    myPrint("--------- Mark As Read $senderId -----------");
    if (!state.isConnected || senderId.isEmpty || !mounted) return;

    try {
      _socket.emit(PrivateChatSocketConstants.emitMarkAsRead, {
        PrivateChatSocketConstants.keySenderId: senderId,
      });
    } catch (e) {
      myPrint('Error marking as read: $e');
    }
  }

  /// Get conversation history with pagination
  void getConversationHistory({
    required String otherUserId,
    int? limit,
    int? skip,
  }) {
    if (!state.isConnected) {
      state =
          state.copyWith(error: PrivateChatSocketConstants.errorNotConnected);
      return;
    }

    _currentOtherUserId = otherUserId;

    final actualLimit = limit ?? PrivateChatSocketConstants.defaultMessageLimit;
    final actualSkip = skip ?? PrivateChatSocketConstants.defaultSkip;

    // Set loading state for both initial load and pagination
    state = state.copyWith(isLoadingHistory: true);

    try {
      _socket.emit(PrivateChatSocketConstants.emitGetConversationHistory, {
        PrivateChatSocketConstants.keyOtherUserId: otherUserId,
        PrivateChatSocketConstants.keyLimit: actualLimit,
        PrivateChatSocketConstants.keySkip: actualSkip,
      });
    } catch (e) {
      myPrint('Error getting conversation history: $e');
      state = state.copyWith(
        error: PrivateChatSocketConstants.errorLoadHistoryFailed,
        isLoadingHistory: false,
      );
    }
  }

  /// Get all user conversations (inbox)
  void getUserConversations() {
    if (!state.isConnected) {
      state =
          state.copyWith(error: PrivateChatSocketConstants.errorNotConnected);
      return;
    }

    // Set loading state
    state = state.copyWith(isLoadingConversations: true);

    try {
      _socket.emit(PrivateChatSocketConstants.emitGetUserConversations);
    } catch (e) {
      myPrint('Error getting conversations: $e');
      state = state.copyWith(
        error: PrivateChatSocketConstants.errorLoadConversationsFailed,
        isLoadingConversations: false,
      );
    }
  }

  /// Get unread sender count
  void getUnreadSenderCount() {
    if (!state.isConnected) return;

    try {
      _socket.emit(PrivateChatSocketConstants.emitGetUnreadSenderCount);
    } catch (e) {
      myPrint('Error getting unread sender count: $e');
    }
  }

  /// Clear current conversation messages
  void clearMessages() {
    _currentOtherUserId = null;
    state = state.copyWith(
      messages: [],
      hasMoreMessages: false,
      clearError: true,
    );
  }

  /// Disconnect and cleanup
  void disconnect() {
    // Set disconnected state first to prevent any pending operations
    state = state.copyWith(isConnected: false);
    _currentOtherUserId = null;

    try {
      _socket.off(PrivateChatSocketConstants.eventConnected);
      _socket.off(PrivateChatSocketConstants.eventPrivateMessage);
      _socket.off(PrivateChatSocketConstants.eventPrivateMessageSent);
      _socket.off(PrivateChatSocketConstants.eventConversationHistory);
      _socket.off(PrivateChatSocketConstants.eventUserConversations);
      _socket.off(PrivateChatSocketConstants.eventMessagesMarkedAsRead);
      _socket.off(PrivateChatSocketConstants.eventError);
      _socket.disconnect();
      _socket.dispose();
    } catch (e) {
      myPrint('Error disconnecting: $e');
    }

    // Reset state after cleanup
    state = PrivateChatSocketState.initial();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
