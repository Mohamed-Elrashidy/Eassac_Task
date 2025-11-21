/// ****************** FILE INFO ******************
/// File Name: main.dart
/// Purpose: Main entry point for the Flutter application
/// Author: Mohamed Elrashidy
/// Created At: 21/11/2025

import 'package:app/authentication/authentication_page.dart';
import 'package:app/settings/settings_page.dart';
import 'package:app/web_view/web_view_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

/// Function Name: main
///
/// Purpose: Entry point of the application with Firebase initialization
///
/// Parameters: None
///
/// Returns: Future void
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  runApp(const MyApp());
}

/// ****************** CLASS: MyApp ******************
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eassac Task',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthenticationPage(),
        '/settings': (context) => const SettingsPage(),
        '/webview': (context) {
          final url = ModalRoute.of(context)?.settings.arguments as String?;
          return WebViewPage(url: url);
        },
      },
    );
  }
}
