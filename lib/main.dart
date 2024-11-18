import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'app/data/enums.dart';
import 'app/data/models/menu_info.dart';
import 'app/modules/views/homepage.dart';
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  var initializationSettingsAndroid = AndroidInitializationSettings('alarm_clock');
  var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {}
  );
  var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (NotificationResponse? payload) async {
    if (payload != null) {
      debugPrint('notification payload: ${payload.payload}');
    }
  });
  runApp(
    MaterialApp(
      title: 'Alarm Clock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider<MenuInfo>(
        create: (context) => MenuInfo(MenuType.clock),
        child: HomePage(),
      ),
    ),
  );
}
