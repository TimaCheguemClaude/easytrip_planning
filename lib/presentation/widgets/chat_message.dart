class ChatConversation {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? lastMessage;

  ChatConversation({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
    };
  }

  factory ChatConversation.fromMap(Map<String, dynamic> map) {
    return ChatConversation(
      id: map['id'],
      title: map['title'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      lastMessage: map['lastMessage'],
    );
  }

  ChatConversation copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? lastMessage,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }
}

class ChatMessageModel {
  final String id;
  final String conversationId;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? imageUrl;
  final String? fileUrl;
  final String? fileName;
  final MessageType type;

  ChatMessageModel({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.imageUrl,
    this.fileUrl,
    this.fileName,
    this.type = MessageType.text,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversationId': conversationId,
      'content': content,
      'isUser': isUser ? 1 : 0,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'imageUrl': imageUrl,
      'fileUrl': fileUrl,
      'fileName': fileName,
      'type': type.index,
    };
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      id: map['id'],
      conversationId: map['conversationId'],
      content: map['content'],
      isUser: map['isUser'] == 1,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      imageUrl: map['imageUrl'],
      fileUrl: map['fileUrl'],
      fileName: map['fileName'],
      type: MessageType.values[map['type'] ?? 0],
    );
  }

  // Add these methods to your ChatMessageModel class in chat_message.dart
Map<String, dynamic> toJson() {
  return {
    'id': id,
    'conversationId': conversationId,
    'content': content,
    'isUser': isUser,
    'timestamp': timestamp.toIso8601String(),
    'imageUrl': imageUrl,
    'fileUrl': fileUrl,
    'fileName': fileName,
  };
}

factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
  return ChatMessageModel(
    id: json['id'],
    conversationId: json['conversationId'],
    content: json['content'],
    isUser: json['isUser'],
    timestamp: DateTime.parse(json['timestamp']),
    imageUrl: json['imageUrl'],
    fileUrl: json['fileUrl'],
    fileName: json['fileName'],
  );
}

  ChatMessageModel copyWith({
    String? id,
    String? conversationId,
    String? content,
    bool? isUser,
    DateTime? timestamp,
    String? imageUrl,
    String? fileUrl,
    String? fileName,
    MessageType? type,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      imageUrl: imageUrl ?? this.imageUrl,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      type: type ?? this.type,
    );
  }
}

enum MessageType {
  text,
  image,
  file,
  system,
}

class ChatResponse {
  final String content;
  final bool isError;
  final Map<String, dynamic>? metadata;

  ChatResponse({
    required this.content,
    this.isError = false,
    this.metadata,
  });
}