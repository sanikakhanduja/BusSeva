// lib/pages/navigation_service.dart
import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Define your app's routes based on your existing pages
  static const String homeRoute = '/home';
  static const String driverHomeRoute = '/driver_home';
  static const String tripRoute = '/trip';
  static const String shiftRoute = '/shift';
  static const String reportRoute = '/report';
  static const String settingsRoute = '/settings';
  static const String diagnosticsRoute = '/diagnostics';
  static const String selfieVerificationRoute = '/selfie_verification';
  static const String loginRoute = '/login';
  static const String signUpRoute = '/signup';
  static const String chatbotRoute = '/chatbot';

  static final Map<String, String> routeDescriptions = {
    homeRoute: 'Main dashboard with overview',
    driverHomeRoute: 'Driver-specific dashboard and controls',
    tripRoute: 'Current and past trip information',
    shiftRoute: 'Manage driving shifts and schedules',
    reportRoute: 'Generate and view reports',
    settingsRoute: 'App preferences and configurations',
    diagnosticsRoute: 'System diagnostics and troubleshooting',
    selfieVerificationRoute: 'Identity verification process',
    loginRoute: 'User authentication login',
    signUpRoute: 'Create new user account',
    chatbotRoute: 'AI assistant for app navigation',
  };

  // Navigation keywords that users might use
  static final Map<String, String> navigationKeywords = {
    'home': homeRoute,
    'dashboard': homeRoute,
    'main': homeRoute,
    'driver': driverHomeRoute,
    'driver dashboard': driverHomeRoute,
    'driver home': driverHomeRoute,
    'trip': tripRoute,
    'trips': tripRoute,
    'journey': tripRoute,
    'ride': tripRoute,
    'shift': shiftRoute,
    'shifts': shiftRoute,
    'schedule': shiftRoute,
    'working hours': shiftRoute,
    'report': reportRoute,
    'reports': reportRoute,
    'analytics': reportRoute,
    'statistics': reportRoute,
    'settings': settingsRoute,
    'preferences': settingsRoute,
    'configuration': settingsRoute,
    'config': settingsRoute,
    'diagnostics': diagnosticsRoute,
    'diagnosis': diagnosticsRoute,
    'troubleshoot': diagnosticsRoute,
    'debug': diagnosticsRoute,
    'selfie': selfieVerificationRoute,
    'verification': selfieVerificationRoute,
    'identity': selfieVerificationRoute,
    'verify': selfieVerificationRoute,
    'login': loginRoute,
    'signin': loginRoute,
    'sign in': loginRoute,
    'signup': signUpRoute,
    'sign up': signUpRoute,
    'register': signUpRoute,
    'create account': signUpRoute,
    'chatbot': chatbotRoute,
    'assistant': chatbotRoute,
    'help': chatbotRoute,
    'chat': chatbotRoute,
  };

  static void navigateToRoute(String route) {
    try {
      navigatorKey.currentState?.pushNamed(route);
    } catch (e) {
      debugPrint('Navigation error: $e');
      showSnackBar('Could not navigate to the requested page');
    }
  }

  static void navigateAndReplace(String route) {
    try {
      navigatorKey.currentState?.pushReplacementNamed(route);
    } catch (e) {
      debugPrint('Navigation error: $e');
      showSnackBar('Could not navigate to the requested page');
    }
  }

  static void goBack() {
    try {
      if (navigatorKey.currentState?.canPop() ?? false) {
        navigatorKey.currentState?.pop();
      } else {
        showSnackBar('Cannot go back from current screen');
      }
    } catch (e) {
      debugPrint('Navigation error: $e');
    }
  }

  static void goToHome() {
    navigateAndReplace(homeRoute);
  }

  static void showSnackBar(String message) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Helper method to find route by user input
  static String? findRouteByKeyword(String userInput) {
    final input = userInput.toLowerCase().trim();

    // Direct match
    if (navigationKeywords.containsKey(input)) {
      return navigationKeywords[input];
    }

    // Partial match
    for (final entry in navigationKeywords.entries) {
      if (input.contains(entry.key) || entry.key.contains(input)) {
        return entry.value;
      }
    }

    return null;
  }

  // Get current route name
  static String? getCurrentRoute() {
    return ModalRoute.of(navigatorKey.currentContext!)?.settings.name;
  }

  // Check if we can navigate back
  static bool canGoBack() {
    return navigatorKey.currentState?.canPop() ?? false;
  }
}

// Helper widget to add chatbot button to any page
class ChatbotFloatingButton extends StatelessWidget {
  const ChatbotFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, NavigationService.chatbotRoute);
      },
      backgroundColor: Colors.blue,
      tooltip: 'Open Assistant',
      child: const Icon(Icons.chat, color: Colors.white),
    );
  }
}

// Helper widget for bottom sheet chatbot
class ChatbotBottomSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Navigator.of(context).canPop()
            ? const Text('Chatbot will be loaded here')
            : const Text('Chatbot will be loaded here'),
      ),
    );
  }
}
