import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:geolocator/geolocator.dart';

class TripPage extends StatefulWidget {
  const TripPage({super.key});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  // Trip state variables
  bool _occupancyFull = false;
  int _occupancyPercentage = 75;
  bool _isMapVisible = false;
  Timer? _shiftTimer;
  Duration _shiftDuration = Duration.zero;
  Timer? _gpsTimer;
  final bool _isOnTrip = true;

  // Mock driver and bus data
  final String _driverName = "Rajesh Kumar";
  final String _busNumber = "DL-1PC-1234";
  final String _busCapacity = "52";
  final String _route = "Connaught Place → IGDTUW";

  @override
  void initState() {
    super.initState();
    _startShiftTimer();
    _startGpsPinging();
  }

  @override
  void dispose() {
    _shiftTimer?.cancel();
    _gpsTimer?.cancel();
    super.dispose();
  }

  void _startShiftTimer() {
    _shiftTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _shiftDuration = Duration(seconds: _shiftDuration.inSeconds + 1);
      });
    });
  }

  void _startGpsPinging() {
    _gpsTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      // Mock GPS ping in background
      print("GPS Ping sent: ${DateTime.now()}");
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _driverName.split(' ').map((n) => n[0]).join(),
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _driverName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$_busNumber • Cap: $_busCapacity',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _formatDuration(_shiftDuration),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Route Information
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.route, color: Colors.blue),
                      const SizedBox(width: 8),
                      const Text(
                        'Current Route',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _isOnTrip ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _isOnTrip ? 'ON TRIP' : 'STANDBY',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _route,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isMapVisible = !_isMapVisible;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isMapVisible
                                ? "Map loaded 🗺️"
                                : "Map hidden (data saved)",
                          ),
                        ),
                      );
                    },
                    icon: Icon(_isMapVisible ? Icons.map_outlined : Icons.map),
                    label: Text(_isMapVisible ? 'Hide Map' : 'Show Map'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                    ),
                  ),
                  if (_isMapVisible) ...[
                    const SizedBox(height: 16),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.map, size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'Map View Loaded',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Occupancy Control
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.people, color: Colors.orange),
                      const SizedBox(width: 8),
                      const Text(
                        'Bus Occupancy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Bus is Full'),
                    subtitle: const Text(
                      'Toggle when no more passengers can board',
                    ),
                    value: _occupancyFull,
                    activeThumbColor: Colors.orange,
                    onChanged: (val) {
                      setState(() => _occupancyFull = val);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _occupancyFull
                                ? "Bus marked as FULL"
                                : "Bus marked as available",
                          ),
                          backgroundColor: _occupancyFull
                              ? Colors.red
                              : Colors.green,
                        ),
                      );
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  if (!_occupancyFull) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Occupancy: $_occupancyPercentage%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Slider(
                      value: _occupancyPercentage.toDouble(),
                      max: 100,
                      divisions: 10,
                      activeColor: Colors.orange,
                      label: '$_occupancyPercentage%',
                      onChanged: (val) {
                        setState(() => _occupancyPercentage = val.round());
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // GPS Status
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade100),
              ),
              child: Row(
                children: [
                  Icon(Icons.gps_fixed, color: Colors.green.shade700),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GPS Tracking Active',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Location being sent every 30 seconds',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Manual GPS Ping Button
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Manual GPS ping sent 📍"),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              icon: const Icon(Icons.my_location),
              label: const Text('Send Manual GPS Ping'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
