import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService{
 NotificationService();

 final _localNotificationService = FlutterLocalNotificationsPlugin();

 Future<void> initialize() async{
  tz.initializeTimeZones();
  const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@drawable/app_icon');

    DarwinInitializationSettings iosInitializationSettings = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification: _onDidRecieveLocalNotification,
  );

  final InitializationSettings settings = InitializationSettings(
    android: androidInitializationSettings, 
    iOS: iosInitializationSettings,
  );
  await _localNotificationService.initialize(
    settings,
    onDidReceiveNotificationResponse: onSelectNotification,
  );
 }

 Future<NotificationDetails> _notificationDetails() async{
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    'channelId', 
    'channelName',
    channelDescription: 'description',
    importance: Importance.max,
    priority: Priority.max,
    playSound: true,
  );

  const DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails();

  return const NotificationDetails(
    android: androidNotificationDetails, 
    iOS:iosNotificationDetails);
 }

 Future<void> showNotification({required int id, required String title, required String body}) async {
  final details = await _notificationDetails();
  await _localNotificationService.show(id, title, body, details);
 }

  Future<void> showScheduledNotification({required int id, required String title, required String body, required int seconds}) async {
  final details = await _notificationDetails();
  await _localNotificationService.zonedSchedule(
    id, 
    title, 
    body, 
    tz.TZDateTime.from(DateTime.now().add(Duration(seconds: seconds)), tz.local,),
    details,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
 }

  void _onDidRecieveLocalNotification(int id, String? title, String? body, String? payload){
    print('id $id');
  }

  void onSelectNotification(NotificationResponse details) {
    print('payload $details');
  }
}