import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'services/hive_service.dart';
import 'services/notification_service.dart';
import 'views/login_view.dart';
import 'views/main_navigation_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive local storage
  await HiveService.init();

  // Initialize Local Notifications
  await NotificationService.init();

  // Check existing login session
  final bool loggedIn = await AuthService.isLoggedIn();

  runApp(HarryPotterApp(isLoggedIn: loggedIn));
}

class HarryPotterApp extends StatelessWidget {
  final bool isLoggedIn;

  const HarryPotterApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Harry Potter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF141324),
        primaryColor: const Color(0xFFD3A625),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFD3A625),
          secondary: const Color(0xFF740001),
          surface: const Color(0xFF1F1E33),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1E33),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        useMaterial3: true,
      ),
      home: isLoggedIn ? const MainNavigationView() : const LoginView(),
    );
  }
}
