import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;


class UserController {

  ///TODO
  static Future<List<String>> getUser(String id) async {

    Map<String, String> query = {
      'id' : id
    };

    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "/user",
      query,
    );

    List<String> following = new List<String>();

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      var userContainer = json.decode(response.body);
      if(userContainer[1] != null) {
        for (var instance in userContainer[1]) {
          following.add(userContainer[1].fromJson(instance).toString());
        }
      }
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
    return following;
  }


  ///TODO finish this
  static Future<String> followUser(String url, body, token) async {
    return http.post(url, headers: {"Content-Type": "application/json", "authorization" : "Bearer $token"}, body: jsonEncode(body)).then((http.Response response) {
      final int statusCode = response.statusCode;
      print(jsonEncode(body));
      if (statusCode < 200 || statusCode > 400 || json == null) {
        print(statusCode);
        print(json);
        throw new Exception("Error while fetching data");
      }

      return null;
    });
  }
}