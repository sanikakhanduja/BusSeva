import 'package:flutter/material.dart';

class ShiftPage extends StatefulWidget {
  const ShiftPage({super.key});

  @override
  State<ShiftPage> createState() => _ShiftPageState();
}

class _ShiftPageState extends State<ShiftPage> {
  bool _isVerified = false;
  bool _onShift = false;
  String? _selectedBus;

  final buses = ["Bus 101", "Bus 202", "Bus 303"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shift Control")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() => _isVerified = true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Biometric Verified ✅")),
                );
              },
              child: const Text("Mock Biometric Verification"),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              hint: const Text("Select Bus"),
              value: _selectedBus,
              items: buses.map((bus) {
                return DropdownMenuItem(value: bus, child: Text(bus));
              }).toList(),
              onChanged: _isVerified
                  ? (val) => setState(() => _selectedBus = val)
                  : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (_selectedBus != null && _isVerified)
                  ? () {
                      setState(() => _onShift = !_onShift);
                    }
                  : null,
              child: Text(_onShift ? "Stop Shift" : "Start Shift"),
            ),
            if (_onShift)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text("Shift Active 🚍 Sending mock GPS pings..."),
              ),
          ],
        ),
      ),
    );
  }
}
