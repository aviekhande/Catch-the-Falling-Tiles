import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/env_config.dart';
import '../error/exceptions.dart';
import 'interceptors.dart';

class ApiClient {
  ApiClient({
    http.Client? client,
    List<RequestInterceptor>? requestInterceptors,
    List<ResponseInterceptor>? responseInterceptors,
  })  : _client = client ?? http.Client(),
        _requestInterceptors = requestInterceptors ?? [const LoggingInterceptor()],
        _responseInterceptors =
            responseInterceptors ?? [const LoggingInterceptor()];

  final http.Client _client;
  final List<RequestInterceptor> _requestInterceptors;
  final List<ResponseInterceptor> _responseInterceptors;

  Uri _buildUri(String path, [Map<String, dynamic>? queryParameters]) {
    final baseUrl = EnvConfig.baseUrl;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$baseUrl$cleanPath').replace(
      queryParameters: queryParameters?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  Future<dynamic> get(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = _buildUri(path, queryParameters);
    return _send('GET', uri, headers: headers);
  }

  Future<dynamic> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = _buildUri(path);
    return _send('POST', uri, headers: headers, body: body);
  }

  Future<dynamic> _send(
    String method,
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    try {
      final request = http.Request(method, uri);

      request.headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...?headers,
      });

      if (body != null) {
        request.body = jsonEncode(body);
      }

      var interceptedRequest = request as http.BaseRequest;
      for (final interceptor in _requestInterceptors) {
        interceptedRequest = await interceptor.onRequest(interceptedRequest);
      }

      final streamedResponse = await _client
          .send(interceptedRequest)
          .timeout(EnvConfig.connectTimeout);

      var response = await http.Response.fromStream(streamedResponse);

      for (final interceptor in _responseInterceptors) {
        response = await interceptor.onResponse(response);
      }

      return _handleResponse(response);
    } on SocketException catch (e) {
      throw NetworkException(message: 'Network error: ${e.message}');
    } on TimeoutException {
      throw const NetworkException(message: 'Request timed out.');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      try {
        return jsonDecode(response.body);
      } catch (_) {
        return response.body;
      }
    } else {
      String errorMessage = 'Request failed with status: ${response.statusCode}';
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded.containsKey('message')) {
          errorMessage = decoded['message'].toString();
        }
      } catch (_) {
        if (response.body.isNotEmpty) {
          errorMessage = response.body;
        }
      }
      throw ServerException(
        message: errorMessage,
        statusCode: response.statusCode,
      );
    }
  }

  void close() {
    _client.close();
  }
}
