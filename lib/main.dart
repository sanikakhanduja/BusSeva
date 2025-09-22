import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

// Import your pages
import 'pages/login_page.dart';
import 'pages/sign_up_page.dart';
import 'pages/selfie_verification_page.dart'; // Your existing selfie verification page
import 'pages/driver_home_page.dart';
import 'pages/diagnostics_page.dart';

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
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/selfie-verification': (context) => const SelfieVerificationPage(),
        '/driverHome': (context) =>
            const DriverHomePage(), // Match your selfie verification page navigation
        '/driver-home': (context) =>
            const DriverHomePage(), // Keep both for compatibility
        '/diagnostics': (context) => const DiagnosticsPage(),
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
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // User is logged in - go directly to driver home page
        if (snapshot.hasData && snapshot.data != null) {
          return const DriverHomePage();
        }

        // User is not logged in, show login page
        return const LoginPage();
      },
    );
  }
}
