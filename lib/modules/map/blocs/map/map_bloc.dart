import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_04_map/modules/shared/helpers/_helpers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// Models
import 'package:flutter_04_map/modules/map/models/_models.dart';
// Providers
import 'package:flutter_04_map/modules/map/blocs/blocs.dart';
// Map themes
import 'package:flutter_04_map/modules/map/themes/_themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  GoogleMapController? _mapController;
  StreamSubscription? _mapSubscription;
  LatLng? mapCenter;
  final LocationBloc locationBloc;

  MapBloc({required this.locationBloc}) : super(const MapState()) {
    // Events
    on<OnMapInitializedMap>(_onInitMap);
    on<OnToggleFollowingUserEvent>(_onToggleFollowingUser);
    on<UpdateUserPolylinesEvent>(_onUpdateUserPolylines);
    on<OnToggleRouteEvent>(_onToggleRoute);
    on<DrawPolylinesEvent>(_onDrawPolylines);
    // Stream
    _mapSubscription = locationBloc.stream.listen((event) {
      if (event.lastKnownLocation != null) {
        add(UpdateUserPolylinesEvent(event.locationHistory));
      }
      if (!state.isfollowingUser) return;
      if (event.lastKnownLocation == null) return;
      moveCamera(event.lastKnownLocation!);
    });
  }

  // Functions events

  _onInitMap(OnMapInitializedMap event, Emitter<MapState> emit) {
    _mapController = event.controller;
    _mapController!.setMapStyle(jsonEncode(blueTacticalTheme));
    emit(state.copyWith(isMapInitialized: true));
  }

  _onToggleFollowingUser(
      OnToggleFollowingUserEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(isfollowingUser: event.toggleValue));
    if (locationBloc.state.lastKnownLocation == null) return;
    moveCamera(locationBloc.state.lastKnownLocation!);
  }

  _onUpdateUserPolylines(
      UpdateUserPolylinesEvent event, Emitter<MapState> emit) {
    final myRoute = Polyline(
        polylineId: const PolylineId("myRoute"),
        color: Colors.white,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        points: event.userLocations);
    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines["myRoute"] = myRoute;
    emit(state.copyWith(polylines: currentPolylines));
  }

  _onToggleRoute(OnToggleRouteEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(showRoute: !state.showRoute));
  }

  _onDrawPolylines(DrawPolylinesEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(polylines: event.polylines, markers: event.markers));
  }

  // Others functions

  drawRoutePolyline(RouteDestination routeDestination) async {
    // -> Draw route
    final myRoute = Polyline(
      polylineId: const PolylineId("route"),
      color: Colors.white,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      points: routeDestination.points,
    );
    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines["route"] = myRoute;

    double kms =
        ((routeDestination.distance / 1000) * 100).floorToDouble() / 100;
    double tripDuration = (routeDestination.duration / 60).floorToDouble();

    // -> Markers
    final endPLace = routeDestination.endPLace;
    //final customStartMarker = await getAssetImageMarker();
    //final customEndMarker = await getNetworkImageMarker();

    if (endPLace != null) {
      final customStartMarker = await getStartCustomMarker(
        tripDuration.toInt(),
        "Start",
      );
      final customEndMarker =
          await getEndCustomMarker(kms.toInt(), endPLace.placeName);

      final startMarker = Marker(
          markerId: const MarkerId("start"),
          position: routeDestination.points.first,
          anchor: const Offset(0.05, 1),
          icon: customStartMarker,
          infoWindow: InfoWindow(
              title: "Start", snippet: "Kms: $kms, minutes: $tripDuration"));
      final endMarker = Marker(
          markerId: const MarkerId("end"),
          position: routeDestination.points.last,
          icon: customEndMarker,
          infoWindow: InfoWindow(title: endPLace.text, snippet: endPLace.text));
      final currentMarkers = Map<String, Marker>.from(state.markers);
      currentMarkers['start'] = startMarker;
      currentMarkers["end"] = endMarker;

      // -> Update state
      add(DrawPolylinesEvent(
          polylines: currentPolylines, markers: currentMarkers));
      Future.delayed(const Duration(milliseconds: 300)).then((value) =>
          _mapController?.showMarkerInfoWindow(const MarkerId("start")));
    }
  }

  clearMapSubscription() {
    _mapSubscription?.cancel();
  }

  moveCamera(LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
  }
}
