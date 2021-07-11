import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as io_client;

import 'common.dart';
import 'event.dart';

enum RequestBodyEncoding { json, formURLEncoded, plainText }
enum HttpMethod { get, put, patch, post, delete, head }

class Response {
  Response(this._rawResponse);

  final http.Response _rawResponse;

  int get statusCode => _rawResponse.statusCode;

  bool get hasError => (400 <= statusCode) && (statusCode < 600);

  bool get success => !hasError;

  Uri get url => _rawResponse.request!.url;

  void throwForStatus() {
    if (!success) {
      throw HTTPException(
          'Invalid HTTP status code $statusCode for url $url', this);
    }
  }

  void raiseForStatus() {
    throwForStatus();
  }

  List<int> bytes() {
    return _rawResponse.bodyBytes;
  }

  String content() {
    return utf8.decode(bytes(), allowMalformed: true);
  }

  dynamic json() {
    return Common.fromJson(content());
  }
}

class HTTPException implements Exception {
  HTTPException(this.message, this.response);

  final String message;
  final Response response;
}

class Requests {
  const Requests();

  static final Event onError = Event();
  static const int defaultTimeoutSeconds = 10;

  static const RequestBodyEncoding defaultBodyEncoding =
      RequestBodyEncoding.formURLEncoded;

  static final Set<String> _cookiesKeysToIgnore = {
    'samesite',
    'path',
    'domain',
    'max-age',
    'expires',
    'secure',
    'httponly'
  };

  static Map<String, String> _extractResponseCookies(
      Map<String, String> responseHeaders) {
    final Map<String, String> cookies = {};
    for (final String key in responseHeaders.keys) {
      if (Common.equalsIgnoreCase(key, 'set-cookie')) {
        final String cookie = responseHeaders[key]!;
        cookie.split(',').forEach((String one) {
          one
              .split(';')
              .map((x) => x.trim().split('='))
              .where((x) => x.length == 2)
              .where((x) => !_cookiesKeysToIgnore.contains(x[0].toLowerCase()))
              .forEach((x) => cookies[x[0]] = x[1]);
        });
        break;
      }
    }

    return cookies;
  }

  static Future<Map<String, String>> _constructRequestHeaders(
      String hostname, Map<String, String>? customHeaders) async {
    final cookies = await getStoredCookies(hostname);
    final String cookie =
        cookies.keys.map((key) => '$key=${cookies[key]}').join('; ');
    final Map<String, String> requestHeaders = {};
    requestHeaders['cookie'] = cookie;

    if (customHeaders != null) {
      requestHeaders.addAll(customHeaders);
    }
    return requestHeaders;
  }

  static Future<Map<String, String>> getStoredCookies(String hostname) async {
    try {
      final String hostnameHash = Common.hashStringSHA256(hostname);
      final String? cookiesJson =
          await Common.storageGet('cookies-$hostnameHash');

      if (cookiesJson != null) {
        final Map cookies = Common.fromJson(cookiesJson) as Map;
        return Map<String, String>.from(cookies);
      }

      return <String, String>{};
    } catch (e) {
      print('problem reading stored cookies. fallback with empty cookies $e');
      return <String, String>{};
    }
  }

  static Future setStoredCookies(
      String hostname, Map<String, String> cookies) async {
    final String hostnameHash = Common.hashStringSHA256(hostname);
    final String cookiesJson = Common.toJson(cookies);
    await Common.storageSet('cookies-$hostnameHash', cookiesJson);
  }

  static Future clearStoredCookies(String hostname) async {
    final String hostnameHash = Common.hashStringSHA256(hostname);
    await Common.storageRemove('cookies-$hostnameHash');
  }

  static String getHostname(String url) {
    final uri = Uri.parse(url);
    return '${uri.host}:${uri.port}';
  }

