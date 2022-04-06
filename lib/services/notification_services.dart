import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../ui/theme.dart';
import '/models/task.dart';
import '/ui/pages/notification_screen.dart';

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String selectedNotificationPayload = '';

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  initializeNotification() async {
    tz.initializeTimeZones();
    _configureSelectNotificationSubject();
    await _configureLocalTimeZone();
    // await requestIOSPermissions(flutterLocalNotificationsPlugin);
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('a1024');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload!);
      },
    );
  }

  displayNotification({required String title, required String body}) async {
    debugPrint('doing test');
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high);
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  cancelNotification(Task task) async {
    flutterLocalNotificationsPlugin.cancel(task.id!);
    debugPrint("notification canceled");
  }
  cancelAllNotification() async {
    flutterLocalNotificationsPlugin.cancelAll();
    debugPrint("All notification canceled");
  }

  scheduledNotification(int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,
      task.title,
      task.note,
      //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      _nextInstanceOfTenAM(
          hour, minutes, task.remind!, task.repeat!, task.date!),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'your channel id', 'your channel name',
            channelDescription: 'your channel description'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '${task.title}|${task.note}|${task.startTime}|',
    );
  }

  tz.TZDateTime _nextInstanceOfTenAM(
      int hour, int minutes, int remind, String repeat, String date) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    var formatedDate = DateFormat.yMd().parse(date);
    tz.TZDateTime fd= tz.TZDateTime.from(formatedDate, tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, fd.year, fd.month, fd.day, hour, minutes);
    scheduledDate = afterDate(remind, scheduledDate);

    if (scheduledDate.isBefore(now)) {
      if (repeat == 'Daily') {
        scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
            (formatedDate.day) + 1, hour, minutes);
      }
      if (repeat == 'Weekly') {
        scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
            (formatedDate.day) + 1, hour, minutes);
      }
      if (repeat == 'Monthly') {
        scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
            (formatedDate.day) + 1, hour, minutes);
      }
      scheduledDate = afterDate(remind, scheduledDate);

    }
    debugPrint("scheduleDate$scheduledDate");
    return scheduledDate;
  }

  tz.TZDateTime afterDate(int remind, tz.TZDateTime scheduledDate) {
    if (remind == 5) {
      scheduledDate = scheduledDate.add(const Duration(minutes: 5));
    }
    if (remind == 10) {
      scheduledDate = scheduledDate.add(const Duration(minutes: 10));
    }
    if (remind == 15) {
      scheduledDate = scheduledDate.add(const Duration(minutes: 15));
    }
    if (remind == 20) {
      scheduledDate = scheduledDate.add(const Duration(minutes: 20));
    }
    return scheduledDate;
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

/*   Future selectNotification(String? payload) async {
    if (payload != null) {
      //selectedNotificationPayload = "The best";
      selectNotificationSubject.add(payload);
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
    Get.to(() => SecondScreen(selectedNotificationPayload));
  } */

//Older IOS
  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    /* showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Title'),
        content: const Text('Body'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Container(color: Colors.white),
                ),
              );
            },
          )
        ],
      ),
    );
 */
    Get.dialog(Text(body!));
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      debugPrint('My payload is ' + payload);
      await Get.to(() => NotificationScreen(payLoad: payload));
    });
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
// import 'package:get/get.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import '../models/task.dart';
// import '../ui/pages/notification_screen.dart';
//
// class NotifyHelper {
//   //اوبجيكت عادي منها علشان نعرف نستخدم اللي جواها
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   String selectedNotificationPayload = '';
//   final BehaviorSubject<String> selectNotificationSubject =
//   BehaviorSubject<String>();
//   initializeNotification() async {
//     tz.initializeTimeZones();
//     _configureSelectNotificationSubject();
//     await _configureLocalTimeZone();
//     // await requestIOSPermissions(flutterLocalNotificationsPlugin);
//     final IOSInitializationSettings initializationSettingsIOS =
//     IOSInitializationSettings(
//       requestSoundPermission: false,
//       requestBadgePermission: false,
//       requestAlertPermission: false,
//       onDidReceiveLocalNotification: onDidReceiveLocalNotification,
//     );
//
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('a1024');
//
//     final InitializationSettings initializationSettings =
//     InitializationSettings(
//       iOS: initializationSettingsIOS,
//       android: initializationSettingsAndroid,
//     );
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onSelectNotification: (String? payload) async {
//         if (payload != null) {
//           debugPrint('notification payload: ' + payload);
//         }
//         selectNotificationSubject.add(payload!);
//       },
//     );
//   }
//  /* initializeNotification() async {
//     tz.initializeTimeZones();
//     // tz.setLocalLocation(tz.getLocation(timeZoneName));
//     AndroidInitializationSettings initializationSettingsAndroid =
//         const AndroidInitializationSettings('a1024');
//     const IOSInitializationSettings initializationSettingsIOS =
//         IOSInitializationSettings(
//       //النسخ الحديثه من الايفون
//       requestSoundPermission: false,
//       requestBadgePermission: false,
//       requestAlertPermission: false,
//       //النسخ القديمه
//       //onDidReceiveLocalNotification: onDidReceiveLocalNotification,
//     );
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: (String? payload) async {
//       selectNotification(payload!);
//     });
//   }*/
//
//   void selectNotification(String payload) async {
//     if (payload != null) {
//       debugPrint('notification payload: $payload');
//     }
//     await Get.to(NotificationScreen(
//       payLoad: payload,
//     ));
//   }
//
//   displayNotification({required String title, required String body}) async {
//     AndroidNotificationDetails androidPlatformChannelSpecifics =
//         const AndroidNotificationDetails(
//       'your channel id',
//       'your channel name',
//       channelDescription: 'your channel description',
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker',
//       showWhen: false,
//     );
//
//     const IOSNotificationDetails iOSPlatformChannelSpecifics =
//         IOSNotificationDetails();
//
//     NotificationDetails platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics,
//         iOS: const IOSNotificationDetails());
//
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: ' Default_Sound',
//       /*payload – the data that we want to pass with this notification so that it can be used later
//        when the notification is tapped on and our application opens up again*/
//     );
//   }
//
//   scheduledNotification(int hour, int minutes, Task task) async {
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//         task.id!,
//         task.title,
//         task.note,
//         // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
//         _nextInstanceOfTenAM(hour, minutes),
//         const NotificationDetails(
//             android: AndroidNotificationDetails(
//                 'your channel id', 'your channel name',
//                 channelDescription: 'your channel description')),
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         matchDateTimeComponents: DateTimeComponents.time,
//         payload: '${task.title}|${task.note}|${task.startTime}');
//   }
//
//   tz.TZDateTime _nextInstanceOfTenAM(hour, minutes) {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduledDate =
//         tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//     return scheduledDate;
//   }
//
//   void requestIOSPermissions(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
//
//   Future<void> _configureLocalTimeZone() async {
//     tz.initializeTimeZones();
//     final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
//     tz.setLocalLocation(tz.getLocation(timeZoneName));
//   }
//   Future onDidReceiveLocalNotification(
//       int id, String? title, String? body, String? payload) async {
//     // display a dialog with the notification details, tap ok to go to another page
//     /* showDialog(
//       context: context,
//       builder: (BuildContext context) => CupertinoAlertDialog(
//         title: const Text('Title'),
//         content: const Text('Body'),
//         actions: [
//           CupertinoDialogAction(
//             isDefaultAction: true,
//             child: const Text('Ok'),
//             onPressed: () async {
//               Navigator.of(context, rootNavigator: true).pop();
//               await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => Container(color: Colors.white),
//                 ),
//               );
//             },
//           )
//         ],
//       ),
//     );
//  */
//     Get.dialog( Text(body!));
//   }
//   void _configureSelectNotificationSubject() {
//     selectNotificationSubject.stream.listen((String payload) async {
//       debugPrint('My payload is ' + payload);
//       await Get.to(() => NotificationScreen(payLoad: payload));
//     });
//   }
//
// }
//
// //النسخ القديمه
// // void onDidReceiveLocalNotification(
// //     int id, String? title, String? body, String? payload) async {
// //   // display a dialog with the notification details, tap ok to go to another page
// //   Get.dialog(Text(body));
// // }
// /*to identify ios details
// const IOSNotificationDetails iOSPlatformChannelSpecifics =
//     IOSNotificationDetails(
//         presentAlert: bool?,  // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
//         presentBadge: bool?,  // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
//         presentSound: bool?,  // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
//         sound: String?,  // Specifics the file path to play (only from iOS 10 onwards)
//         badgeNumber: int?, // The application's icon badge number
//         attachments: List<IOSNotificationAttachment>?, (only from iOS 10 onwards)
//         subtitle: String?, //Secondary description  (only from iOS 10 onwards)
//         threadIdentifier: String? (only from iOS 10 onwards)
//    );*/
// /*The parameters here are more self explanatory, but we will go over them anyway:
// id – the identifier of the notification. Each notification must have a unique identifier
// title – the title of the notification
// body – what we want to display as the main message of our notification
// notificationDetails – the notification details object we discussed above
// payload – the data that we want to pass with this notification so
// that it can be used later when the notification is tapped on and our application opens up again
// */
