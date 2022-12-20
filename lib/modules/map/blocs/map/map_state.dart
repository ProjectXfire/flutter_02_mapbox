part of 'map_bloc.dart';

class MapState extends Equatable {
  const MapState(
      {this.isMapInitialized = false,
      this.isfollowingUser = true,
      this.showRoute = true,
      Map<String, Marker>? markers,
      Map<String, Polyline>? polylines})
      : polylines = polylines ?? const {},
        markers = markers ?? const {};

  final bool isMapInitialized;
  final bool isfollowingUser;
  final bool showRoute;
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

  @override
  List<Object> get props =>
      [isMapInitialized, isfollowingUser, polylines, showRoute, markers];

  copyWith(
      {bool? isMapInitialized,
      bool? isfollowingUser,
      bool? showRoute,
      Map<String, Polyline>? polylines,
      Map<String, Marker>? markers}) {
    return MapState(
        polylines: polylines ?? this.polylines,
        markers: markers ?? this.markers,
        isMapInitialized: isMapInitialized ?? this.isMapInitialized,
        showRoute: showRoute ?? this.showRoute,
        isfollowingUser: isfollowingUser ?? this.isfollowingUser);
  }
}
