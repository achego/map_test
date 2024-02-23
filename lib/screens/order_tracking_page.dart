import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  // final Completer<GoogleMapController> mapController = Completer();
  late GoogleMapController mapController;

  static const LatLng source = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33, -122.03);
  final LatLng center = const LatLng(-23.5557714, -46.6395571);

  _onMapCreated(GoogleMapController controller) {
    logger('Map don create o');
    logger('The Controller ', message: controller.mapId);
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Tracking things')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: center, zoom: 11),
        markers: {const Marker(markerId: MarkerId('source'), position: source)},
      ),
    );
  }
}

logger(String title, {dynamic message}) {
  log("[$title] ===== $message");
}
