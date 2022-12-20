part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapInitializedMap extends MapEvent {
  final GoogleMapController controller;

  const OnMapInitializedMap(this.controller);
}

class OnToggleFollowingUserEvent extends MapEvent {
  final bool toggleValue;

  const OnToggleFollowingUserEvent({required this.toggleValue});
}

class UpdateUserPolylinesEvent extends MapEvent {
  final List<LatLng> userLocations;

  const UpdateUserPolylinesEvent(this.userLocations);
}

class DrawPolylinesEvent extends MapEvent {
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

  const DrawPolylinesEvent({required this.polylines, required this.markers});
}

class OnToggleRouteEvent extends MapEvent {
  const OnToggleRouteEvent();
}
