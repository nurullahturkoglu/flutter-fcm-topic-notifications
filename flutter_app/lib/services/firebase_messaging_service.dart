import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_fcm_topic_notifications/services/local_notifications_service.dart';
import 'package:flutter_fcm_topic_notifications/services/shared_preferences_helper.dart';

class FirebaseMessagingService {
  // Private constructor for singleton pattern
  FirebaseMessagingService._internal();

  // Singleton instance
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();

  // Factory constructor to provide singleton instance
  factory FirebaseMessagingService.instance() => _instance;

  // Reference to local notifications service for displaying notifications
  LocalNotificationsService? _localNotificationsService;

  static const String everyoneTopic = 'everyone';

  /// Initialize Firebase Messaging and sets up all message listeners
  Future<void> init(
      {required LocalNotificationsService localNotificationsService}) async {
    // Init local notifications service
    _localNotificationsService = localNotificationsService;

    // Request user permission for notifications
    _requestPermission();

    // subscribe to general topic if notification is enabled
    await _initializeNotificationSubscription();

    // Register handler for background messages (app terminated)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listen for messages when the app is in foreground
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Listen for notification taps when the app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Check for initial message that opened the app from terminated state
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _onMessageOpenedApp(initialMessage);
    }
  }

  Future<void> _initializeNotificationSubscription() async {
    // subscribe to general topic if notification is enabled
    final isNotificationEnabled =
        await SharedPreferencesHelper.isNotificationEnabled();
    if (isNotificationEnabled) {
      await FirebaseMessaging.instance.subscribeToTopic(everyoneTopic);
    }
  }

  Future<void> subscribeToGeneralTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic(everyoneTopic);
    await SharedPreferencesHelper.setNotificationEnabled(true);
  }

  Future<void> unsubscribeFromGeneralTopic() async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(everyoneTopic);
    await SharedPreferencesHelper.setNotificationEnabled(false);
  }

  Future<void> _requestPermission() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _onForegroundMessage(RemoteMessage message) {
    final notificationData = message.notification;
    if (notificationData != null) {
      _localNotificationsService?.showNotification(notificationData.title,
          notificationData.body, message.data.toString());
    }
  }

  Future<String?> getFCMToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    // Handle notification tap when app is opened from background
    // You can navigate to specific screens based on message data here
  }
}

/// Background message handler (must be top-level function or static)
/// Handles messages when the app is fully terminated
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages here
  // Note: This function must be top-level or static
  // You can initialize Firebase and show local notifications here if needed
}
