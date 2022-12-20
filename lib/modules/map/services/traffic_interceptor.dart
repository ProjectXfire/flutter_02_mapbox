import 'package:dio/dio.dart';
import 'package:flutter_04_map/modules/map/services/traffic.dart';

class TrafficInterceptorService extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      "alternatives": true,
      "geometries": "polyline6",
      "overview": "simplified",
      "steps": false,
      "access_token": accessToken
    });
    super.onRequest(options, handler);
  }
}
