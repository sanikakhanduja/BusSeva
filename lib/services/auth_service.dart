import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth change stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Test Firebase connection
  Future<bool> testFirebaseConnection() async {
    try {
      // Try to fetch the current user to test connection
      await _auth.currentUser?.reload();
      return true;
    } catch (e) {
      print('Firebase connection test failed: $e');
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
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Create user with email and password
  Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  // Reset password
  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
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
      default:
        // Log the full error for debugging
        print('Firebase Auth Error - Code: ${e.code}, Message: ${e.message}');
        return 'Authentication failed: ${e.message ?? e.code}';
    }
  }
}
