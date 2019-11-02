import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;


class UserController {

  ///TODO remove return following list functionality?
  /*static Future<List<String>> getUser(String id) async {

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
  }*/


  ///Get user model by providing userToken
  ///TODO delete this call?
  static Future<List<String>> getUserObject(String id) async {

    Map<String, String> query = {
      'id' : id
    };

    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "/user/me",
      query,
    );

    //List<String> following = new List<String>();

    final response = await http.get(uri, headers: {"Content-Type": "application/json", "authorization" : "Bearer $id"});

    var userContainer = json.decode(response.body);
    print(userContainer);
    if (response.statusCode == 200) {
      var userContainer = json.decode(response.body);
      print(userContainer);
      /*if(userContainer[1] != null) {
        for (var instance in userContainer[1]) {
          following.add(userContainer[1].fromJson(instance).toString());
        }
      }*/
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
    return null;//following;
  }


  ///Get a map of users the current user is following => map(userid, username)
  static Future<Map<String, String>> getUserFollowing(token) async {

    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "/user/following"
    );

    Map<String, String> following = new Map<String, String>();

    final response = await http.get(uri, headers: {"Content-Type": "application/json", "authorization" : "Bearer $token"});

    if (response.statusCode == 200) {
      var userContainer = json.decode(response.body);
      if(userContainer != null) {
        for(var instance in userContainer) {
          following[instance["id"].toString()] = instance["name"].toString();
        }
      }
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to fetch data');
    }
    return following;
  }


  ///TODO finish this send a "follow user post"
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


  ///Get events user clicked "going to"
  static Future<Map<String, String>> getSubscribedEvents(String id) async {

    Map<String, String> query = {
      'id' : id
    };

    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "/user/subscribed",
      query,
    );

    Map<String, String> result = new Map<String, String>();

    final response = await http.get(uri, headers: {"Content-Type": "application/json", "authorization" : "Bearer $id"});


    if (response.statusCode == 200) {
      var userContainer = json.decode(response.body);

      if(userContainer != null) {
        for(var instance in userContainer) {
          result[instance["id"].toString()] = instance["name"].toString();
        }
      }
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
    return result;
  }


  ///Get events user is invited to
  static Future<Map<String, String>> getPendingEvents(String id) async {

    Map<String, String> query = {
      'id' : id
    };

    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "/user/pending",
      query,
    );

    Map<String, String> result = new Map<String, String>();

    final response = await http.get(uri, headers: {"Content-Type": "application/json", "authorization" : "Bearer $id"});

    if (response.statusCode == 200) {
      var userContainer = json.decode(response.body);
      if(userContainer != null) {
        for(var instance in userContainer) {
          result[instance["id"].toString()] = instance["name"].toString();
        }
      }
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
    return result;
  }
}