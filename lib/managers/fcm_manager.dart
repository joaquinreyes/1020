import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/managers/user_manager.dart';
import '../globals/constants.dart';
import '../main.dart';
import '../repository/play_repo.dart';
import '../repository/user_repo.dart';
import '../routes/app_pages.dart';
import '../routes/app_routes.dart';

class FcmManager {
  FcmManager._internal();

  factory FcmManager() => _selfInstance;

  static final FcmManager _selfInstance = FcmManager._internal();

  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  RemoteMessage? initialMessage;
  StreamSubscription? messageSubscription;

  String? _token;

  String get token => _token ?? "";

  Future<FcmManager> initialize({bool isInitialize = false}) async {
    if (isInitialize) {
      initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        _handleMessage(initialMessage!);
      }
    }
    if (_isInitialized) return this;

    // Request permissions
    final permissions = await _fcm.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: true,
        sound: true);
    if (permissions.authorizationStatus == AuthorizationStatus.notDetermined) {
      return this;
    }

    // Set foreground notification presentation options
    _fcm.setForegroundNotificationPresentationOptions(
        alert: true, sound: true, badge: true);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessage(message);
    });

    // Listen to incoming messages
    messageSubscription = FirebaseMessaging.onMessage.listen((message) {
      _onMessage(message);
    });

    // Handle token globalRefresh
    _fcm.onTokenRefresh.listen((String token) {
      _onTokenChange(token, globalRef!);
    });

    // Fetch the FCM token
    try {
      _token = await _fcm.getToken() ?? '';
      myPrint("FCM Token: \n$_token");
    } catch (e) {
      myPrint("FCM Token Error: $e");
      _token = "";
    }

    // Configure local notifications
    await _configureLocalNotifications(globalRef!);

    _isInitialized = true;
    return this;
  }

  void _onTokenChange(String fcmToken, WidgetRef globalRef) {
    myPrint("FCM Token globalRefreshed: $fcmToken");
    final userToken = globalRef.read(userManagerProvider).user?.accessToken!;

    if (fcmToken.trim().isNotEmpty && _token != fcmToken && userToken != null) {
      globalRef.watch(saveFCMTokenProvider(fcmToken));
    }
    _token = fcmToken;
  }

  Future<void> _onMessage(RemoteMessage message) async {
    if (message.notification != null) {
      String? payload;
      if (message.data.isNotEmpty) {
        payload = jsonEncode(message.data);
      }
      myPrint(
          "Notification Received: ${message.notification!.title} - ${message.notification!.body} - $payload");

      const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'default_notification_channel_id',
        'Notifications',
        channelDescription: 'Default channel for app notifications',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        color: AppColors.orange,
        icon: '@drawable/ic_pn_launcher',
      );

      const iosPlatformChannelSpecifics = DarwinNotificationDetails();

      const notificationDetails = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iosPlatformChannelSpecifics,
          linux: LinuxNotificationDetails(),
          macOS: DarwinNotificationDetails());

      final token = globalRef!.read(userManagerProvider).user?.accessToken;

      if (message.data["service_type"] == "Event" && token != null) {
        globalRef!.invalidate(fetchServiceDetailProvider);
        globalRef!.invalidate(fetchServiceWaitingPlayersProvider);
      } else if (message.data["service_type"] == "Booking" &&
          message.data["booking_type"] == "Open Match") {
        globalRef!.invalidate(fetchServiceDetailProvider);
        globalRef!.invalidate(fetchServiceWaitingPlayersProvider);
      }

      await _localNotifications.show(
        0,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: payload,
      );
    }
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    if (message.data.isNotEmpty) {
      if (message.data["service_type"] == "Booking" &&
          message.data["booking_type"] == "Open Match") {
        final id = int.tryParse(message.data["service_booking_id"]);
        if (id != null) {
          globalRef!
              .read(goRouterProvider)
              .push("${RouteNames.match_info}/$id");
        }
      } else if (message.data["service_type"] == "Event") {
        final id = int.tryParse(message.data["service_booking_id"]);
        if (id != null) {
          globalRef!
              .read(goRouterProvider)
              .push("${RouteNames.event_info}/$id");
        }
      }
    }
  }

  Future<void> _configureLocalNotifications(WidgetRef globalRef) async {
    const androidInitializationSettings =
        AndroidInitializationSettings('@drawable/ic_pn_launcher');
    const iosInitializationSettings = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings,
        macOS: iosInitializationSettings);

    await _localNotifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) async {
      myPrint("Notification payload: ${payload.payload}");
      myPrint("Notification id: ${payload.id}");
      if ((payload.payload ?? "").isNotEmpty) {
        _handleMessage(RemoteMessage(data: jsonDecode(payload.payload ?? "")));
      }
    });
  }
}
