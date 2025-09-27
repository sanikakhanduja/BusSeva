import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

// Import your existing pages
import 'pages/login_page.dart';
import 'pages/sign_up_page.dart';
import 'pages/selfie_verification_page.dart';
import 'pages/driver_home_page.dart';
import 'pages/diagnostics_page.dart';

// Import new chatbot pages
import 'pages/gemini_chatbot_page.dart';
import 'pages/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Busseva',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      navigatorKey: NavigationService.navigatorKey, // Add navigation service
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/selfie-verification': (context) => const SelfieVerificationPage(),
        '/driverHome': (context) => const DriverHomePage(),
        '/driver-home': (context) => const DriverHomePage(),
        '/diagnostics': (context) => const DiagnosticsPage(),
        '/chatbot': (context) => const GeminiChatbotPage(), // Add chatbot route
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        print('AuthWrapper - Connection state: ${snapshot.connectionState}');
        print('AuthWrapper - Has data: ${snapshot.hasData}');
        print('AuthWrapper - Data: ${snapshot.data?.email ?? 'null'}');
        print('AuthWrapper - Has error: ${snapshot.hasError}');

        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('AuthWrapper - Showing loading...');
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If there's an error, show login page
        if (snapshot.hasError) {
          print('AuthWrapper - Error detected, showing login page');
          return const LoginPage();
        }

        // User is logged in - go directly to driver home page
        if (snapshot.hasData && snapshot.data != null) {
          print('AuthWrapper - User authenticated, showing driver home page');
          return const DriverHomePage();
        }

        // User is not logged in, show login page
        print('AuthWrapper - No user, showing login page');
        return const LoginPage();
      },
    );
  }
}
