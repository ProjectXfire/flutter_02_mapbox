import 'package:dio/dio.dart';
import 'package:flutter_04_map/modules/map/services/traffic.dart';

class PlacesInterceptorService extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters
        .addAll({"language": "en", "access_token": accessToken});
    super.onRequest(options, handler);
  }
}
