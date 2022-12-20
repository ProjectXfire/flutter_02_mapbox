import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription? _streamSubcription;

  LocationBloc() : super(const LocationState()) {
    // Listeners events
    on<LocationEvent>((event, emit) {});
    on<OnNewUserLocationEvent>((event, emit) {
      emit(state.copyWith(
          lastKnownLocation: event.newLocation,
          locationHistory: [...state.locationHistory, event.newLocation]));
    });
    on<OnStartFollowingUserEvent>((event, emit) {
      emit(state.copyWith(followingUser: true));
    });
    on<OnStopFollowingUserEvent>((event, emit) {
      emit(state.copyWith(followingUser: false));
    });
  }

  Future getCurrentPosition() async {
    final isEnable = await Geolocator.isLocationServiceEnabled();
    if (!isEnable) return;
    final position = await Geolocator.getCurrentPosition();
    add(OnNewUserLocationEvent(LatLng(position.latitude, position.longitude)));
  }

  void startFollowingUser() {
    add(OnStartFollowingUserEvent());
    _streamSubcription = Geolocator.getPositionStream().listen((event) {
      final position = event;
      add(OnNewUserLocationEvent(
          LatLng(position.latitude, position.longitude)));
    })
      ..onError((e) => print("Error: $e"));
  }

  clearSubscription() async {
    add(OnStopFollowingUserEvent());
    _streamSubcription?.cancel();
  }
}
