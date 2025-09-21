import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../services/auth_service.dart';

class DiagnosticsPage extends StatefulWidget {
  const DiagnosticsPage({super.key});

  @override
  State<DiagnosticsPage> createState() => _DiagnosticsPageState();
}

class _DiagnosticsPageState extends State<DiagnosticsPage> {
  final _authService = AuthService();
  final List<String> _diagnostics = [];
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _runDiagnostics();
  }

  Future<void> _runDiagnostics() async {
    setState(() {
      _isRunning = true;
      _diagnostics.clear();
    });

    // Test 1: Check Firebase Apps
    try {
      _addDiagnostic('✅ Firebase Apps: ${Firebase.apps.length} found');
      if (Firebase.apps.isNotEmpty) {
        final app = Firebase.app();
        _addDiagnostic('✅ Default app: ${app.name}');
        _addDiagnostic('✅ Project ID: ${app.options.projectId}');
        _addDiagnostic('✅ API Key: ${app.options.apiKey.substring(0, 10)}...');
      }
    } catch (e) {
      _addDiagnostic('❌ Firebase Apps Error: $e');
    }

    // Test 2: Check Auth Instance
    try {
      final authInstance = _authService.currentUser;
      _addDiagnostic(
        '✅ FirebaseAuth instance: ${authInstance != null ? 'User logged in' : 'No user'}',
      );
    } catch (e) {
      _addDiagnostic('❌ FirebaseAuth Error: $e');
    }

    // Test 3: Test Firebase Auth Access
    try {
      final authTest = await _authService.testFirebaseAuth();
      if (authTest['success']) {
        _addDiagnostic('✅ Firebase Auth: ${authTest['message']}');
        _addDiagnostic('✅ Project ID: ${authTest['projectId']}');
      } else {
        _addDiagnostic('❌ Firebase Auth: ${authTest['message']}');
      }
    } catch (e) {
      _addDiagnostic('❌ Firebase Auth test error: $e');
    }

    // Test 4: Test Firebase Connection
    try {
      final isConnected = await _authService.testFirebaseConnection();
      _addDiagnostic(
        isConnected
            ? '✅ Firebase connection: OK'
            : '❌ Firebase connection: Failed',
      );
    } catch (e) {
      _addDiagnostic('❌ Connection test error: $e');
    }

    // Test 5: Try creating a test user to check network
    try {
      _addDiagnostic('🔄 Testing user creation...');
      await _authService.createUserWithEmailAndPassword(
        email: 'test${DateTime.now().millisecondsSinceEpoch}@test.com',
        password: 'test123456',
      );
      _addDiagnostic('✅ User creation: SUCCESS (Network is working!)');
    } catch (e) {
      _addDiagnostic('ℹ️  User creation error: $e');
    }

    // Test 6: Try signing in with non-existent user
    try {
      await _authService.signInWithEmailAndPassword(
        email: 'nonexistent@test.com',
        password: 'testpassword',
      );
    } catch (e) {
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('network')) {
        _addDiagnostic(
          '❌ Network error in auth - Check Firebase console settings',
        );
        _addDiagnostic(
          '💡 Ensure Email/Password auth is enabled in Firebase console',
        );
      } else if (errorString.contains('user-not-found') ||
          errorString.contains('wrong-password')) {
        _addDiagnostic(
          '✅ Authentication working - User not found (as expected)',
        );
      } else {
        _addDiagnostic('ℹ️  Test sign-in error: $e');
      }
    }

    setState(() {
      _isRunning = false;
    });
  }

  void _addDiagnostic(String message) {
    setState(() {
      _diagnostics.add(
        '${DateTime.now().toString().substring(11, 19)}: $message',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Diagnostics'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isRunning ? null : _runDiagnostics,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isRunning)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Running diagnostics...'),
                  ],
                ),
              ),
            const Text(
              'Diagnostic Results:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ListView.builder(
                  itemCount: _diagnostics.length,
                  itemBuilder: (context, index) {
                    final diagnostic = _diagnostics[index];
                    Color textColor = Colors.black;
                    if (diagnostic.contains('✅')) {
                      textColor = Colors.green.shade700;
                    } else if (diagnostic.contains('❌')) {
                      textColor = Colors.red.shade700;
                    } else if (diagnostic.contains('ℹ️')) {
                      textColor = Colors.blue.shade700;
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        diagnostic,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: textColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Back to Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
