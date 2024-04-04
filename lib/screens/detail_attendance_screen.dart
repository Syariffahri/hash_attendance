import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../models/attendance_model.dart';

class DetailAttendanceScreen extends StatefulWidget {
  const DetailAttendanceScreen({super.key});

  @override
  State<DetailAttendanceScreen> createState() => _DetailAttendanceScreenState();
}

class _DetailAttendanceScreenState extends State<DetailAttendanceScreen> {
  Attendance detail = Get.arguments;
  late GoogleMapController mapController;

  // MASTER DATA
  final LatLng _center = const LatLng(-6.1707388, 106.8133555);

  final Set<Circle> _circles = {
    Circle(
      strokeWidth: 2,
      fillColor: Colors.greenAccent.withOpacity(0.3),
      strokeColor: Colors.greenAccent,
      circleId: const CircleId('center'),
      center: const LatLng(-6.1707388, 106.8133555),
      radius: 50,
    )
  };

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('center'),
      position: LatLng(-6.1707388, 106.8133555),
      infoWindow: InfoWindow(
        title: 'Attendance point',
        snippet: 'HashMicro | Provider Software ERP Terbaik Indonesia',
      ),
    ),
  };

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('detail'),
          position: LatLng(detail.latitude, detail.longitude),
          infoWindow: InfoWindow(
            title: 'Attendance location - ${detail.name}',
            snippet:
                'Attended at: ${DateFormat('dd MMM y H:mm:ss').format(detail.createdAt)}',
          ),
        ),
      );
    });
  }

  double calculateDistance() => Geolocator.distanceBetween(
      _center.latitude, _center.longitude, detail.latitude, detail.longitude);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Attendance')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GoogleMap(
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 18,
              ),
              circles: _circles,
              markers: _markers,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Details',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  detail.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(DateFormat('dd MMM y H:mm:ss').format(detail.createdAt)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(
                      width: 120,
                      child: Text(
                        'Latitude',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(detail.latitude.toString()),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 120,
                      child: Text(
                        'Longitude',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(detail.longitude.toString()),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      '${calculateDistance().toStringAsFixed(0)} meters ',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Text('from attendance point'),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
