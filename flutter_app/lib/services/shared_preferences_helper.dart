import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _notificationEnabledKey = 'notification_enabled';

  static Future<bool> isNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationEnabledKey) ?? false;
  }

  static Future<void> setNotificationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationEnabledKey, enabled);
  }
}

