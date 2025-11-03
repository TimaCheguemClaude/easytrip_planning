import 'package:flutter/material.dart';
import '../../services/notification_storage.dart';
import 'package:easytrip/l10n/app_localizations.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationItem> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final loadedNotifications = await NotificationStorage.getAllNotifications();
    setState(() {
      notifications = loadedNotifications;
      isLoading = false;
    });
  }

  Future<void> _markAsRead(NotificationItem notification) async {
    await NotificationStorage.markAsRead(notification.id);
    await _loadNotifications();
  }

  Future<void> _markAllAsRead() async {
    await NotificationStorage.markAllAsRead();
    await _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications),
        actions: [
          if (notifications.any((n) => !n.isRead))
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(l10n.markAllRead),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(l10n.noNotificationsYet, style: const TextStyle(fontSize: 18, color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Card(
                      color: notification.isRead ? null : Theme.of(context).primaryColor.withOpacity(0.1),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getNotificationColor(notification.type),
                          child: Icon(_getNotificationIcon(notification.type), color: Colors.white),
                        ),
                        title: Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(notification.body),
                            const SizedBox(height: 4),
                            Text(
                              _formatTimestamp(notification.timestamp),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        trailing: notification.isRead
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.mark_email_read),
                                onPressed: () => _markAsRead(notification),
                              ),
                        onTap: () => _markAsRead(notification),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemCount: notifications.length,
                ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'booking':
        return Colors.blue;
      case 'general':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'booking':
        return Icons.event_available;
      case 'general':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? l10n.day : l10n.days} ${l10n.ago}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? l10n.hour : l10n.hours} ${l10n.ago}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? l10n.minute : l10n.minutes} ${l10n.ago}';
    } else {
      return l10n.justNow;
    }
  }
}




