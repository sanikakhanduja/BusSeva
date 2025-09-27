import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'shift_page.dart';
import 'trip_page.dart';
import 'report_page.dart';
import 'settings_page.dart';
import '../services/auth_service.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  bool _isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "BusSeva",
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: PopupMenuButton<String>(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Color(0xFF3B82F6),
                  size: 20,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) async {
                if (value == 'logout') {
                  await _handleLogout(context);
                } else if (value == 'profile') {
                  _showUserInfo(context, user);
                } else if (value == 'chatbot') {
                  Navigator.pushNamed(context, '/chatbot');
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 'profile',
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        color: Color(0xFF64748B),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        user?.email?.split('@')[0] ?? 'Profile',
                        style: const TextStyle(
                          color: Color(0xFF334155),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'chatbot',
                  child: Row(
                    children: [
                      const Icon(
                        Icons.chat_bubble_outline,
                        color: Color(0xFF3B82F6),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'AI Assistant',
                        style: TextStyle(
                          color: Color(0xFF334155),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'logout',
                  enabled: !_isLoggingOut,
                  child: Row(
                    children: [
                      _isLoggingOut
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFFEF4444),
                              ),
                            )
                          : const Icon(Icons.logout, color: Color(0xFFEF4444)),
                      const SizedBox(width: 12),
                      Text(
                        _isLoggingOut ? 'Signing out...' : 'Logout',
                        style: TextStyle(
                          color: _isLoggingOut
                              ? const Color(0xFF64748B)
                              : const Color(0xFFEF4444),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.directions_bus,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome back!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.email?.split('@')[0] ?? 'Driver',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Quick logout button in welcome section
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: IconButton(
                          onPressed: _isLoggingOut
                              ? null
                              : () => _handleLogout(context),
                          icon: _isLoggingOut
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  Icons.logout,
                                  color: Colors.white.withOpacity(0.9),
                                  size: 20,
                                ),
                          tooltip: _isLoggingOut
                              ? 'Signing out...'
                              : 'Quick Logout',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Ready for service',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Dashboard Grid
            const Text(
              'Quick Actions',
              style: TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _buildDashboardTile(
                  context,
                  title: "Shift Control",
                  subtitle: "Manage your shift",
                  icon: Icons.access_time,
                  color: const Color(0xFF10B981),
                  page: const ShiftPage(),
                ),
                _buildDashboardTile(
                  context,
                  title: "Trip Management",
                  subtitle: "Active routes",
                  icon: Icons.directions_bus,
                  color: const Color(0xFF3B82F6),
                  page: const TripPage(),
                ),
                _buildDashboardTile(
                  context,
                  title: "Reports",
                  subtitle: "Issue reporting",
                  icon: Icons.report_problem,
                  color: const Color(0xFFF59E0B),
                  page: const ReportsPage(),
                ),
                _buildDashboardTile(
                  context,
                  title: "Settings",
                  subtitle: "App preferences",
                  icon: Icons.settings,
                  color: const Color(0xFF6B7280),
                  page: const SettingsPage(),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Quick Stats
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Today\'s Summary',
                    style: TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          'Hours',
                          '8.5',
                          Icons.schedule,
                          const Color(0xFF10B981),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: const Color(0xFFE2E8F0),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          'Trips',
                          '12',
                          Icons.route,
                          const Color(0xFF3B82F6),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: const Color(0xFFE2E8F0),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          'Distance',
                          '145km',
                          Icons.straighten,
                          const Color(0xFF8B5CF6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget page,
  }) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    if (_isLoggingOut) {
      print('Logout already in progress, skipping...');
      return;
    }

    print('_handleLogout called');

    // Enhanced confirmation dialog with better styling
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.logout,
                color: Color(0xFFEF4444),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Confirm Logout',
              style: TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to sign out? You\'ll need to log in again to access the app.',
          style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF64748B),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Sign Out',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    print('Logout confirmation result: $shouldLogout');
    if (shouldLogout != true) {
      print('User cancelled logout');
      return;
    }

    setState(() {
      _isLoggingOut = true;
    });

    try {
      print('Calling AuthService.signOut()...');

      // Show loading snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Signing out...',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF3B82F6),
            duration: const Duration(seconds: 10),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }

      // Use the improved AuthService
      final success = await AuthService().signOut();

      print('AuthService.signOut() completed with result: $success');

      if (!mounted) return;

      // Clear the loading snackbar
      ScaffoldMessenger.of(context).clearSnackBars();

      if (success) {
        // Show success message briefly
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                const Text(
                  'Successfully signed out',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF10B981),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );

        // Wait a moment then navigate to login page
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (mounted) {
          // Navigate to login page and clear all previous routes
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
            (route) => false,
          );
        }
        
        print('Logout successful - Navigated to login page');
      } else {
        // Try force logout
        print('Standard logout failed, trying force logout...');
        final forceSuccess = await AuthService().forceSignOut();

        if (forceSuccess) {
          print('Force logout successful');
          
          // Navigate to login page after force logout
          if (mounted) {
            await Future.delayed(const Duration(milliseconds: 500));
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/login',
              (route) => false,
            );
          }
        } else {
          print('Both logout methods failed');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.white, size: 20),
                    const SizedBox(width: 12),
                    const Text(
                      'Logout failed. Please try again.',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                backgroundColor: const Color(0xFFEF4444),
                duration: const Duration(seconds: 4),
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () => _handleLogout(context),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        }
      }
    } catch (e) {
      print('Error during logout: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Error logging out: $e',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFEF4444),
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _handleLogout(context),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  void _showUserInfo(BuildContext context, User? user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.person,
                color: Color(0xFF3B82F6),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Profile Information',
              style: TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Email', user?.email ?? 'Not available'),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Status',
              user?.emailVerified == true ? 'Verified' : 'Unverified',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Last Sign In',
              user?.metadata.lastSignInTime?.toString().split('.')[0] ??
                  'Unknown',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF3B82F6),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Close',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
