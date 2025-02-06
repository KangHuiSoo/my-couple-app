import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatelessWidget {
  // final Circle circle;
  // final Marker marker;
  final CameraPosition initialPosition;
  final MapCreatedCallback onMapCreated;

  const CustomGoogleMap(
      {super.key,
      // required this.circle,
      required this.initialPosition,
      // required this.marker,
      required this.onMapCreated});

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: initialPosition,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      // circles: Set.from([circle]),
      // markers: Set.from([marker]),
      onMapCreated: onMapCreated,
    );
  }
}
