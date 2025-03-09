// main.dart
import 'package:flutter/material.dart';
import 'theme/theme.dart';

void main() {
  runApp(const RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Management',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode:
          ThemeMode.light, // or ThemeMode.system to respect device settings
      home: const LoginScreen(), // Your initial screen
    );
  }
}
