// Models
import 'package:flutter_04_map/modules/shared/models/_models.dart';
// Screens
import 'package:flutter_04_map/modules/map/screens/_screens.dart';

class MapRoutes {
  static final routes = <RouteModel>[
    RouteModel(routeName: "map", screen: const MapScreen()),
    RouteModel(routeName: "gps_access", screen: const GPSScreen()),
    RouteModel(routeName: "loading", screen: const LoadingScreen()),
    RouteModel(routeName: "test_marker", screen: const TestMarkerScreen())
  ];
}
