import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripPage extends StatefulWidget {
  const TripPage({super.key});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  // Trip state variables
  bool _occupancyFull = false;
  int _occupancyPercentage = 75;
  Timer? _shiftTimer;
  Duration _shiftDuration = Duration.zero;
  Timer? _gpsTimer;
  final bool _isOnTrip = true;

  // Mock driver and bus data
  final String _driverName = "Rajesh Kumar";
  final String _busNumber = "DL-1PC-1234";
  final String _busCapacity = "52";
  final String _route = "Jaipur to Lucknow";

  // Bus stops with coordinates
  final List<Map<String, dynamic>> busStops = [
    {'name': 'Jaipur', 'lat': 26.907524, 'lng': 75.739639},
    {'name': 'Bassi', 'lat': 26.839153, 'lng': 76.050499},
    {'name': 'Sakrai', 'lat': 26.916187, 'lng': 76.688911},
    {'name': 'Weir Tehsil (Bharatpur)', 'lat': 25.680000, 'lng': 75.730000},
    {'name': 'Kiraoli', 'lat': 27.136724, 'lng': 77.785255},
    {'name': 'Agra', 'lat': 27.176670, 'lng': 78.008076},
    {'name': 'Firozabad', 'lat': 27.158994, 'lng': 78.394230},
    {'name': 'Shikohabad', 'lat': 27.213758, 'lng': 78.553658},
    {'name': 'Etawah', 'lat': 26.794128, 'lng': 79.017860},
    {'name': 'Bidhuna', 'lat': 26.727338, 'lng': 79.446542},
    {'name': 'Tirwaganj', 'lat': 26.761011, 'lng': 79.897902},
    {'name': 'Kakori', 'lat': 26.859342, 'lng': 80.780632},
    {'name': 'Lucknow', 'lat': 26.846690, 'lng': 80.946170},
  ];

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

                  // Button to open full screen map
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullMapPage(stops: busStops),
                        ),
                      );
                    },
                    icon: const Icon(Icons.map),
                    label: const Text('Open Full Map'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Button to open text route page
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RouteTextPage(stops: busStops),
                        ),
                      );
                    },
                    child: const Text("Show Route in Text"),
                  ),
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

// Full screen map page showing all stops with markers and polyline
class FullMapPage extends StatefulWidget {
  final List<Map<String, dynamic>> stops;

  const FullMapPage({super.key, required this.stops});

  @override
  State<FullMapPage> createState() => _FullMapPageState();
}

class _FullMapPageState extends State<FullMapPage> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _initMarkersAndPolyline();
  }

  void _initMarkersAndPolyline() {
    Set<Marker> markers = widget.stops.asMap().entries.map((entry) {
      int idx = entry.key;
      var stop = entry.value;
      return Marker(
        markerId: MarkerId('stop$idx'),
        position: LatLng(stop['lat'], stop['lng']),
        infoWindow: InfoWindow(title: stop['name']),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
    }).toSet();

    List<LatLng> polylinePoints = widget.stops
        .map((stop) => LatLng(stop['lat'], stop['lng']))
        .toList();

    Polyline polyline = Polyline(
      polylineId: const PolylineId('route'),
      points: polylinePoints,
      color: Colors.blue,
      width: 5,
    );

    setState(() {
      _markers = markers;
      _polylines = {polyline};
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _fitMapToBounds();
  }

  Future<void> _fitMapToBounds() async {
    if (_markers.isEmpty || _mapController == null) return;

    double minLat = _markers.first.position.latitude;
    double maxLat = _markers.first.position.latitude;
    double minLng = _markers.first.position.longitude;
    double maxLng = _markers.first.position.longitude;

    for (var marker in _markers) {
      if (marker.position.latitude < minLat) minLat = marker.position.latitude;
      if (marker.position.latitude > maxLat) maxLat = marker.position.latitude;
      if (marker.position.longitude < minLng) {
        minLng = marker.position.longitude;
      }
      if (marker.position.longitude > maxLng) {
        maxLng = marker.position.longitude;
      }
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
    await _mapController!.animateCamera(cameraUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Full Route Map')),
      body: GoogleMap(
        mapType: MapType.normal,
        markers: _markers,
        polylines: _polylines,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.stops[0]['lat'], widget.stops[0]['lng']),
          zoom: 10,
        ),
      ),
    );
  }
}

// New page to show route stops in text form
class RouteTextPage extends StatelessWidget {
  final List<Map<String, dynamic>> stops;

  const RouteTextPage({super.key, required this.stops});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bus Route Stops")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: stops.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  stops[index]['name'],
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
