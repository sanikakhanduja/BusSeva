import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverSignUpPage extends StatefulWidget {
  const DriverSignUpPage({super.key});

  @override
  State<DriverSignUpPage> createState() => _DriverSignUpPageState();
}

class _DriverSignUpPageState extends State<DriverSignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _aadhaarNumberController = TextEditingController();

  bool _isLoading = false;
  bool _agreed = false;
  bool _isPasswordVisible = false;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate() || !_agreed) return;

    setState(() {
      _isLoading = true;
    });

    // TODO: Implement signup logic

    await Future.delayed(const Duration(seconds: 2)); // Simulate delay

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Signup logic pending implementation")),
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    );
    final enabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.blue),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                const Icon(Icons.directions_bus, size: 80, color: Colors.blue),
                const SizedBox(height: 20),
                Text(
                  'Driver Registration',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign up to manage your routes and schedules with BusSeva',
                  style: GoogleFonts.inter(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: inputBorder,
                    enabledBorder: enabledBorder,
                    focusedBorder: focusedBorder,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: inputBorder,
                    enabledBorder: enabledBorder,
                    focusedBorder: focusedBorder,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // License Number Field
                TextFormField(
                  controller: _licenseNumberController,
                  decoration: InputDecoration(
                    labelText: "License Number",
                    prefixIcon: const Icon(Icons.badge_outlined),
                    border: inputBorder,
                    enabledBorder: enabledBorder,
                    focusedBorder: focusedBorder,
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? "Enter your license number"
                      : null,
                ),
                const SizedBox(height: 16),

                // Aadhaar Number Field
                TextFormField(
                  controller: _aadhaarNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Aadhaar Number",
                    prefixIcon: const Icon(Icons.credit_card_outlined),
                    border: inputBorder,
                    enabledBorder: enabledBorder,
                    focusedBorder: focusedBorder,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your Aadhaar number";
                    }
                    if (!RegExp(r'^\d{12}$').hasMatch(value)) {
                      return "Enter a valid 12-digit Aadhaar number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Terms Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _agreed,
                      onChanged: (val) =>
                          setState(() => _agreed = val ?? false),
                    ),
                    const Expanded(
                      child: Text(
                        'I agree to the Terms of Service and Privacy Policy',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Sign Up Button
                ElevatedButton(
                  onPressed: (_isLoading || !_agreed) ? null : _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 24),

                // Sign In Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