  static Future<Response> _handleHttpResponse(
      String hostname, http.Response rawResponse, bool persistCookies) async {
    if (persistCookies) {
      final responseCookies = _extractResponseCookies(rawResponse.headers);
      if (responseCookies.isNotEmpty) {
        final storedCookies = await getStoredCookies(hostname);
        storedCookies.addAll(responseCookies);
        await setStoredCookies(hostname, storedCookies);
      }
    }
    final response = Response(rawResponse);

    if (response.hasError) {
      final errorEvent = {'response': response};
      onError.publish(errorEvent);
    }

    return response;
  }

  static Future<Response> head(String url,
      {Map<String, String>? headers,
      Map<String, dynamic>? queryParameters,
      int? port,
      RequestBodyEncoding bodyEncoding = defaultBodyEncoding,
      int timeoutSeconds = defaultTimeoutSeconds,
      bool persistCookies = true,
      bool verify = true}) {
    return _httpRequest(
      HttpMethod.head,
      url,
      bodyEncoding: bodyEncoding,
      queryParameters: queryParameters,
      port: port,
      headers: headers,
      timeoutSeconds: timeoutSeconds,
      persistCookies: persistCookies,
      verify: verify,
    );
  }

  static Future<Response> get(String url,
      {Map<String, String>? headers,
      Map<String, dynamic>? queryParameters,
      int? port,
      RequestBodyEncoding bodyEncoding = defaultBodyEncoding,
      int timeoutSeconds = defaultTimeoutSeconds,
      bool persistCookies = true,
      bool verify = true}) {
    return _httpRequest(
      HttpMethod.get,
      url,
      bodyEncoding: bodyEncoding,
      queryParameters: queryParameters,
      port: port,
      headers: headers,
      timeoutSeconds: timeoutSeconds,
      persistCookies: persistCookies,
      verify: verify,
    );
  }

  static Future<Response> patch(String url,
      {Map<String, String>? headers,
      int? port,
      Map<String, dynamic>? json,
      dynamic body,
      Map<String, dynamic>? queryParameters,
      RequestBodyEncoding bodyEncoding = defaultBodyEncoding,
      int timeoutSeconds = defaultTimeoutSeconds,
      bool persistCookies = true,
      bool verify = true}) {
    return _httpRequest(
      HttpMethod.patch,
      url,
      bodyEncoding: bodyEncoding,
      port: port,
      json: json,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      timeoutSeconds: timeoutSeconds,
      persistCookies: persistCookies,
      verify: verify,
    );
  }

  static Future<Response> delete(String url,
      {Map<String, String>? headers,
      Map<String, dynamic>? json,
      dynamic body,
      Map<String, dynamic>? queryParameters,
      int? port,
      RequestBodyEncoding bodyEncoding = defaultBodyEncoding,
      int timeoutSeconds = defaultTimeoutSeconds,
      bool persistCookies = true,
      bool verify = true}) {
    return _httpRequest(
      HttpMethod.delete,
      url,
      bodyEncoding: bodyEncoding,
      port: port,
      json: json,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      timeoutSeconds: timeoutSeconds,
      persistCookies: persistCookies,
      verify: verify,
    );
  }

  static Future<Response> post(String url,
      {Map<String, dynamic>? json,
      int? port,
      Map<String, dynamic>? body,
      Map<String, dynamic>? queryParameters,
      RequestBodyEncoding bodyEncoding = defaultBodyEncoding,
      Map<String, String>? headers,
      int timeoutSeconds = defaultTimeoutSeconds,
      bool persistCookies = true,
      bool verify = true}) {
    return _httpRequest(
      HttpMethod.post,
      url,
      bodyEncoding: bodyEncoding,
      json: json,
      port: port,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      timeoutSeconds: timeoutSeconds,
      persistCookies: persistCookies,
      verify: verify,
    );
  }

