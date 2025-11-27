# Private Chat Constants Guide

## Overview

All socket event names, payload keys, and configuration values are now centralized in constants to make the code more maintainable and prevent typos.

## Constants File

**Location**: `lib/managers/private_chat_socket_manager/private_chat_socket_constants.dart`

## Constants Reference

### Socket Event Names - Server to Client (Listen)

These are events the client listens for from the server:

| Constant | Value | Description |
|----------|-------|-------------|
| `eventConnected` | `'privateChat:connected'` | Connection confirmation |
| `eventPrivateMessage` | `'privateMessage'` | New message received |
| `eventPrivateMessageSent` | `'privateMessageSent'` | Message sent confirmation |
| `eventConversationHistory` | `'conversationHistory'` | Message history response |
| `eventUserConversations` | `'userConversations'` | Conversations list response |
| `eventMessagesMarkedAsRead` | `'messagesMarkedAsRead'` | Read receipt confirmation |
| `eventError` | `'error'` | Error event |
| `eventConnect` | `'connect'` | Socket connected |
| `eventConnectError` | `'connect_error'` | Connection error |
| `eventDisconnect` | `'disconnect'` | Socket disconnected |

### Socket Event Names - Client to Server (Emit)

These are events the client emits to the server:

| Constant | Value | Description |
|----------|-------|-------------|
| `emitPrivateMessage` | `'privateMessage'` | Send a message |
| `emitMarkAsRead` | `'markAsRead'` | Mark messages as read |
| `emitGetConversationHistory` | `'getConversationHistory'` | Request message history |
| `emitGetUserConversations` | `'getUserConversations'` | Request conversations list |

### Payload Keys

Keys used in JSON payloads:

| Constant | Value | Used In |
|----------|-------|---------|
| `keyReceiverId` | `'receiver_id'` | Send message |
| `keySenderId` | `'sender_id'` | Message data |
| `keyMessage` | `'message'` | Send/receive message |
| `keyConversationId` | `'conversation_id'` | Mark as read, messages |
| `keyOtherUserId` | `'other_user_id'` | Get history |
| `keyLimit` | `'limit'` | Pagination |
| `keySkip` | `'skip'` | Pagination |
| `keyUserId` | `'userId'` | Connection event |
| `keyUserName` | `'userName'` | Connection event |
| `keyMessages` | `'messages'` | History response |
| `keyHasMore` | `'has_more'` | Pagination flag |
| `keyConversations` | `'conversations'` | Conversations response |

### Socket Connection Headers

Headers used in WebSocket connection:

| Constant | Value | Description |
|----------|-------|-------------|
| `headerAuthorization` | `'Authorization'` | Auth header name |
| `headerAccessType` | `'AccessType'` | Access type header name |

### Socket Connection Values

Values used in connection configuration:

| Constant | Value | Description |
|----------|-------|-------------|
| `accessTypeApp` | `'app'` | Access type value for mobile app |
| `authorizationPrefix` | `'Bearer '` | Prefix for auth token (unused currently) |
| `transportWebSocket` | `'websocket'` | WebSocket transport type |
| `transportPolling` | `'polling'` | Polling transport type |

### Default Values

Default values for requests:

| Constant | Value | Description |
|----------|-------|-------------|
| `defaultMessageLimit` | `50` | Default messages per page |
| `defaultSkip` | `0` | Default pagination offset |

### Error Messages

Standardized error messages:

| Constant | Value | When Used |
|----------|-------|-----------|
| `errorNotConnected` | `'Not connected to chat'` | Action attempted while disconnected |
| `errorConnectionFailed` | `'Connection failed'` | Socket connection fails |
| `errorSendMessageFailed` | `'Failed to send message'` | Message send fails |
| `errorLoadHistoryFailed` | `'Failed to load history'` | History load fails |
| `errorLoadConversationsFailed` | `'Failed to load conversations'` | Conversations load fails |
| `errorProcessMessageFailed` | `'Failed to process message'` | Message parsing fails |

## Usage Examples

### Using Event Constants

**Before:**
```dart
_socket.on('privateMessage', _onPrivateMessageReceived);
```

**After:**
```dart
_socket.on(PrivateChatSocketConstants.eventPrivateMessage, _onPrivateMessageReceived);
```

### Using Emit Constants

**Before:**
```dart
_socket.emit('privateMessage', {
  'receiver_id': receiverId,
  'message': message,
});
```

