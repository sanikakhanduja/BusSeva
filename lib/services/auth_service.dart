import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Private flag to track logout state
  bool _isLoggingOut = false;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth change stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Check if currently logging out
  bool get isLoggingOut => _isLoggingOut;

  // Test Firebase connection
  Future<bool> testFirebaseConnection() async {
    try {
      // Try to fetch the current user to test connection
      await _auth.currentUser?.reload();
      return true;
    } catch (e) {
      debugPrint('Firebase connection test failed: $e');
      return false;
    }
  }

  // Test Firebase Auth specifically with a simple operation
  Future<Map<String, dynamic>> testFirebaseAuth() async {
    try {
      // Try to check if we can access Firebase Auth properties
      final app = _auth.app;
      final currentUser = _auth.currentUser;

      return {
        'success': true,
        'message': 'Firebase Auth is accessible',
        'appName': app.name,
        'projectId': app.options.projectId,
        'hasUser': currentUser != null,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Firebase Auth error: $e',
        'error': e.toString(),
      };
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('Attempting to sign in with email: $email');
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('Sign in successful for: ${credential.user?.email}');
      return credential;
    } on FirebaseAuthException catch (e) {
      debugPrint('Sign in failed - Code: ${e.code}, Message: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('Unexpected sign in error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Create user with email and password
  Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('Attempting to create user with email: $email');
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('User creation successful for: ${credential.user?.email}');
      return credential;
    } on FirebaseAuthException catch (e) {
      debugPrint(
        'User creation failed - Code: ${e.code}, Message: ${e.message}',
      );
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('Unexpected user creation error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Enhanced sign out with better error handling and state management
  Future<bool> signOut() async {
    if (_isLoggingOut) {
      debugPrint('Logout already in progress, skipping...');
      return false;
    }

    try {
      _isLoggingOut = true;
      debugPrint('Starting signOut process...');
      debugPrint('Current user before signOut: ${_auth.currentUser?.email}');
      debugPrint('Current user UID: ${_auth.currentUser?.uid}');

      // Force reload current user to ensure we have the latest state
      await _auth.currentUser?.reload();

      // Perform the signout
      await _auth.signOut();

      // Wait a moment for the auth state to update
      await Future.delayed(const Duration(milliseconds: 500));

      debugPrint('Firebase signOut completed');
      debugPrint('Current user after signOut: ${_auth.currentUser}');

      // Verify logout was successful
      if (_auth.currentUser == null) {
        debugPrint('Logout verification: SUCCESS - No current user');
        return true;
      } else {
        debugPrint(
          'Logout verification: FAILED - User still exists: ${_auth.currentUser?.email}',
        );
        // Try one more time
        await _auth.signOut();
        await Future.delayed(const Duration(milliseconds: 300));
        return _auth.currentUser == null;
      }
    } catch (e) {
      debugPrint('SignOut error: $e');
      // Don't throw exception, just return false to indicate failure
      return false;
    } finally {
      _isLoggingOut = false;
    }
  }

  // Force logout - more aggressive approach
  Future<bool> forceSignOut() async {
    if (_isLoggingOut) {
      debugPrint('Force logout already in progress, skipping...');
      return false;
    }

    try {
      _isLoggingOut = true;
      debugPrint('Starting FORCE signOut process...');

      // Try multiple approaches
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        debugPrint('Force logout - Current user: ${currentUser.email}');

        // Method 1: Standard signout
        await _auth.signOut();
        await Future.delayed(const Duration(milliseconds: 300));

        // Method 2: If still logged in, try to delete and recreate the auth instance
        if (_auth.currentUser != null) {
          debugPrint('Standard logout failed, trying alternative approach...');

          // Clear any cached tokens (this varies by platform)
          try {
            await currentUser.reload();
            await _auth.signOut();
          } catch (e) {
            debugPrint('Alternative logout attempt error: $e');
          }
        }

        // Final verification
        await Future.delayed(const Duration(milliseconds: 500));
        final logoutSuccess = _auth.currentUser == null;

        debugPrint(
          'Force logout result: ${logoutSuccess ? "SUCCESS" : "FAILED"}',
        );
        debugPrint('Current user after force logout: ${_auth.currentUser}');

        return logoutSuccess;
      } else {
        debugPrint('No user to log out');
        return true;
      }
    } catch (e) {
      debugPrint('Force SignOut error: $e');
      return false;
    } finally {
      _isLoggingOut = false;
    }
  }

  // Check current auth state
  Future<Map<String, dynamic>> getCurrentAuthState() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.reload(); // Refresh user data
      }

      return {
        'isLoggedIn': user != null,
        'userEmail': user?.email,
        'userUID': user?.uid,
        'isEmailVerified': user?.emailVerified ?? false,
        'lastSignInTime': user?.metadata.lastSignInTime?.toIso8601String(),
        'creationTime': user?.metadata.creationTime?.toIso8601String(),
      };
    } catch (e) {
      debugPrint('Error getting auth state: $e');
      return {'isLoggedIn': false, 'error': e.toString()};
    }
  }

  // Reset password
  Future<void> resetPassword({required String email}) async {
    try {
      debugPrint('Sending password reset email to: $email');
      await _auth.sendPasswordResetEmail(email: email);
      debugPrint('Password reset email sent successfully');
    } on FirebaseAuthException catch (e) {
      debugPrint(
        'Password reset failed - Code: ${e.code}, Message: ${e.message}',
      );
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('Unexpected password reset error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection and try again.';
      case 'timeout':
        return 'Request timed out. Please check your internet connection and try again.';
      case 'requires-recent-login':
        return 'This operation requires recent authentication. Please log in again.';
      case 'invalid-credential':
        return 'The provided credential is invalid or has expired.';
      default:
        // Log the full error for debugging
        debugPrint(
          'Firebase Auth Error - Code: ${e.code}, Message: ${e.message}',
        );
        return 'Authentication failed: ${e.message ?? e.code}';
    }
  }
}

// Singleton instance for global access
final AuthService authService = AuthService();
