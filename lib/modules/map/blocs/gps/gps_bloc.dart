import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  StreamSubscription? _streamSubscription;

  GpsBloc()
      : super(const GpsState(
            isGpsEnabled: false, isGpsPermissionGranted: false)) {
    on<GpsEvent>((event, emit) {});
    on<GpsAndPermissionEvent>(
      (event, emit) {
        emit(state.copyWith(
            isGpsEnabled: event.isGpsEnabled,
            isGpsPermissionGranted: event.isGpsPermissionGranted));
      },
    );
    _initGeoAndPermissions();
  }

  Future<void> _initGeoAndPermissions() async {
    final status =
        await Future.wait([_checkGpsStatus(), _isPermissionGranted()]);
    add(GpsAndPermissionEvent(
        isGpsEnabled: status[0], isGpsPermissionGranted: status[1]));
  }

  Future<bool> _checkGpsStatus() async {
    final isEnable = await Geolocator.isLocationServiceEnabled();
    _streamSubscription = Geolocator.getServiceStatusStream().listen((event) {
      final gpsStatus = event.index == 1 ? true : false;
      add(GpsAndPermissionEvent(
          isGpsEnabled: gpsStatus,
          isGpsPermissionGranted: state.isGpsPermissionGranted));
    });
    return isEnable;
  }

  Future<bool> _isPermissionGranted() async {
    final isGranted = await Permission.location.isGranted;
    return isGranted;
  }

  Future<void> requestGpsAccess() async {
    final status = await Permission.location.request();
    switch (status) {
      case PermissionStatus.granted:
        add(GpsAndPermissionEvent(
            isGpsEnabled: state.isGpsEnabled, isGpsPermissionGranted: true));
        break;
      default:
        add(GpsAndPermissionEvent(
            isGpsEnabled: state.isGpsEnabled, isGpsPermissionGranted: false));
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
