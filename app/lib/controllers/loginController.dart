import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;


class LoginController {

  static Future<String> loginUser(String url, body) async {
    return http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(body)).then((http.Response response) {
      final int statusCode = response.statusCode;
      print(jsonEncode(body));
      if (statusCode < 200 || statusCode > 400 || json == null) {
        print(statusCode);
        print(json);
        throw new Exception("Error while fetching data");
      }
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse["token"];
    });
  }


  static Future<String> registerUser(String url, body) async {
    return http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(body)).then((http.Response response) {
      final int statusCode = response.statusCode;
      print(jsonEncode(body));
      if (statusCode < 200 || statusCode > 400 || json == null) {
        print(statusCode);
        print(json);
        throw new Exception("Error while fetching data");
      }
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse["_id"];
    });
  }
}