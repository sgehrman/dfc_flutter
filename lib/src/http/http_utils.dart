import 'dart:async';

import 'package:http/http.dart' as http;

class HttpUtils {
  HttpUtils._();

  static Future<http.Response> httpGet(
    Uri uri, {
    int timeout = 10,
  }) {
    try {
      return http.get(uri).timeout(Duration(seconds: timeout));
    } on TimeoutException catch (err) {
      print('### Error(http.get): TimeoutException err:$err url: $uri');
      rethrow;
    } catch (err) {
      print('### Error(http.get): err:$err url: $uri');
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
    int timeout = 10,
  }) async {
    String receivedCookies = '';
    Uri getUri = uri;

    const int movedTemporarily = 302; // HttpStatus.movedTemporarily
    const int redirect = 301; // HttpStatus.redirect
    const int ok = 200; // HttpStatus.ok
    int loops = 12;
    http.Client? client;

    try {
      bool isRedirect = true;

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

            String newUrl = url;

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
            final result = await response.stream.bytesToString();

            return result;
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
