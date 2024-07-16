import 'dart:developer';
import 'package:http/http.dart' as http;
import 'api_urls.dart';

class ApiBase {
  static url({required String extendedURL}) {
    log("https://${ApiUrl.baseUrl}$extendedURL");

    return Uri.parse("https://${ApiUrl.baseUrl}$extendedURL");
  }

  static Future<http.Response> getRequest(
      {required String extendedURL, String? token}) async {
    var client = http.Client();
    Map<String, String> newHeaders = {};
    Map<String, String> conentType = {'Content-Type': 'application/json'};

    newHeaders.addAll(conentType);
    log(newHeaders.toString());
    return client.get(url(extendedURL: extendedURL.trim()),
        headers: newHeaders);
  }
}
