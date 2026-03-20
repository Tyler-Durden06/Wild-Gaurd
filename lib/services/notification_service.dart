import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/alert.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // flutter_local_notifications does not support web
    if (kIsWeb) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    ThreatLevel threatLevel = ThreatLevel.low,
  }) async {
    // flutter_local_notifications does not support web
    if (kIsWeb) return;

    String channelId;
    String channelName;
    String channelDescription;
    Importance importance;
    Priority priority;

    switch (threatLevel) {
      case ThreatLevel.high:
        channelId = 'wild_guard_high_alerts';
        channelName = 'High Priority Alerts';
        channelDescription = 'Emergency wildlife intrusion alerts';
        importance = Importance.max;
        priority = Priority.high;
        break;
      case ThreatLevel.medium:
        channelId = 'wild_guard_medium_alerts';
        channelName = 'Medium Priority Alerts';
        channelDescription = 'Warning wildlife detection alerts';
        importance = Importance.high;
        priority = Priority.defaultPriority;
        break;
      case ThreatLevel.low:
        channelId = 'wild_guard_low_alerts';
        channelName = 'Low Priority Alerts';
        channelDescription = 'Standard wildlife activity alerts';
        importance = Importance.low;
        priority = Priority.low;
        break;
    }

    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: importance,
      priority: priority,
      ticker: 'ticker',
      playSound: true,
      enableVibration: true,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }
}
