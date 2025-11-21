/// ****************** FILE INFO ******************
/// File Name: main.dart
/// Purpose: Main entry point for the Flutter application
/// Author: Mohamed Elrashidy
/// Created At: 21/11/2025

import 'package:app/settings/settings_page.dart';
import 'package:app/web_view/web_view_page.dart';
import 'package:flutter/material.dart';

/// Function Name: main
///
/// Purpose: Entry point of the application
///
/// Parameters: None
///
/// Returns: void
void main() {
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
        '/': (context) => const SettingsPage(),
        '/webview': (context) {
          final url = ModalRoute.of(context)?.settings.arguments as String?;
          return WebViewPage(url: url);
        },
      },
    );
  }
}
