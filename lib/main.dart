import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/app_state.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    try {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    } catch (e) {
      debugPrint("Firebase initialization failed: $e");
    }
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const WildGuardApp(),
    ),
  );
}

class WildGuardApp extends StatelessWidget {
  const WildGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    ThemeMode themeMode;
    switch (appState.themeSetting) {
      case ThemeSettings.light:
        themeMode = ThemeMode.light;
        break;
      case ThemeSettings.dark:
        themeMode = ThemeMode.dark;
        break;
      case ThemeSettings.system:
        themeMode = ThemeMode.system;
        break;
    }

    return MaterialApp.router(
      title: 'Wild Guard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightMode,
      darkTheme: AppTheme.darkMode,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}




