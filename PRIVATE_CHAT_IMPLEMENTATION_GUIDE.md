# Private Chat Implementation Guide

## Overview

This guide explains the one-to-one private chat feature implementation in the HOP Ireland Flutter app.

## Architecture

The implementation follows the existing app architecture:

```
lib/
├── models/
│   ├── private_chat_message_model.dart       # Message data models
│   ├── private_chat_conversation_model.dart  # Conversation data models
│   └── private_chat_history_model.dart       # History response models
│
├── managers/
│   └── private_chat_socket_manager/
│       ├── private_chat_socket_manager.dart  # Socket.IO connection & events
│       └── private_chat_socket_state.dart    # Riverpod state management
│
├── screens/
│   └── private_chat/
│       ├── private_chat_screen.dart          # 1-to-1 chat UI
│       └── private_chat_list_screen.dart     # Conversations inbox
│
└── routes/
    ├── app_routes.dart                        # Route definitions
    └── app_pages.dart                         # Route configurations
```

## Features Implemented

### 1. **Socket Manager** (`private_chat_socket_manager.dart`)
- Socket.IO connection to: `https://chat.bookandgo.app/websocket/club/{clubId}/private-chat`
- Auto-reconnection with proper error handling
- Event listeners for:
  - `privateChat:connected` - Connection confirmation
  - `privateMessage` - Receiving messages
  - `privateMessageSent` - Send confirmation
  - `conversationHistory` - Message history with pagination
  - `userConversations` - Inbox/conversations list
  - `messagesMarkedAsRead` - Read receipts
  - `error` - Error handling

### 2. **State Management** (Riverpod)
- `PrivateChatSocketState`:
  - `messages` - Current conversation messages
  - `conversations` - List of all conversations
  - `isConnected` - Connection status
  - `hasMoreMessages` - Pagination flag
  - `isLoadingHistory` - Loading state
  - `error` - Error messages

### 3. **Private Chat Screen** (`private_chat_screen.dart`)
- Real-time messaging UI
- Similar design to existing group chat
- Features:
  - Message bubbles (sent/received)
  - Timestamps
  - Read receipts (double checkmark for read)
  - Auto-scroll to bottom on new messages
  - Pagination (load more on scroll)
  - Auto-mark as read when viewing

### 4. **Conversations List** (`private_chat_list_screen.dart`)
- Inbox showing all conversations
- Features:
  - Sorted by most recent message
  - Unread count badges
  - Last message preview
  - Pull-to-refresh
  - Timestamps (Today, Yesterday, date)
  - Empty state UI

## Usage

### Navigate to Conversations List

```dart
// From any screen
ref.read(goRouterProvider).push(RouteNames.privateChatList);
```

### Navigate to Specific Chat

```dart
// Navigate to chat with a user
ref.read(goRouterProvider).push(
  RouteNames.privateChat,
  extra: {
    'otherUserId': '123',        // Required: User ID
    'otherUserName': 'John Doe', // Required: Display name
    'otherUserAvatar': null,     // Optional: Avatar URL
  },
);
```

### Send a Message

The socket manager handles this automatically when user sends a message via the UI.

```dart
// Programmatically send a message
ref.read(privateChatSocketProvider.notifier).sendMessage(
  receiverId: '123',
  message: 'Hello!',
);
```

### Get Conversations

```dart
// Automatically called on connection
// Can be manually refreshed:
ref.read(privateChatSocketProvider.notifier).getUserConversations();
```

## Socket Connection

### Initialization

The socket connects when navigating to `PrivateChatListScreen`:

```dart
final socketNotifier = ref.read(privateChatSocketProvider.notifier);
socketNotifier.connect(clubId: kClubID); // kClubID = 73 for HOP Ireland
```

### Cleanup

The socket automatically disconnects when:
- User closes the chat screen
- App is terminated
- Connection is lost (auto-reconnects)

### Manual Disconnect

```dart
ref.read(privateChatSocketProvider.notifier).disconnect();
```

## API Endpoints

### WebSocket URL
```
wss://chat.bookandgo.app/websocket/club/73/private-chat
```

### Authentication
All connections require JWT token in headers:
```dart
extraHeaders: {'authorization': 'Bearer $token'}
```

The token is automatically retrieved from `userManagerProvider.user.accessToken`.

## Events Reference

### Client → Server (Emit)

| Event | Payload | Description |
|-------|---------|-------------|
| `privateMessage` | `{receiver_id, message}` | Send a message |
| `markAsRead` | `{conversation_id}` | Mark messages as read |
| `getConversationHistory` | `{other_user_id, limit?, skip?}` | Get message history |
| `getUserConversations` | (empty) | Get all conversations |

### Server → Client (Listen)

| Event | Payload | Description |
|-------|---------|-------------|
| `privateChat:connected` | `{userId, userName}` | Connection confirmed |
| `privateMessage` | `{message object}` | New message received |
| `privateMessageSent` | `{message object}` | Message sent confirmation |
| `conversationHistory` | `{conversation_id, messages[], has_more}` | Message history |
| `userConversations` | `{conversations[]}` | All conversations |
| `messagesMarkedAsRead` | `{conversation_id}` | Read confirmation |
| `error` | `{message}` | Error occurred |

## Data Models

### PrivateChatMessage
```dart
{
  String? id;
  String? conversationId;
  String? senderId;
  String? receiverId;
  String? message;
  bool? isRead;
  String? readAt;
  String? createdAt;
}
```

