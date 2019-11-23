import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;


class LoginController {

  static Future<String> loginUser(String url, body) async {
    return http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(body)).then((http.Response response) {
      final int statusCode = response.statusCode;

      print(jsonEncode(body));

      if(statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        return jsonResponse["token"];
      }
      else if (statusCode == 400 || statusCode == 401 || (statusCode == 500 && response.body != null)) {
        return response.body;
      } else {
        throw new Exception("Error while fetching data");
      }
    });
  }


  static Future<String> registerUser(String url, body) async {
    return http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(body)).then((http.Response response) {
      final int statusCode = response.statusCode;

      print(jsonEncode(body));

      if(statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse["_id"];
      } else if (statusCode == 400 || statusCode == 401 || (statusCode == 500 && response.body != null)) {
        return response.body;
      } else {
        throw new Exception("Error while fetching data");
      }
    });
  }

  static Future<String> postFCM(body, token) async {
    print(token);
    print(jsonEncode(body));
    return http.post("https://mapp-254321.appspot.com/fcmToken", headers: {"Content-Type": "application/json", "authorization" : "Bearer $token"}, body: jsonEncode(body)).then((http.Response response) {
      final int statusCode = response.statusCode;
      print('..................FCM response');
      print(statusCode);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return null;
    });
  }

}