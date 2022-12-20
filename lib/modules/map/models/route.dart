import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
// Models
import 'package:flutter_04_map/modules/map/models/_models.dart';

class RouteDestination {
  final List<LatLng> points;
  final double duration;
  final double distance;
  final Feature? endPLace;

  RouteDestination(
      {required this.points,
      required this.duration,
      required this.distance,
      this.endPLace});
}
