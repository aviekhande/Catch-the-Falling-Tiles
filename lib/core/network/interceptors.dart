import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/env_config.dart';

abstract class RequestInterceptor {
  Future<http.BaseRequest> onRequest(http.BaseRequest request);
}

abstract class ResponseInterceptor {
  Future<http.Response> onResponse(http.Response response);
}

class LoggingInterceptor implements RequestInterceptor, ResponseInterceptor {
  const LoggingInterceptor();

  @override
  Future<http.BaseRequest> onRequest(http.BaseRequest request) async {
    if (EnvConfig.enableLogging) {
      debugPrint('[HTTP Request] ${request.method} ${request.url}');
      if (request.headers.isNotEmpty) {
        debugPrint('[HTTP Headers] ${request.headers}');
      }
    }
    return request;
  }

  @override
  Future<http.Response> onResponse(http.Response response) async {
    if (EnvConfig.enableLogging) {
      debugPrint(
        '[HTTP Response] ${response.statusCode} from ${response.request?.url}',
      );
    }
    return response;
  }
}
