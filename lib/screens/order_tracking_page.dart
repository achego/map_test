import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> mapController = Completer();
  static const LatLng source = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33, -122.03);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Tracking things')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(target: source, zoom: 14.4),
        markers: {const Marker(markerId: MarkerId('source'), position: source)},
      ),
    );
  }
}
