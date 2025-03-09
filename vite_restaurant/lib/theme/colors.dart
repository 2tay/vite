// colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF1E88E5); // Blue shade
  static const Color primaryLight = Color(0xFF6AB7FF);
  static const Color primaryDark = Color(0xFF005CB2);

  // Secondary colors
  static const Color secondary = Color(0xFFF57C00); // Orange shade
  static const Color secondaryLight = Color(0xFFFFAD42);
  static const Color secondaryDark = Color(0xFFBB4D00);

  // Neutrals
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F5F5);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  // Status colors
  static const Color success = Color(0xFF4CAF50); // Available/Ready
  static const Color warning = Color(0xFFFF9800); // Preparing
  static const Color error = Color(0xFFE53935); // Unavailable/Error
  static const Color info = Color(0xFF2196F3); // Information

  // Table status colors
  static const Color tableAvailable = Color(0xFF4CAF50);
  static const Color tableOccupied = Color(0xFFFF9800);
  static const Color tableOrderPlaced = Color(0xFF2196F3);

  // Order status colors
  static const Color orderReceived = Color(0xFF9C27B0); // Purple
  static const Color orderPreparing = Color(0xFFFF9800); // Orange
  static const Color orderReady = Color(0xFF4CAF50); // Green
  static const Color orderDelivered = Color(0xFF2196F3); // Blue
  static const Color orderCancelled = Color(0xFFE53935); // Red
}
