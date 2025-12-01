import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:next_kick/data/api_services/app_api_services.dart';
import 'package:next_kick/data/local_storage/app_local_storage_service.dart';
import 'package:next_kick/features/notification/notification_list_view.dart';

class NotificationService {
  final AppApiClient _apiClient;
  final AppLocalStorageService _localStorage;
  final FlutterLocalNotificationsPlugin _localNotification;

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  NotificationService({
    required AppApiClient apiClient,
    required AppLocalStorageService localStorage,
  }) : _apiClient = apiClient,
       _localStorage = localStorage,
       _localNotification = FlutterLocalNotificationsPlugin();

  Future<void> initFCM(BuildContext context) async {
    await _initlocalNotifications();

    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);
    await _syncFcmToken();

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      final deviceId = await getDeviceId();
      await _apiClient.updateFcmToken(deviceId: deviceId, fcmToken: newToken);
      await _localStorage.saveFcmToken(newToken);
      debugPrint('FCM Token refreshed: $newToken');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Show the local notification for every message
      _showLocalNotification(message);

      // Custom logic for specific notifications
      if (message.notification?.title == "Registration Successful!" ||
          message.notification?.body?.contains("Registration Successful") ==
              true) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }

      debugPrint(
        '📩 Foreground message received: ${message.notification?.title}',
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
        '📬 App opened from notification: ${message.notification?.title}',
      );
      _handleNotificationTap(message);
    });

    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('🚀 App opened from terminated state via notification');
      _handleNotificationTap(initialMessage);
    }
  }

  Future<void> _initlocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('ic_notification');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotification.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    debugPrint('✅ Local notifications initialized');
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Ignore payload since backend doesn't provide it
    navigatorKey.currentState?.pushNamed(NotificationListView.routeName);
    debugPrint('🔔 Notification tapped, opened NotificationListView');
  }

  // void _navigateToNotificationDetail(String notificationId) {
  //   debugPrint(
  //     '🚀 Attempting navigation to /notifications with ID: $notificationId',
  //   );
  //   navigatorKey.currentState?.pushNamed(
  //     NotificationListView.routeName,
  //     arguments: notificationId,
  //   );

  //   //    final type = message.data['type'];
  //   // if (type == 'order') {
  //   //   navigatorKey.currentState?.pushNamed('/orders', arguments: notificationId);
  //   // } else if (type == 'drill') {
  //   //   navigatorKey.currentState?.pushNamed('/drills', arguments: notificationId);
  //   // }
  //   debugPrint('✅ Navigation command sent');
  // }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Notifications',
      channelDescription: 'Default notification channel',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
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

    final title = message.notification?.title ?? 'New Notification';
    final body = message.notification?.body ?? '';

    await _localNotification.show(
      message.hashCode,
      title,
      body,
      notificationDetails,
      payload: null,
    );
  }

  void _handleNotificationTap(RemoteMessage message) {
    // Always navigate to the notifications list view
    navigatorKey.currentState?.pushNamed(NotificationListView.routeName);
    debugPrint('✅ Navigated to NotificationListView on notification tap');
  }

  Future<void> _syncFcmToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final deviceId = await getDeviceId();
    if (fcmToken != null) {
      await _apiClient.updateFcmToken(deviceId: deviceId, fcmToken: fcmToken);

      await _localStorage.saveFcmToken(fcmToken);
      debugPrint('✅ Initial FCM token synced.');
    } else {
      debugPrint('⚠️ FCM token is null, cannot sync.');
    }
  }

  Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = await deviceInfo.androidInfo;
      return android.id;
    } else {
      final ios = await deviceInfo.iosInfo;
      return ios.identifierForVendor ?? '';
    }
  }
}
