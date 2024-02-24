import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map_test/utils/constants.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  @override
  void initState() {
    super.initState();
    _getPolylinePoints();
    _getCurrentLoation();
  }

  late GoogleMapController mapController;

  static  LatLng source = LatLng(6.45659702205736, 3.527847715407704);
  static  LatLng destination =
      LatLng(6.457235513826116, 3.524065745247388);
  final LatLng center = const LatLng(6.457294, 3.527354);

  final List<LatLng> points = [];
  final List<LatLng> alternates = [];

  double zoomLevel = 10;
  double sourceRotVal = 0;

  LocationData? locationData;

  _getCurrentLoation() async {
    Location location = Location();
    final currentLocal = await location.getLocation();
    locationData = currentLocal;
    source = LatLng(locationData!.latitude!, locationData!.latitude!);
    destination = LatLng(locationData!.latitude! + 0.02, locationData!.latitude!+0.003);
    logger('My Location ===========',
        message: '${locationData!.latitude!}, ${locationData!.longitude!}');
    setState(() {});
  }

  _rotateSource() async {
    const rotAngle = 560;
    if (sourceRotVal <= rotAngle) {
      sourceRotVal += 2;
      await Future.delayed(Duration(milliseconds: 1));
      _rotateSource();
    } else {
      sourceRotVal = rotAngle - 360;
    }
    setState(() {});
  }

  _onMapCreated(GoogleMapController controller) {
    logger('Map don create o');
    logger('The Controller ', message: controller.mapId);
    mapController = controller;
    // controller.moveCamera(Cam);
  }

  _getPolylinePoints() async {
    PolylinePoints polyPoints = PolylinePoints();
    final result = await polyPoints.getRouteBetweenCoordinates(
        Constatnts.apiKey,
        PointLatLng(source.latitude, source.longitude),
        PointLatLng(destination.latitude, destination.longitude));
    logger('Duration', message: result.duration);
    logger('Distance', message: result.distance);
    logger('Start address', message: result.startAddress);
    logger('End address', message: result.endAddress);

    // logger('Point Langs ', message: '===================');
    // logger('Point Langs ', message: '===================');
    // logger('Point Langs ', message: '===================');
    // logger('Point Langs ', message: '===================');
    for (var element in result.points) {
      points.add(LatLng(element.latitude, element.longitude));
      // logger(element.latitude.toString(), message: element.longitude);
    }
    logger('Alternatives Langs ', message: '===================');
    for (var element in result.alternatives) {
      alternates.add(LatLng(element.latitude, element.longitude));
      // logger(element.latitude.toString(), message: element.longitude);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Tracking things')),
      body: locationData == null
          ? Center(
              child: Text('Getting Location'),
            )
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  polylines: {
                    Polyline(
                        polylineId: PolylineId('main_route'),
                        points: points,
                        color: Colors.green,
                        endCap: Cap.roundCap,
                        startCap: Cap.roundCap,
                        jointType: JointType.round,
                        width: 5,
                        zIndex: 20),
                    Polyline(
                        polylineId: PolylineId('alt_route'),
                        points: alternates,
                        color: Colors.red,
                        endCap: Cap.roundCap),
                  },
                  initialCameraPosition:
                      CameraPosition(target: source, zoom: 17),
                  markers: {
                    Marker(
                        markerId: MarkerId('source'),
                        position: source,
                        draggable: true,
                        rotation: sourceRotVal),
                    Marker(
                        markerId: MarkerId('current_location'),
                        position: LatLng(
                            locationData!.latitude!, locationData!.longitude!),
                        draggable: true,
                        rotation: sourceRotVal),
                     Marker(
                        markerId: MarkerId('destination'),
                        position: destination),
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            TextButton(
                                onPressed: _rotateSource,
                                child: Text('Rotate Source'))
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}

logger(String title, {dynamic message}) {
  log("[$title] ===== $message");
}
