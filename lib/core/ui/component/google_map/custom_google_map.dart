import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends ConsumerWidget {
  final CameraPosition initialPosition;
  final void Function(GoogleMapController) onMapCreated;
  final Set<Marker> markers; // ✅ Set<Marker>로 변경

  const CustomGoogleMap({
    super.key,
    required this.initialPosition,
    required this.onMapCreated,
    required this.markers, // ✅ 단일 Marker → Set<Marker>
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GoogleMap(
      key: key,
      mapType: MapType.normal,
      initialCameraPosition: initialPosition,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      markers: markers, //
      onMapCreated: onMapCreated,
    );
  }
}

// class CustomGoogleMap extends ConsumerWidget {
//   // final Circle circle;
//   final Marker marker;
//   final ValueKey valueKey;
//   final CameraPosition initialPosition;
//   final MapCreatedCallback onMapCreated;
//
//   const CustomGoogleMap(
//       {super.key,
//       required this.initialPosition,
//       required this.onMapCreated,
//       required this.valueKey,
//       required this.marker});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return GoogleMap(
//       key: key,
//       mapType: MapType.normal,
//       initialCameraPosition: initialPosition,
//       myLocationEnabled: true,
//       myLocationButtonEnabled: false,
//       // circles: Set.from([circle]),
//       markers: Set.from([marker]),
//       onMapCreated: onMapCreated,
//     );
//   }
// }
