import 'package:hop/utils/custom_extensions.dart';

/// Model for other user in conversation
class OtherUser {
  String? id;
  String? firstName;
  String? lastName;
  String? profileImage;
  String? fullName;

  OtherUser({
    this.id,
    this.firstName,
    this.lastName,
    this.profileImage,
    this.fullName,
  });

  factory OtherUser.fromJson(Map<String, dynamic> json) {
    return OtherUser(
      id: json['id']?.toString(),
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      profileImage: json['profile_image']?.toString(),
      fullName: json['full_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'profile_image': profileImage,
      'full_name': fullName,
    };
  }
}

/// Model for private chat conversations (inbox)
class PrivateChatConversation {
  String? id;
  List<String>? participants;
  String? conversationId;
  String? lastMessage;
  String? lastMessageAt;
  Map<String, int>? unreadCount;
  String? createdAt;
  String? updatedAt;
  OtherUser? otherUser;

  // Additional fields for UI
  String? otherUserId;
  String? otherUserName;
  String? otherUserAvatar;
  int? myUnreadCount;

  String get userName {
    return '${(otherUser?.firstName ?? '').capitalizeFirst} ${(otherUser?.lastName ?? '').capitalizeFirst}';
  }


  PrivateChatConversation({
    this.id,
    this.participants,
    this.conversationId,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount,
    this.createdAt,
    this.updatedAt,
    this.otherUser,
    this.otherUserId,
    this.otherUserName,
    this.otherUserAvatar,
    this.myUnreadCount,
  });

  factory PrivateChatConversation.fromJson(Map<String, dynamic> json) {
    // Parse unread_count map
    Map<String, int>? unreadCountMap;
    if (json['unread_count'] != null) {
      unreadCountMap = {};
      (json['unread_count'] as Map<String, dynamic>).forEach((key, value) {
        unreadCountMap![key] = int.tryParse(value.toString()) ?? 0;
      });
    }

    // Parse other_user
    OtherUser? otherUser;
    if (json['other_user'] != null) {
      otherUser = OtherUser.fromJson(json['other_user'] as Map<String, dynamic>);
    }

    return PrivateChatConversation(
      id: json['_id']?.toString(),
      participants: json['participants'] != null
          ? List<String>.from(
              json['participants'].map((x) => x.toString()))
          : null,
      conversationId: json['conversation_id']?.toString(),
      lastMessage: json['last_message']?.toString(),
      lastMessageAt: json['last_message_at']?.toString(),
      unreadCount: unreadCountMap,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      otherUser: otherUser,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'participants': participants,
      'conversation_id': conversationId,
      'last_message': lastMessage,
      'last_message_at': lastMessageAt,
      'unread_count': unreadCount,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'other_user': otherUser?.toJson(),
    };
  }

  PrivateChatConversation copyWith({
    String? id,
    List<String>? participants,
    String? conversationId,
    String? lastMessage,
    String? lastMessageAt,
    Map<String, int>? unreadCount,
    String? createdAt,
    String? updatedAt,
    OtherUser? otherUser,
    String? otherUserId,
    String? otherUserName,
    String? otherUserAvatar,
    int? myUnreadCount,
  }) {
    return PrivateChatConversation(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      conversationId: conversationId ?? this.conversationId,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      otherUser: otherUser ?? this.otherUser,
      otherUserId: otherUserId ?? this.otherUserId,
      otherUserName: otherUserName ?? this.otherUserName,
      otherUserAvatar: otherUserAvatar ?? this.otherUserAvatar,
      myUnreadCount: myUnreadCount ?? this.myUnreadCount,
    );
  }
}

/// Response model for user conversations list
class UserConversationsResponse {
  List<PrivateChatConversation>? conversations;

  UserConversationsResponse({this.conversations});

  factory UserConversationsResponse.fromJson(Map<String, dynamic> json) {
    return UserConversationsResponse(
      conversations: json['conversations'] != null
          ? List<PrivateChatConversation>.from(
              json['conversations'].map((x) => PrivateChatConversation.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversations': conversations?.map((x) => x.toJson()).toList(),
    };
  }
}
