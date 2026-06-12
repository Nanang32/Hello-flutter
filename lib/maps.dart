import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leaflet Map Flutter"),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(-5.110523272930694, 119.50403063761532),
          initialZoom: 15,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(-5.117006340525241, 119.51301610029047),
                width: 80,
                height: 80,
                child: const Icon(
                  Icons.location_pin,
                  color: Color.fromARGB(255, 89, 54, 244),
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}