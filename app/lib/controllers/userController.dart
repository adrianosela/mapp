import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;


class UserController {
  static Future<String> getUser(String id) async {

    Map<String, String> query = {
      'id' : id
    };

    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "/user",
      query,
    );

    final response = await http.get(uri);

    //TODO edit this
    if (response.statusCode == 200) {
      var events = json.decode(response.body);
      print("+++++++++++++++++++++");
      print(events);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load get');
    }
    return null;
  }
}