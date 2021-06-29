import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotifyManager {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var initSetting;

  BehaviorSubject<ReceiveNotification> get didReceiveLocalNotificationSubject =>
      BehaviorSubject<ReceiveNotification>();

  LocalNotifyManager.init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      requestIOSPermission();
    }
    initializePlatform();
    tz.initializeTimeZones();
  }

  requestIOSPermission() {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>().requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void initializePlatform() {
    var initSettingAndroid =
    AndroidInitializationSettings("@mipmap/ic_launcher");
    var initSettingIOS = IOSInitializationSettings(
        requestSoundPermission: true,
        defaultPresentBadge: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          ReceiveNotification notification = ReceiveNotification(
            id: id, title: title, body: body, payload: payload,);
          didReceiveLocalNotificationSubject.add(notification);
        }
    );
    initSetting = InitializationSettings(
        android: initSettingAndroid, iOS: initSettingIOS);
  }

  setOnNotificationReceive(Function onNotificationReceive) {
    didReceiveLocalNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: (String payload) async {
          onNotificationClick(payload);
        });
  }

  Future<void> showNotification() async {
    var androidChanel = AndroidNotificationDetails(
      "channelId",
      "channelName",
      "channelDescription",
      importance: Importance.max,
      playSound: true,
      priority: Priority.high,
    );
    var platFormChannel = NotificationDetails(android: androidChanel);
    await flutterLocalNotificationsPlugin.show(
      0,
      "Test title",
      "Test body",
      platFormChannel,
      payload: "New payload",
    );
  }

  Future<void> showScheduleNotification() async {
    var androidChanel = AndroidNotificationDetails(
      "channelId",
      "channelName",
      "channelDescription",
      importance: Importance.max,
      playSound: true,
      priority: Priority.high,
    );
    var platFormChannel = NotificationDetails(android: androidChanel);
    await flutterLocalNotificationsPlugin.show(
      0,
      "Test title",
      "Test body",
      platFormChannel,
      payload: "New payload",
    );
  }
}

LocalNotifyManager localNotifyManager = LocalNotifyManager.init();

class ReceiveNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceiveNotification({@required this.id,
    @required this.title,
    @required this.body,
    @required this.payload});
}
