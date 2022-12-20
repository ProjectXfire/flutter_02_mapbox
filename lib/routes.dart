// Models
// Models
import 'package:flutter/material.dart';
import 'package:flutter_04_map/modules/shared/models/_models.dart';
// Routes
import 'package:flutter_04_map/modules/map/routes.dart';

class AppRoutes {
  static final appRoutes = <RouteModel>[...MapRoutes.routes];

  static Map<String, Widget Function(BuildContext)> generateRoutes() {
    Map<String, Widget Function(BuildContext)> routes = {};
    for (var route in appRoutes) {
      routes.addAll({route.routeName: (ctx) => route.screen});
    }
    return routes;
  }
}
