import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_customer/constants/config.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/firebase_options.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/providers/misc_providers.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';

// @pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupFlutterNotifications();
  showFlutterNotification(message);
  debugPrint('Handling a background message ${message.messageId}');
}

Future<void> _firebaseMessagingForgroundHandler() async {
  FirebaseMessaging.onMessage.listen((message) {
    debugPrint(message.data.toString());
    debugPrint(message.toString());
    debugPrint('Handling a ForeGround message ${message.messageId}');
    debugPrint('Handling a ForeGround message ${message.notification}');
    showFlutterNotification(message);
  });
}

void handleMessage(RemoteMessage? message) {
  if (message == null) return;
  if (message.data['type'] == 'Conversetion') {
    // ContextLess.navigatorkey.currentState!
    //     .pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
    // ContextLess.navigatorkey.currentState!.pushNamed(
    //   Routes.messageScreen,
    //   arguments: MessageScreenArgument(
    //     orderId: int.parse(message.data['orderId'].toString()),
    //     senderId: int.parse(message.data['receiverId'].toString()),
    //     receiverId: int.parse(message.data['senderId'].toString()),
    //   ),
    // );
  }
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
      );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@drawable/ic_stat_launcher'),
    iOS: DarwinInitializationSettings(),
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveBackgroundNotificationResponse: onDidReceiveLocalNotification,
    onDidReceiveNotificationResponse: onSelectNotification,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  isFlutterLocalNotificationsInitialized = true;
}

Future<void> onSelectNotification(
  NotificationResponse notificationResponse,
) async {
  // final List<String> parts = notificationResponse.payload!.split('_');
  // final int orderId = int.parse(parts[0]);
  // final int senderId = int.parse(parts[1]);
  // final int receiverId = int.parse(parts[2]);
  // ContextLess.navigatorkey.currentState!.pushNamedAndRemoveUntil(
  //   Routes.messageScreen,
  //   arguments: MessageScreenArgument(
  //     orderId: orderId,
  //     senderId: receiverId,
  //     receiverId: senderId,
  //   ),
  //   (route) => true,
  // );
}

Future<void> onDidReceiveLocalNotification(
  NotificationResponse notificationResponse,
) async {
  // final List<String> parts = notificationResponse.payload!.split('_');
  // final int orderId = int.parse(parts[0]);
  // final int senderId = int.parse(parts[1]);
  // final int receiverId = int.parse(parts[2]);
  // ContextLess.navigatorkey.currentState!.pushNamedAndRemoveUntil(
  //   Routes.messageScreen,
  //   arguments: MessageScreenArgument(
  //     orderId: orderId,
  //     senderId: receiverId,
  //     receiverId: senderId,
  //   ),
  //   (route) => true,
  // );
}

void showFlutterNotification(RemoteMessage message) {
  final String combinedPayload =
      '${message.data['orderId']}_${message.data['senderId']}_${message.data['receiverId']}';
  final RemoteNotification? notification = message.notification;
  final AndroidNotification? android = message.notification?.android;
  final AppleNotification? iOS = message.notification?.apple;
  if (notification != null && (android != null || iOS != null) && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: '@drawable/ic_stat_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: combinedPayload,
    );
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupFlutterNotifications();
  // Background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Forground message handler
  _firebaseMessagingForgroundHandler();

  final token = await FirebaseMessaging.instance.getToken();
  debugPrint('Token : $token');
  Stripe.publishableKey = AppConfig.publicKey;
  // await oneSignalHandler();
  await Hive.initFlutter();
  await Hive.openBox(AppHSC.appSettingsBox);
  await Hive.openBox(AppHSC.authBox);
  await Hive.openBox(AppHSC.userBox);
  await Hive.openBox(AppHSC.cartBox);
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  Locale resolveLocale(String? langCode) {
    if (langCode != null) {
      return Locale(langCode);
    } else {
      return const Locale('en');
    }
  }

  Future<void> launchApp() async {
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    handleMessage(initialMessage);
  }

  @override
  void initState() {
    launchApp();
    // ref.read(socketProvider).initSocketConnection();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // ref.read(socketProvider).initSocketConnection();
      if (kDebugMode) {
        print('App is resumed');
      }
    } else if (state == AppLifecycleState.paused) {
      // ref.read(socketProvider).socket!.dispose();
      if (kDebugMode) {
        print('app is paused');
      }
    } else if (state == AppLifecycleState.inactive) {
      // ref.read(socketProvider).valueSet(orderID: 0, show: true);
      if (kDebugMode) {
        print('inactive');
      }
    } else if (state == AppLifecycleState.detached) {
      if (kDebugMode) {
        print('app is detached');
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final playerID = ref.watch(onesignalDeviceIDProvider);
    if (playerID == '') {
      // getPlayerID(ref);
    }
    return ScreenUtilInit(
      designSize: const Size(375, 812), // XD Design Size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ValueListenableBuilder(
          valueListenable: Hive.box(AppHSC.appSettingsBox).listenable(),
          builder: (BuildContext context, Box appSettingsBox, Widget? child) {
            final selectedLocal = appSettingsBox.get(AppHSC.appLocal);
            print(selectedLocal);
            return MaterialApp(
              title: 'Laundry',

              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                FormBuilderLocalizations.delegate,
              ],
              locale: resolveLocale(selectedLocal as String?),
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                if (selectedLocal == null || selectedLocal == '') {
                  appSettingsBox.put(
                    AppHSC.appLocal,
                    deviceLocale?.languageCode,
                  );
                }
                for (final locale in supportedLocales) {
                  if (locale.languageCode == deviceLocale!.languageCode) {
                    return deviceLocale;
                  }
                }
                return supportedLocales.first;
              },
              supportedLocales: S.delegate.supportedLocales,
              theme: ThemeData(
                fontFamily: "Poppins",
              ),
              navigatorKey: ContextLess
                  .navigatorkey, //Setting Global navigator key to navigate from anywhere without Context

              onGenerateRoute: (settings) => generatedRoutes(settings),
              initialRoute: Routes.splash,
              builder: EasyLoading.init(),
            );
          },
        );
      },
    );
  }
}
