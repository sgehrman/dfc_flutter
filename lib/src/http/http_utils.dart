import 'dart:async';

import 'package:dfc_flutter/src/http/utf8_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HttpUtils {
  HttpUtils._();

  static bool statusOK(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  static Future<http.Response> httpGet(
    Uri uri, {
    int timeout = 20,
    Map<String, String>? headers,
  }) {
    try {
      return http
          .get(
            uri,
            headers: headers,
          )
          .timeout(Duration(seconds: timeout));
    } on TimeoutException catch (err) {
      print('### Error(http.get): TimeoutException err:$err url: $uri');
      rethrow;
    } catch (err) {
      print('### Error(http.get): err:$err url: $uri');
      rethrow;
    }
  }

  static Future<String> httpGetBody(
    Uri uri, {
    int timeout = 20,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await httpGet(
        uri,
        timeout: timeout,
        headers: headers,
      );

      return Utf8Utils.decodeUtf8(response);
    } catch (err) {
      print('### Error(http.get): err:$err url: $uri');
    }

    return '';
  }

  // is this better for redirects?
  // this failed for gpt models.  didn't redirect correctly?
  // failed on client close?

  // WARNING: In the browser it doesn't handle redirects
  /// This client inherits some of the limitations of XMLHttpRequest. It ignores
  /// the [BaseRequest.contentLength], [BaseRequest.persistentConnection],
  /// [BaseRequest.followRedirects], and [BaseRequest.maxRedirects] fields. It is
  /// also unable to stream requests or responses; a request will only be sent and
  /// a response will only be returned once all the data is available.

  static Future<Uint8List> httpGetStream(
    Uri uri, {
    Map<String, String> headers = const {},
    int timeout = 20,
  }) async {
    final httpClient = http.Client();

    try {
      final clientRequest = http.Request('GET', uri);
      clientRequest.headers.addAll(headers);

      // follows redirects by default (not for web)
      final response = await httpClient
          .send(clientRequest)
          .timeout(Duration(seconds: timeout));

      if (HttpUtils.statusOK(response.statusCode)) {
        // we want the bytes now before close happens in finally.
        // not sure how to handle this correctly.
        final result = await response.stream.toBytes();

        if (result.isEmpty) {
          print('httpGetStream zero bytes received');
        }

        return result;
      } else {
        print('httpGetStream: status: ${response.statusCode}, url: $uri');
      }
    } on TimeoutException catch (err) {
      print('### Error(httpGetStream): TimeoutException err:$err url: $uri');
    } catch (err) {
      print('### Error(httpGetStream): err:$err url: $uri');
    } finally {
      httpClient.close();
    }

    return Uint8List(0);
  }

  static Future<http.Response> httpHead(
    Uri uri, {
    int timeout = 20,
  }) {
    try {
      return http.head(uri).timeout(Duration(seconds: timeout));
    } on TimeoutException catch (err) {
      print('### Error(http.head): TimeoutException err:$err url: $uri');
      rethrow;
    } catch (err) {
      print('### Error(http.head): err:$err url: $uri');
      rethrow;
    }
  }

  // =============================================================

  // {"error":"Preview failed:  request: http://localhost:8765/?icon=aHR0cHM6Ly91aW8uZWRkLmNhLmdvdi9VSU8vUGFnZXMvUHVibGljL05ld0NsYWltL05ld0NsYWltQ29uZmlybWF0aW9uLmFzcHg="}
  // https://uio.edd.ca.gov/UIO/Pages/Public/NewClaim/NewClaimConfirmation.aspx

  // this way follows redirects, used for scraping websitesZ
  // saved https://stackoverflow.com/questions/51912621/redirect-loop-detected-dart

  static Future<String> httpGetBodyWithRedirects(
    Uri uri, {
    int timeout = 20,
  }) async {
    var receivedCookies = '';
    var getUri = uri;

    const movedTemporarily = 302; // HttpStatus.movedTemporarily
    const redirect = 301; // HttpStatus.redirect
    const ok = 200; // HttpStatus.ok
    var loops = 12;
    http.Client? client;

    try {
      var isRedirect = true;

      while (isRedirect) {
        isRedirect = false;

        // prevent endless loops
        if (--loops < 0) {
          break;
        }

        // close prev client if we are looping
        client?.close();
        client = null;

        client = http.Client();
        final request = http.Request('GET', getUri);
        // the default redirect handling doesn't use the cookie to prevent loops
        request.followRedirects = false;

        if (receivedCookies.isNotEmpty) {
          request.headers['cookie'] = receivedCookies;
        }

        // print(request.headers);
        final response =
            await client.send(request).timeout(Duration(seconds: timeout));

        if (response.statusCode == movedTemporarily ||
            response.statusCode == redirect) {
          final url = response.headers['location'] ?? '';

          if (url.isNotEmpty) {
            isRedirect = response.isRedirect;
            receivedCookies = response.headers['set-cookie'] ?? '';

            var newUrl = url;

            // seems that the relative urls don't always have a leading /
            // Invalid argument(s): No host specified in URI windows/ url: https://www.mamp.info/en
            if (!url.startsWith(RegExp('http', caseSensitive: false))) {
              if (url.startsWith('/')) {
                newUrl = '${getUri.origin}$url';
              } else {
                // seems that when a location like windows/ is sent, we need to append to the original url
                // and assume the original url has a slash at the end?
                if (getUri.toString().endsWith('/')) {
                  newUrl = '$getUri$url';
                } else {
                  newUrl = '$getUri/$url';
                }
              }
            }

            getUri = Uri.parse(newUrl);
          }
        } else if (response.statusCode == ok) {
          try {
            // this can fail if not a string

            // ignore: prefer_immediate_return
            // await so I can client.close() when done
            return await response.stream.bytesToString();
          } catch (err) {
            print(
              '### Error: response.stream.bytesToString: uri: $uri err: $err',
            );
          }

          return '';
        }
      }
    } on TimeoutException catch (err) {
      print(
        '### Error(httpGetBodyWithRedirects): TimeoutException err: $err url: $uri',
      );
    } catch (err) {
      print('### Error(httpGetBodyWithRedirects): err: $err url: $uri');
    } finally {
      client?.close();
      client = null;
    }

    return '';
  }
}
