import 'dart:async';
import 'dart:convert';

import 'package:app/Models/userModel.dart';
import 'package:http/http.dart' as http;


class LoginController {

  Future<String> loginUser(String url, {Map body}) async {
    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }

      return null;
    });
  }


  Future<String> registerUser(String url, {Map body}) async {
    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while posting data");
      }

      return null;
    });
  }
}