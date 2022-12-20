import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
// Models
import 'package:flutter_04_map/modules/map/models/_models.dart';
// Services
import 'package:flutter_04_map/modules/map/services/_services.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  TrafficService trafficService;
  SearchBloc({required this.trafficService}) : super(const SearchState()) {
    // Events
    on<SearchEvent>((event, emit) {});
    on<OnActiveManualMarkerEvent>(_onActiveManualMarkerEvent);
    on<OnDesactiveManualMarkerEvent>(_onDesactiveManualMarkerEvent);
    on<OnNewPlacesFoundEvent>(_onNewPlacesFoundEvent);
    on<OnNewSearchedPlace>(_onNewSearchedPlace);
  }

  // Functions events

  _onActiveManualMarkerEvent(
      OnActiveManualMarkerEvent event, Emitter<SearchState> emit) {
    emit(state.copyWith(displayManualMarker: true));
  }

  _onDesactiveManualMarkerEvent(
      OnDesactiveManualMarkerEvent event, Emitter<SearchState> emit) {
    emit(state.copyWith(displayManualMarker: false));
  }

  _onNewPlacesFoundEvent(
      OnNewPlacesFoundEvent event, Emitter<SearchState> emit) {
    emit(state.copyWith(places: event.places));
  }

  _onNewSearchedPlace(OnNewSearchedPlace event, Emitter<SearchState> emit) {
    final searchedPlaces = state.searchedPlaces.map((e) => e).toList();
    searchedPlaces.insert(0, event.searchedPlace);
    emit(state.copyWith(searchedPlaces: searchedPlaces));
  }

  // Functions

  Future<RouteDestination?> getCoorsStartToEnd(LatLng start, LatLng end) async {
    try {
      final trafficResponse =
          await trafficService.getCoorsStartToEnd(start, end);
      final distance = trafficResponse.routes[0].distance;
      final duration = trafficResponse.routes[0].duration;
      final geometry = trafficResponse.routes[0].geometry;

      // Destiny info
      final endPlace = await trafficService.getInformationByCoords(end);

      // Decode geometry
      final polylines = decodePolyline(geometry, accuracyExponent: 6);
      final latLngList = polylines
          .map((coords) => LatLng(coords[0].toDouble(), coords[1].toDouble()))
          .toList();

      final route = RouteDestination(
          points: latLngList,
          duration: duration,
          distance: distance,
          endPLace: endPlace);
      return route;
    } catch (e) {
      return null;
    }
  }

  Future getPlacesByQuery(LatLng proximity, String query) async {
    final features = await trafficService.getResultsByQuery(proximity, query);
    add(OnNewPlacesFoundEvent(places: features));
  }
}