**After:**
```dart
_socket.emit(PrivateChatSocketConstants.emitPrivateMessage, {
  PrivateChatSocketConstants.keyReceiverId: receiverId,
  PrivateChatSocketConstants.keyMessage: message,
});
```

### Using Header Constants

**Before:**
```dart
.setExtraHeaders({
  'Authorization': token,
  'AccessType': 'app',
})
```

**After:**
```dart
.setExtraHeaders({
  PrivateChatSocketConstants.headerAuthorization: token,
  PrivateChatSocketConstants.headerAccessType: PrivateChatSocketConstants.accessTypeApp,
})
```

### Using Transport Constants

**Before:**
```dart
.setTransports([kIsWeb ? 'polling' : 'websocket'])
```

**After:**
```dart
.setTransports([
  kIsWeb
    ? PrivateChatSocketConstants.transportPolling
    : PrivateChatSocketConstants.transportWebSocket
])
```

### Using Default Values

**Before:**
```dart
void getConversationHistory({
  required String otherUserId,
  int limit = 50,
  int skip = 0,
})
```

**After:**
```dart
void getConversationHistory({
  required String otherUserId,
  int? limit,
  int? skip,
}) {
  final actualLimit = limit ?? PrivateChatSocketConstants.defaultMessageLimit;
  final actualSkip = skip ?? PrivateChatSocketConstants.defaultSkip;
  // ...
}
```

### Using Error Messages

**Before:**
```dart
if (!state.isConnected) {
  state = state.copyWith(error: 'Not connected to chat');
  return;
}
```

**After:**
```dart
if (!state.isConnected) {
  state = state.copyWith(error: PrivateChatSocketConstants.errorNotConnected);
  return;
}
```

## Benefits

### 1. **Type Safety**
- No typos in event names or keys
- IDE autocomplete support
- Compile-time error checking

### 2. **Maintainability**
- Single source of truth
- Easy to update all occurrences
- Clear documentation of all values

### 3. **Consistency**
- Same values used everywhere
- No duplicate string literals
- Easier code reviews

### 4. **Testability**
- Can mock constants if needed
- Easy to verify correct values used
- Better test coverage

### 5. **Documentation**
- Self-documenting code
- Clear naming conventions
- Easy to understand intent

## Importing Constants

To use the constants in your code:

```dart
import 'package:hop/managers/private_chat_socket_manager/private_chat_socket_constants.dart';
```

Or with a shorter alias:

```dart
import 'package:hop/managers/private_chat_socket_manager/private_chat_socket_constants.dart' as ChatConst;

// Usage:
_socket.emit(ChatConst.PrivateChatSocketConstants.emitPrivateMessage, {...});
```

## Adding New Constants

If you need to add new socket events or keys:

1. Open `private_chat_socket_constants.dart`
2. Add the constant in the appropriate section
3. Use descriptive naming:
   - Events: `event` prefix for listening, `emit` prefix for emitting
   - Keys: `key` prefix
   - Headers: `header` prefix
   - Errors: `error` prefix

Example:
```dart
// New event to listen for
static const String eventTyping = 'userTyping';

// New event to emit
static const String emitTyping = 'typing';

// New payload key
static const String keyIsTyping = 'is_typing';
```

## Migration Notes

All hard-coded strings in the socket manager have been replaced with constants:

- ✅ Event names
- ✅ Payload keys
- ✅ Header names and values
- ✅ Transport types
- ✅ Error messages
- ✅ Default values

## Testing

When writing tests, you can:

1. Import the constants file
2. Use the same constants in test assertions
3. Verify correct event names are used

Example test:
```dart
import 'package:hop/managers/private_chat_socket_manager/private_chat_socket_constants.dart';

test('should emit correct event name for sending message', () {
  // Arrange
  final socket = MockSocket();

  // Act
  notifier.sendMessage(receiverId: '123', message: 'Hello');

  // Assert
  verify(socket.emit(
    PrivateChatSocketConstants.emitPrivateMessage,
    any,
  )).called(1);
});
```

## Summary

All socket-related string literals are now centralized in `PrivateChatSocketConstants`, making the codebase:
- More maintainable
- Less error-prone
- Easier to refactor
- Better documented
- More testable

No functional changes were made - only refactoring to use constants instead of hard-coded strings.

---

**Updated**: November 12, 2025
**File**: `lib/managers/private_chat_socket_manager/private_chat_socket_constants.dart`
