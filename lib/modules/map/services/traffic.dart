import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
// Models
import 'package:flutter_04_map/modules/map/models/_models.dart';
// Interceptors
import 'package:flutter_04_map/modules/map/services/_services.dart';

const accessToken = "MAPBOX_API_KEY";

class TrafficService {
  TrafficService()
      : _dioTraffic = Dio()..interceptors.add(TrafficInterceptorService()),
        _dioPlaces = Dio()..interceptors.add(PlacesInterceptorService());

  final Dio _dioTraffic;
  final Dio _dioPlaces;
  final String _baseTrafficURL = "https://api.mapbox.com/directions/v5/mapbox";
  final String _basePlacesUrl =
      "https://api.mapbox.com/geocoding/v5/mapbox.places";

  Future<TrafficResponse> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final coorsString =
        "${start.longitude},${start.latitude};${end.longitude},${end.latitude}";
    final url = "$_baseTrafficURL/driving/$coorsString";

    final resp = await _dioTraffic.get(url);
    final data = TrafficResponse.fromMap(resp.data);
    return data;
  }

  Future<List<Feature>> getResultsByQuery(
      LatLng proximity, String query) async {
    if (query.isEmpty) return [];
    final url = '$_basePlacesUrl/$query.json';
    final resp = await _dioPlaces.get(url, queryParameters: {
      "proximity": '${proximity.longitude},${proximity.latitude}',
      "limit": 10
    });
    final placesResponse = PlacesResponse.fromMap(resp.data);
    return placesResponse.features;
  }

  Future<Feature?> getInformationByCoords(LatLng coords) async {
    try {
      final url = '$_basePlacesUrl/${coords.longitude},${coords.latitude}.json';
      final resp = await _dioPlaces.get(url, queryParameters: {"limit": 1});
      final placesResponse = PlacesResponse.fromMap(resp.data);
      return placesResponse.features[0];
    } catch (e) {
      print(e);
      return null;
    }
  }
}
