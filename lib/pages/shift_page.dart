import 'package:flutter/material.dart';
import 'dart:async';
import 'trip_page.dart';

class ShiftPage extends StatefulWidget {
  const ShiftPage({super.key});

  @override
  State<ShiftPage> createState() => _ShiftPageState();
}

class _ShiftPageState extends State<ShiftPage>
    with SingleTickerProviderStateMixin {
  bool _onShift = false;
  DateTime? _shiftStartTime;
  late AnimationController _animationController;
  Timer? _timer;

  // Enhanced shift data
  final Map<String, dynamic> assignedShift = {
    "shiftName": "Morning Shift",
    "shiftId": "MS-2024-092201",
    "date": "Monday, Sep 22, 2024",
    "startTime": "06:00",
    "endTime": "14:00",
    "depot": "Central Bus Depot",
    "supervisor": {
      "name": "Amit Gupta",
      "phone": "+91-9123456789",
      "id": "SUP-001",
    },
    "bus": {
      "id": "DL-1234",
      "model": "Gajraj Bus Service",
      "capacity": 45,
      "fuelLevel": 85,
      "lastService": "Sep 18, 2024",
      "mileage": "45,230 km",
      "condition": "Good",
    },
    "route": {
      "name": "Jaipur ↔ Lucknow",
      "code": "RT-001",
      "totalStops": 12,
      "distance": "575 km",
      "estimatedTrips": 8,
      "avgTripTime": "6hr 59min",
      "expectedRevenue": "₹1500",
    },
    "weather": {
      "condition": "Partly Cloudy",
      "temperature": "28°C",
      "visibility": "Good",
    },
    "specialInstructions": [
      "School hours: Extra caution near Government School (Stop 7)",
      "Construction work on MG Road - expect delays",
      "VIP movement possible between 10-11 AM",
    ],
    "targets": {
      "onTimePerformance": "95%",
      "passengerSatisfaction": "4.5/5",
      "fuelEfficiency": "8.5 km/l",
    },
  };

  String _currentTime = '';
  String _currentDate = '';
  int _hoursToShift = 0;
  int _minutesToShift = 0;
  bool _isShiftTime = false;
  double _preparationProgress = 0.0;

  // Checklist items
  final Map<String, bool> _preShiftChecklist = {
    'Vehicle Inspection': false,
    'Documentation Check': false,
    'Route Briefing': false,
    'Safety Equipment': false,
    'GPS & Communication': false,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _updateDateTime();
    _startTimer();
    _calculateTimeToShift();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateDateTime();
      _calculateTimeToShift();
      _updatePreparationProgress();
    });
  }

  void _updateDateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
      _currentDate = _getFormattedDate(now);
    });
  }

  String _getFormattedDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }

  void _calculateTimeToShift() {
    final now = DateTime.now();
    final shiftStart = DateTime(now.year, now.month, now.day, 6, 0);
    final shiftEnd = DateTime(now.year, now.month, now.day, 14, 0);

    if (now.isAfter(shiftStart) && now.isBefore(shiftEnd)) {
      setState(() {
        _isShiftTime = true;
        _hoursToShift = 0;
        _minutesToShift = 0;
      });
    } else {
      final difference = now.isBefore(shiftStart)
          ? shiftStart.difference(now)
          : shiftStart.add(const Duration(days: 1)).difference(now);

      setState(() {
        _isShiftTime = false;
        _hoursToShift = difference.inHours;
        _minutesToShift = difference.inMinutes % 60;
      });
    }
  }

  void _updatePreparationProgress() {
    final completed = _preShiftChecklist.values.where((v) => v).length;
    setState(() {
      _preparationProgress = completed / _preShiftChecklist.length;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startShift() {
    if (_preparationProgress < 1.0) {
      _showChecklistDialog();
      return;
    }

    setState(() {
      _onShift = true;
      _shiftStartTime = DateTime.now();
    });
    _animationController.repeat();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Shift started! Navigating to Trip Management...'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate to Trip Management page
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TripPage()),
        );
      }
    });
  }

  void _showChecklistDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 12),
            Text('Complete Pre-Shift Checklist'),
          ],
        ),
        content: const Text(
          'Please complete all pre-shift checklist items before starting your shift.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _getShiftDuration() {
    if (_shiftStartTime == null) return '0h 0m';
    final duration = DateTime.now().difference(_shiftStartTime!);
    return '${duration.inHours}h ${duration.inMinutes % 60}m';
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
        title: const Text(
          'Shift Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Enhanced Status Card - similar to Route Information card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _onShift ? Colors.green.shade50 : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _onShift
                      ? Colors.green.shade100
                      : Colors.blue.shade100,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        _onShift ? Icons.directions_bus_filled : Icons.schedule,
                        color: _onShift ? Colors.green : Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _onShift ? 'Shift Status' : 'Shift Ready',
                        style: const TextStyle(
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
                          color: _onShift ? Colors.green : Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _onShift ? 'ACTIVE' : 'READY',
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
                    _onShift
                        ? 'Shift running for ${_getShiftDuration()}'
                        : '${assignedShift['shiftName']} - ${assignedShift['startTime']} to ${assignedShift['endTime']}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _onShift ? Colors.green : Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Weather Card - similar to TripPage card structure
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade100),
              ),
              child: Row(
                children: [
                  Icon(Icons.wb_cloudy, color: Colors.orange.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weather: ${assignedShift['weather']['condition']}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${assignedShift['weather']['temperature']} • ${assignedShift['weather']['visibility']} visibility',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Pre-Shift Checklist - similar to occupancy control
            if (!_onShift) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.checklist, color: Colors.purple.shade700),
                        const SizedBox(width: 8),
                        const Text(
                          'Pre-Shift Checklist',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${(_preparationProgress * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _preparationProgress == 1.0
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: _preparationProgress,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _preparationProgress == 1.0
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._preShiftChecklist.keys.map((item) {
                      return CheckboxListTile(
                        title: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 12,
                          ), // Made font small
                        ),
                        value: _preShiftChecklist[item],
                        onChanged: (value) {
                          setState(() {
                            _preShiftChecklist[item] = value ?? false;
                          });
                        },
                        activeColor: Colors.purple,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Shift Details - similar to GPS status card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade100),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.green.shade700),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Shift Details',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _infoRow('Shift ID', assignedShift['shiftId']),
                  _infoRow('Type', assignedShift['shiftName']),
                  _infoRow(
                    'Time',
                    '${assignedShift['startTime']} - ${assignedShift['endTime']}',
                  ),
                  _infoRow('Supervisor', assignedShift['supervisor']['name']),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Bus Information
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.directions_bus, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Assigned Vehicle',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _infoRow('Bus Number', assignedShift['bus']['id']),
                  _infoRow('Model', assignedShift['bus']['model']),
                  _infoRow(
                    'Capacity',
                    '${assignedShift['bus']['capacity']} passengers',
                  ),
                  _infoRowWithStatus(
                    'Fuel Level',
                    '${assignedShift['bus']['fuelLevel']}%',
                    assignedShift['bus']['fuelLevel'] > 70
                        ? Colors.green
                        : Colors.orange,
                  ),
                  _infoRow('Condition', assignedShift['bus']['condition']),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Route Information
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.shade100),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.route, color: Colors.teal.shade700),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Route Information',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _infoRow('Route', assignedShift['route']['name']),
                  _infoRow('Code', assignedShift['route']['code']),
                  _infoRow('Distance', assignedShift['route']['distance']),
                  _infoRow('Stops', '${assignedShift['route']['totalStops']}'),
                  _infoRow(
                    'Est. Revenue',
                    assignedShift['route']['expectedRevenue'],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Special Instructions
            if ((assignedShift['specialInstructions'] as List).isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: Colors.amber.shade700),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Special Instructions',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Important notes for your shift',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...(assignedShift['specialInstructions'] as List)
                        .map<Widget>((instruction) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 6),
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Colors.amber,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    instruction,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Action Buttons - similar to TripPage button style
            if (!_onShift) ...[
              OutlinedButton.icon(
                onPressed: _startShift,
                icon: const Icon(Icons.play_arrow),
                label: const Text('START SHIFT'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.green),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ] else ...[
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 24),
                      SizedBox(width: 12),
                      Text(
                        'SHIFT ACTIVE',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _infoRowWithStatus(String label, String value, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
