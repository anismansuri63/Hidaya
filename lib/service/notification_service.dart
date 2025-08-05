// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz_data;
//
// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   static Future<void> init() async {
//     tz_data.initializeTimeZones();
//
//     const AndroidInitializationSettings androidSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings settings =
//     InitializationSettings(android: androidSettings);
//
//     await _notificationsPlugin.initialize(settings);
//   }
//
//   static Future<void> scheduleDailyReminder() async {
//     await _notificationsPlugin.zonedSchedule(
//       0,
//       'Quran Reminder',
//       'Take a moment to reflect on today\'s ayah',
//       _nextInstanceOfTime(9, 0), // 9 AM daily
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'daily_ayah_reminder',
//           'Daily Quran Reminder',
//           importance: Importance.high,
//           priority: Priority.high,
//         ),
//       ),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }
//
//   static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
//     final now = tz.TZDateTime.now(tz.local);
//     var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
//
//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//
//     return scheduledDate;
//   }
//   Future<void> _requestNotificationPermission() async {
//     final status = await _notificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestPermission();
//
//     if (status != true) {
//      // showDialog(/* permission explanation */);
//     }
//   }
// }
