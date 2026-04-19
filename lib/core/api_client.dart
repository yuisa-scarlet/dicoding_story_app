import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiInterceptor extends http.BaseClient {
  final http.Client _inner;

  ApiInterceptor(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    const head = '----------------------- REQUEST -----------------------';
    final name = 'Request - ${request.url.path}';

    log(head, name: name);
    final body = request is http.Request ? request.body : "can't mapped";
    log(body, name: name);

    final response = await _inner.send(request);

    const responseHead =
        '----------------------- RESPONSE -----------------------';
    final responseName = 'Response - ${request.url.path}';

    log(responseHead, name: responseName);

    final responseBody = await response.stream.bytesToString();
    log(responseBody, name: responseName);

    return http.StreamedResponse(
      Stream.value(responseBody.codeUnits),
      response.statusCode,
      headers: response.headers,
      request: request,
    );
  }
}

abstract class BaseApiClient {
  static http.Client _createClient(String baseUrl) {
    final client = http.Client();
    final inner = kDebugMode ? ApiInterceptor(client) : client;

    return _ConfiguredClient(inner, baseUrl);
  }
}

class _ConfiguredClient extends http.BaseClient {
  final http.Client _inner;
  final String _baseUrl;

  _ConfiguredClient(this._inner, this._baseUrl);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/json';

    Uri newUrl = request.url;
    http.BaseRequest newRequest = request;

    if (!newUrl.isAbsolute) {
      String base = _baseUrl.endsWith('/') ? _baseUrl : '$_baseUrl/';
      String path = newUrl.toString();
      if (path.startsWith('/')) path = path.substring(1);
      newUrl = Uri.parse('$base$path');

      if (request is http.Request) {
        newRequest = http.Request(request.method, newUrl)
          ..headers.addAll(request.headers)
          ..bodyBytes = request.bodyBytes
          ..encoding = request.encoding;
      } else if (request is http.MultipartRequest) {
        newRequest = http.MultipartRequest(request.method, newUrl)
          ..headers.addAll(request.headers)
          ..fields.addAll(request.fields)
          ..files.addAll(request.files);
      }
    }

    return _inner.send(newRequest);
  }
}

class ApiClient {
  final http.Client _client;
  String? _token;

  ApiClient({required String baseUrl})
      : _client = BaseApiClient._createClient(baseUrl);

  void setToken(String? token) {
    _token = (token != null && token.isNotEmpty) ? token : null;
  }

  Map<String, String> _authHeader() {
    if (_token != null) return {'Authorization': 'Bearer $_token'};
    return const {};
  }

  Future<http.Response> get(String path) async {
    return _client.get(Uri.parse(path), headers: _authHeader());
  }

  Future<http.Response> post(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final mergedHeaders = {..._authHeader(), ...?headers};
    return _client.post(
      Uri.parse(path),
      body: body,
      headers: mergedHeaders.isEmpty ? null : mergedHeaders,
    );
  }

  Future<http.Response> multipartPost(
    String path, {
    required Map<String, String> fields,
    required List<http.MultipartFile> files,
    Map<String, String>? headers,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse(path));
    request.headers.addAll(_authHeader());
    if (headers != null) request.headers.addAll(headers);
    request.fields.addAll(fields);
    request.files.addAll(files);
    final streamed = await _client.send(request);
    return http.Response.fromStream(streamed);
  }
}