### PrivateChatConversation
```dart
{
  String? id;
  List<String>? participants;
  String? conversationId;
  String? lastMessage;
  String? lastMessageAt;
  Map<String, int>? unreadCount;
  String? otherUserId;       // Computed
  String? otherUserName;     // Enriched
  int? myUnreadCount;        // Computed
}
```

## UI Customization

### Message Colors
- **Sent messages**: `AppColors.darkYellow`
- **Received messages**: `AppColors.white.withOpacity(0.95)`

### Text Styles
- **Header**: `AppTextStyles.qanelasMedium(fontSize: 22.sp)`
- **Message**: `AppTextStyles.qanelasRegular(fontSize: 16.sp)`
- **Username**: `AppTextStyles.qanelasMedium(fontSize: 14.sp)`
- **Timestamp**: `AppTextStyles.qanelasRegular(fontSize: 12.sp)`

## Pagination

Messages are loaded in batches of 50 (default).

### Load More Messages
Automatically triggered when user scrolls to top:
```dart
ref.read(privateChatSocketProvider.notifier).getConversationHistory(
  otherUserId: userId,
  limit: 50,
  skip: currentMessages.length, // Offset
);
```

## Error Handling

Errors are stored in state and displayed in UI:

```dart
if (chatState.error != null) {
  // Show error banner
}
```

Common errors:
- `"Not connected to chat"` - Socket disconnected
- `"receiver_id and message are required"` - Invalid payload
- `"Cannot send message to yourself"` - Self-messaging attempt
- `"Failed to send message"` - Server error

## Testing

### 1. Test Connection
```dart
// Check connection status
final state = ref.read(privateChatSocketProvider);
print('Connected: ${state.isConnected}');
```

### 2. Test Sending Message
Navigate to a chat and send a test message.

### 3. Test Receiving Message
Open chat in two different devices/accounts and send messages.

### 4. Test Pagination
Create 50+ messages and scroll to top to test loading.

### 5. Test Offline Behavior
- Disconnect internet
- Send messages (should queue)
- Reconnect (should auto-sync)

## Integration Points

### Add to Navigation Menu
To add a "Messages" button to your app:

```dart
IconButton(
  icon: Badge(
    label: Text('${unreadCount}'),
    isLabelVisible: unreadCount > 0,
    child: Icon(Icons.chat_bubble_outline),
  ),
  onPressed: () {
    ref.read(goRouterProvider).push(RouteNames.privateChatList);
  },
)
```

### Listen to Unread Count
```dart
final conversations = ref.watch(privateChatSocketProvider).conversations;
final totalUnread = conversations.fold<int>(
  0,
  (sum, conv) => sum + (conv.myUnreadCount ?? 0),
);
```

## Production Considerations

### 1. User Information Enrichment
Currently using basic user IDs. You should enrich with:
- User profile photos
- Full names
- Online status

Update in `_onUserConversations` method:
```dart
// TODO: Fetch user details from API and enrich conversation
final otherUserInfo = await fetchUserInfo(otherUserId);
return conv.copyWith(
  otherUserName: otherUserInfo.name,
  otherUserAvatar: otherUserInfo.avatar,
);
```

### 2. Push Notifications
For offline users, integrate with your push notification system.

### 3. Message Persistence
Messages are currently in-memory. For offline support:
- Cache messages locally (SQLite/Hive)
- Sync on reconnection

### 4. Typing Indicators
Add typing indicators if needed:
```dart
// Emit typing event
socket.emit('typing', {userId: myId});

// Listen to typing
socket.on('userTyping', (data) {
  // Show typing indicator
});
```

### 5. Media Support
Currently text-only. To add images/files:
- Upload media to storage
- Send URL in message
- Parse and display in UI

## Troubleshooting

### Socket Not Connecting
- Check JWT token validity
- Verify clubId is correct (73 for HOP Ireland)
- Check network connectivity
- Review console logs for errors

### Messages Not Appearing
- Verify socket is connected: `state.isConnected`
- Check if `otherUserId` matches expected format
- Review console for socket events

### Duplicate Messages
- Ensure you're not connecting multiple times
- Clear state when navigating away: `clearMessages()`

### Unread Count Not Updating
- Verify `markAsRead` is being called
- Check `getUserConversations` is refreshing after marking as read

## Code Quality

- ✅ Follows existing app architecture
- ✅ Uses Riverpod for state management
- ✅ Socket.IO for real-time communication
- ✅ Consistent UI/UX with existing chat
- ✅ Error handling and loading states
- ✅ Pagination support
- ✅ Type-safe models
- ✅ Clean code structure

## Next Steps

1. **User Enrichment**: Integrate with user API to get names/avatars
2. **Push Notifications**: Set up for offline messaging
3. **Search**: Add search functionality in conversations list
4. **Media Support**: Enable image/file sharing
5. **Blocking/Reporting**: Add user moderation features
6. **Message Deletion**: Allow users to delete messages
7. **Group Chat**: Extend to support group conversations

## Support

For API issues, refer to the main API documentation.
For UI/implementation questions, review the source code with detailed comments.

---

**Implementation Date**: November 2024
**Framework**: Flutter 3.x with Riverpod 3.0.0-dev
**Socket.IO Client**: socket_io_client package
