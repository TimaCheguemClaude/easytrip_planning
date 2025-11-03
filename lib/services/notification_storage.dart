import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final String type;
  final bool isRead;
  final Map<String, dynamic>? data;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.data,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'timestamp': timestamp.toIso8601String(),
    'type': type,
    'isRead': isRead,
    'data': data,
  };

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
    id: json['id'],
    title: json['title'],
    body: json['body'],
    timestamp: DateTime.parse(json['timestamp']),
    type: json['type'],
    isRead: json['isRead'] ?? false,
    data: json['data'],
  );
}

class NotificationStorage {
  static const String _key = 'notifications';
  
  static Future<List<NotificationItem>> getAllNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = prefs.getStringList(_key) ?? [];
    
    return notificationsJson
        .map((json) => NotificationItem.fromJson(jsonDecode(json)))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  static Future<void> saveNotification(NotificationItem notification) async {
    final notifications = await getAllNotifications();
    notifications.insert(0, notification);
    
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = notifications
        .map((n) => jsonEncode(n.toJson()))
        .toList();
    
    await prefs.setStringList(_key, notificationsJson);
  }

  static Future<void> markAsRead(String notificationId) async {
    final notifications = await getAllNotifications();
    final index = notifications.indexWhere((n) => n.id == notificationId);
    
    if (index != -1) {
      final updated = NotificationItem(
        id: notifications[index].id,
        title: notifications[index].title,
        body: notifications[index].body,
        timestamp: notifications[index].timestamp,
        type: notifications[index].type,
        isRead: true,
        data: notifications[index].data,
      );
      
      notifications[index] = updated;
      
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = notifications
          .map((n) => jsonEncode(n.toJson()))
          .toList();
      
      await prefs.setStringList(_key, notificationsJson);
    }
  }

  static Future<void> markAllAsRead() async {
    final notifications = await getAllNotifications();
    final updatedNotifications = notifications.map((n) => NotificationItem(
      id: n.id,
      title: n.title,
      body: n.body,
      timestamp: n.timestamp,
      type: n.type,
      isRead: true,
      data: n.data,
    )).toList();
    
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = updatedNotifications
        .map((n) => jsonEncode(n.toJson()))
        .toList();
    
    await prefs.setStringList(_key, notificationsJson);
  }

  static Future<int> getUnreadCount() async {
    final notifications = await getAllNotifications();
    return notifications.where((n) => !n.isRead).length;
  }

  static Future<void> clearAllNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