  static Future<Response> put(
    String url, {
    int? port,
    Map<String, dynamic>? json,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    RequestBodyEncoding bodyEncoding = defaultBodyEncoding,
    Map<String, String>? headers,
    int timeoutSeconds = defaultTimeoutSeconds,
    bool persistCookies = true,
    bool verify = true,
  }) {
    return _httpRequest(
      HttpMethod.put,
      url,
      port: port,
      bodyEncoding: bodyEncoding,
      json: json,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      timeoutSeconds: timeoutSeconds,
      persistCookies: persistCookies,
      verify: verify,
    );
  }

  static Future<Response> _httpRequest(
    HttpMethod method,
    String url, {
    dynamic json,
    dynamic body,
    RequestBodyEncoding bodyEncoding = defaultBodyEncoding,
    Map<String, dynamic>? queryParameters,
    int? port,
    Map<String, String>? headers,
    int timeoutSeconds = defaultTimeoutSeconds,
    bool persistCookies = true,
    bool verify = true,
  }) async {
    dynamic localBody = body;
    RequestBodyEncoding localBodyEncoding = bodyEncoding;
    Map<String, String>? localHeaders = headers;

    http.Client client;
    if (!verify) {
      // Ignore SSL errors
      final ioClient = HttpClient();
      ioClient.badCertificateCallback = (_, __, ___) => true;
      client = io_client.IOClient(ioClient);
    } else {
      // The default client validates SSL certificates and fail if invalid
      client = http.Client();
    }

    Uri uri = Uri.parse(url);

    if (uri.scheme != 'http' && uri.scheme != 'https') {
      throw ArgumentError(
          "invalid url, must start with 'http://' or 'https://' sheme (e.g. 'http://example.com')");
    }

    final String hostname = getHostname(url);
    localHeaders = await _constructRequestHeaders(hostname, localHeaders);
    String? requestBody;

    if (localBody != null && json != null) {
      throw ArgumentError("cannot use both 'json' and 'body' choose only one.");
    }

    if (queryParameters != null) {
      uri = uri.replace(queryParameters: queryParameters);
    }

    if (port != null) {
      uri = uri.replace(port: port);
    }

    if (json != null) {
      localBody = json;
      localBodyEncoding = RequestBodyEncoding.json;
    }

    if (localBody != null) {
      String contentTypeHeader;

      switch (localBodyEncoding) {
        case RequestBodyEncoding.json:
          requestBody = Common.toJson(localBody);
          contentTypeHeader = 'application/json';
          break;
        case RequestBodyEncoding.formURLEncoded:
          requestBody = Common.encodeMap(localBody as Map);
          contentTypeHeader = 'application/x-www-form-urlencoded';
          break;
        case RequestBodyEncoding.plainText:
          requestBody = localBody as String;
          contentTypeHeader = 'text/plain';
          break;
      }

      if (!Common.hasKeyIgnoreCase(localHeaders, 'content-type')) {
        localHeaders['content-type'] = contentTypeHeader;
      }
    }

    late Future future;

    switch (method) {
      case HttpMethod.get:
        future = client.get(uri, headers: localHeaders);
        break;
      case HttpMethod.put:
        future = client.put(uri, body: requestBody, headers: localHeaders);
        break;
      case HttpMethod.delete:
        final request = http.Request('DELETE', uri);
        request.headers.addAll(localHeaders);

        if (requestBody != null) {
          request.body = requestBody;
        }

        future = client.send(request);
        break;
      case HttpMethod.post:
        future = client.post(uri, body: requestBody, headers: localHeaders);
        break;
      case HttpMethod.head:
        future = client.head(uri, headers: localHeaders);
        break;
      case HttpMethod.patch:
        future = client.patch(uri, body: requestBody, headers: localHeaders);
        break;
    }

    dynamic response = await future.timeout(Duration(seconds: timeoutSeconds));

    if (response is http.StreamedResponse) {
      response = await http.Response.fromStream(response);
    }

    return _handleHttpResponse(
        hostname, response as http.Response, persistCookies);
  }
}
