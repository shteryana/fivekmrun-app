import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fivekmrun_flutter/barcode_page.dart';
import 'package:fivekmrun_flutter/donate/donate_page.dart';
import 'package:fivekmrun_flutter/home.dart';
import 'package:fivekmrun_flutter/login/helpers.dart';
import 'package:fivekmrun_flutter/login/login.dart';
import 'package:fivekmrun_flutter/login/loginPreview.dart';
import 'package:fivekmrun_flutter/push_notifications_manager.dart';
import 'package:fivekmrun_flutter/settings_page.dart';
import 'package:fivekmrun_flutter/state/authentication_resource.dart';
import 'package:fivekmrun_flutter/state/events_resource.dart';
import 'package:fivekmrun_flutter/state/local_storage_resource.dart';
import 'package:fivekmrun_flutter/state/offline_chart_resource.dart';
import 'package:fivekmrun_flutter/state/runs_resource.dart';
import 'package:fivekmrun_flutter/state/strava_resource.dart';
import 'package:fivekmrun_flutter/state/user_resource.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final userRes = UserResource();
final authRes = AuthenticationResource();

final appAccentColor = Color.fromRGBO(218, 3, 56, 1.0);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  // Pass all uncaught errors to Crashlytics.
  final originalOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails errorDetails) async {
    await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    // Forward to original handler.
    originalOnError!(errorDetails);
  };

  await authRes.loadFromLocalStore();
  String initialRoute = "/";

  final userId = authRes.getUserId();
  if (authRes.getUserId() != null) {
    FirebaseCrashlytics.instance.setUserIdentifier(userId.toString());
    userRes.currentUserId = userId;
    initialRoute = "home";
  }

  runZoned(() {
    runApp(MyApp(initialRoute));
  }, onError: FirebaseCrashlytics.instance.recordError);
}

class MyApp extends StatelessWidget {
  final String _initialRoute;
  static final navKey = new GlobalKey<NavigatorState>();

  MyApp(this._initialRoute);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    PushNotificationsManager().init(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authRes),
        ChangeNotifierProvider(create: (_) => userRes),
        ChangeNotifierProvider(create: (_) => RunsResource()),
        ChangeNotifierProvider(create: (_) => FutureEventsResource()),
        ChangeNotifierProvider(create: (_) => PastEventsResource()),
        ChangeNotifierProvider(create: (_) => OfflineChartResource()),
        ChangeNotifierProvider(create: (_) => LocalStorageResource()),
        ChangeNotifierProvider(create: (_) => StravaResource()),
      ],
      child: MaterialApp(
        navigatorKey: MyApp.navKey,
        debugShowCheckedModeBanner: false,
        title: '5kmRun.bg',
        theme: ThemeData(
            primarySwatch: getColor(appAccentColor),
            brightness: Brightness.dark,
            backgroundColor: Colors.black,
            accentColor: appAccentColor,
            accentIconTheme: IconThemeData(color: Colors.black),
            dividerColor: Colors.black12,
            textTheme: TextTheme(
              subtitle1: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              bodyText1: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
              bodyText2: TextStyle(fontSize: 10),
            ),
            errorColor: Colors.red,
            outlinedButtonTheme: OutlinedButtonThemeData(style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
              return Colors.white;
            }))),
            textButtonTheme: TextButtonThemeData(style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                return Colors.white;
              }),
            ))),
        initialRoute: _initialRoute,
        routes: {
          '/': (_) => Login(),
          'loginPreview': (_) => LoginPreview(),
          'home': (_) => Home(),
          'barcode': (_) => BarcodePage(),
          'settings': (_) => SettingsPage(),
          'donation': (_) => DonatePage(),
        },
      ),
    );
  }
}
