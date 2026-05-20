import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static const double budgetThreshold = 1000.0;

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(settings: settings);
  }

  Future<void> showBudgetAlert(double totalExpense) async {
    const androidDetails = AndroidNotificationDetails(
      'budget_alert_channel',
      'Budget Alerts',
      channelDescription: 'Notifies when monthly budget limit is exceeded',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      id: 1001,
      title: '⚠️ Budget Limit Exceeded!',
      body:
      'Your monthly expenses (₹${totalExpense.toStringAsFixed(0)}) have crossed ₹${budgetThreshold.toStringAsFixed(0)}',
      notificationDetails: details,
    );
  }
}

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationService {
//   static const _budgetThreshold = 1000.0; // ₹1000
//   final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
//
//   Future<void> init() async {
//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const ios = DarwinInitializationSettings();
//     await _plugin.initialize(settings: const InitializationSettings(android: android, iOS: ios));
//   }
//
//   Future<void> showBudgetAlert() async {
//     const details = NotificationDetails(
//       android: AndroidNotificationDetails(
//         'budget_alerts', 'Budget Alerts',
//         importance: Importance.high,
//         priority: Priority.high,
//       ),
//       iOS: DarwinNotificationDetails(),
//     );
//     await _plugin.show(
//       0,
//       '⚠️ Budget limit exceeded',
//       'Your monthly expenses have crossed ₹${_budgetThreshold.toStringAsFixed(0)}',
//       notificationDetails: details, id: null,
//     );
//   }
// }