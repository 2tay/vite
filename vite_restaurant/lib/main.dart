import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/menu_provider.dart';
import 'providers/order_provider.dart';
import 'providers/table_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/app_settings_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'theme/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => TableProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
      ],
      child: Consumer<AppSettingsProvider>(
        builder: (context, appSettings, _) {
          return MaterialApp(
            title: 'Restaurant Manager',
            theme: ThemeData(
              primarySwatch: MaterialColor(
                AppColors.primary.value,
                <int, Color>{
                  50: AppColors.primary.withOpacity(0.1),
                  100: AppColors.primary.withOpacity(0.2),
                  200: AppColors.primary.withOpacity(0.3),
                  300: AppColors.primary.withOpacity(0.4),
                  400: AppColors.primary.withOpacity(0.5),
                  500: AppColors.primary,
                  600: AppColors.primary.withOpacity(0.7),
                  700: AppColors.primary.withOpacity(0.8),
                  800: AppColors.primary.withOpacity(0.9),
                  900: AppColors.primary.withOpacity(1.0),
                },
              ),
              fontFamily: 'Roboto',
              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.primary,
                elevation: 2,
                centerTitle: false,
              ),
              cardTheme: CardTheme(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              primaryColor: AppColors.primary,
              colorScheme: const ColorScheme.dark().copyWith(
                primary: AppColors.primary,
                secondary: AppColors.secondary,
              ),
            ),
            themeMode: appSettings.themeMode,
            initialRoute: '/',
            routes: {
              '/': (context) => _buildInitialScreen(context),
              '/login': (context) => const LoginScreen(),
              '/home': (context) => const HomeScreen(),
            },
          );
        },
      ),
    );
  }

  Widget _buildInitialScreen(BuildContext context) {
    // Check if the user is already logged in
    final authProvider = Provider.of<AuthProvider>(context);
    return authProvider.isAuthenticated
        ? const HomeScreen()
        : const LoginScreen();
  }
}
