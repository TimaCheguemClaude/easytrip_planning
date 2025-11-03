import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../data/model/booking.dart';
import 'notification_storage.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    log('Initializing notification service', name: 'NotificationService');

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for Android 13+
    await _requestPermissions();

    _initialized = true;
    log('Notification service initialized successfully', name: 'NotificationService');
  }

  static Future<void> _requestPermissions() async {
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      // Check if permissions are already granted before requesting
      final granted = await androidPlugin.areNotificationsEnabled();
      if (granted == false) {
        await androidPlugin.requestNotificationsPermission();
        await androidPlugin.requestExactAlarmsPermission();
      }
    }

    final iosPlugin = _notifications.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

    if (iosPlugin != null) {
      // Check if permissions are already granted before requesting
      final granted = await iosPlugin.checkPermissions();
      if (granted != null && !granted.isEnabled) {
        await iosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    }
  }

  static void _onNotificationTapped(NotificationResponse response) {
    log('Notification tapped: ${response.payload}', name: 'NotificationService');
    // Handle notification tap - could navigate to bookings screen
  }

  static Future<void> showBookingStatusNotification(Booking booking) async {
    try {
      log('Attempting to send notification for booking ${booking.bookingId} with status ${booking.status.name}', name: 'NotificationService');

      if (!_initialized) {
        log('Notification service not initialized, initializing now...', name: 'NotificationService');
        await initialize();
      }

      String title;
      String body;

      switch (booking.status) {
        case BookingStatus.approved:
          title = '✅ Booking Approved!';
          body = 'Your booking for "${booking.siteName}" has been approved. The site owner will contact you soon.';
          break;
        case BookingStatus.rejected:
          title = '❌ Booking Rejected';
          body = 'Unfortunately, your booking for "${booking.siteName}" has been rejected.';
          break;
        case BookingStatus.completed:
          title = '🎉 Trip Completed!';
          body = 'Hope you enjoyed your trip to "${booking.siteName}"! Please leave a review.';
          break;
        default:
          log('No notification needed for status: ${booking.status.name}', name: 'NotificationService');
          return; // Don't send notification for pending status
      }

      const androidDetails = AndroidNotificationDetails(
        'booking_updates',
        'Booking Updates',
        channelDescription: 'Notifications about booking status changes',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        playSound: true,
        enableVibration: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final notificationId = booking.id ?? DateTime.now().millisecondsSinceEpoch;

      log('Sending notification with ID: $notificationId, Title: $title', name: 'NotificationService');

      await _notifications.show(
        notificationId,
        title,
        body,
        notificationDetails,
        payload: 'booking_${booking.id}',
      );

      log('✅ Notification sent successfully for booking ${booking.bookingId}', name: 'NotificationService');

      // Save notification to storage
      await NotificationStorage.saveNotification(NotificationItem(
        id: 'booking_${booking.id}_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        body: body,
        timestamp: DateTime.now(),
        type: 'booking',
        data: {
          'bookingId': booking.bookingId,
          'siteName': booking.siteName,
          'status': booking.status.name,
        },
      ));

      // Also show a test notification to verify the system works
      await showTestNotification();

    } catch (e) {
      log('❌ Error sending notification: $e', name: 'NotificationService');
      // Try to show a simple notification as fallback
      await _showFallbackNotification(booking);
    }
  }

  static Future<void> showTestNotification() async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'test',
        'Test Notifications',
        channelDescription: 'Test notifications',
        importance: Importance.high,
        priority: Priority.high,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        999999,
        'EasyTrip Notification Test',
        'Notifications are working! 🎉',
        notificationDetails,
      );

      log('Test notification sent', name: 'NotificationService');
    } catch (e) {
      log('Error sending test notification: $e', name: 'NotificationService');
    }
  }

  static Future<void> _showFallbackNotification(Booking booking) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'fallback',
        'Booking Updates',
        importance: Importance.high,
        priority: Priority.high,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
      );

      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch,
        'Booking Update',
        'Your booking status has been updated. Check the app for details.',
        notificationDetails,
      );

      log('Fallback notification sent', name: 'NotificationService');
    } catch (e) {
      log('Error sending fallback notification: $e', name: 'NotificationService');
    }
  }

  static Future<void> showGeneralNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    const androidDetails = AndroidNotificationDetails(
      'general',
      'General Notifications',
      channelDescription: 'General app notifications',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const iosDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch,
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      // Save notification to storage
      await NotificationStorage.saveNotification(NotificationItem(
        id: 'general_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        body: body,
        timestamp: DateTime.now(),
        type: 'general',
        data: payload != null ? {'payload': payload} : null,
      ));

      log('General notification sent: $title', name: 'NotificationService');
    } catch (e) {
      log('Error sending general notification: $e', name: 'NotificationService');
    }
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    log('All notifications cancelled', name: 'NotificationService');
  }

  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
    log('Notification $id cancelled', name: 'NotificationService');
  }
}
