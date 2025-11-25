import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_fcm_topic_notifications/services/firebase_messaging_service.dart';
import 'package:flutter_fcm_topic_notifications/services/local_notifications_service.dart';
import 'package:flutter_fcm_topic_notifications/pages/topic_notification_page.dart';
import 'package:flutter_fcm_topic_notifications/pages/token_notification_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final localNotificationsService = LocalNotificationsService.instance();
  await localNotificationsService.init();

  final firebaseMessagingService = FirebaseMessagingService.instance();
  await firebaseMessagingService.init(
    localNotificationsService: localNotificationsService,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FCM Notifications',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/topic',
      routes: {
        '/topic': (context) => const TopicNotificationPage(),
        '/token': (context) => const TokenNotificationPage(),
      },
    );
  }
}
