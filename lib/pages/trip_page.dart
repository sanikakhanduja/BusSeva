import 'package:flutter/material.dart';

class TripPage extends StatefulWidget {
  const TripPage({super.key});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  bool _occupancyFull = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trip Control")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Route: Connaught Place → IGDTUW"),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Mock GPS Ping Sent 📍")),
                );
              },
              child: const Text("Send GPS Ping"),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text("Occupancy Full"),
              value: _occupancyFull,
              onChanged: (val) => setState(() => _occupancyFull = val),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("SOS Sent (Mock FCM + SMS) 🚨")),
                );
              },
              child: const Text("SOS"),
            ),
          ],
        ),
      ),
    );
  }
}
