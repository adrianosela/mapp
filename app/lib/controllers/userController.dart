import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class UserController {
  ///Get a map of users the current user is following => map(userid, username)
  static Future<Map<String, String>> getUserFollowing(token) async {
    var uri = Uri.https("mapp-254321.appspot.com", "/user/following");

    Map<String, String> following = new Map<String, String>();

    final response = await http.get(uri, headers: {
      "Content-Type": "application/json",
      "authorization": "Bearer $token"
    });

    if (response.statusCode == 200) {
      var userContainer = json.decode(response.body);
      if (userContainer != null) {
        for (var instance in userContainer) {
          following[instance["id"].toString()] = instance["name"].toString();
        }
      }
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to fetch data');
    }
    return following;
  }

  ///Get a map of users the current user is following => map(userid, username)
  static Future<Map<String, Map<String, bool>>> getUserFollowers(token) async {
    var uri = Uri.https("mapp-254321.appspot.com", "/user/followers");

    Map<String, Map<String, bool>> followers =
        new Map<String, Map<String, bool>>();

    final response = await http.get(uri, headers: {
      "Content-Type": "application/json",
      "authorization": "Bearer $token"
    });

    if (response.statusCode == 200) {
      var userContainer = json.decode(response.body);
      if (userContainer != null) {
        for (var instance in userContainer) {
          Map<String, bool> temp = new Map();
          temp[instance["name"]] = instance["following"];
          followers[instance["id"].toString()] = temp;
        }
      }
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to fetch data');
    }
    return followers;
  }

  static Future<Map<String, List<String>>> searchUsers(
      token, String search) async {
    Map<String, String> query = {
      'username': search,
    };

    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "/user/search",
      query,
    );

    Map<String, List<String>> following = new Map<String, List<String>>();

    final response = await http.get(uri, headers: {
      "Content-Type": "application/json",
      "authorization": "Bearer $token"
    });

    print(response.body);

    if (response.statusCode == 200) {
      var userContainer = json.decode(response.body);
      if (userContainer != null) {
        for (var instance in userContainer) {
          var friends = [
            instance["name"].toString(),
            instance["friend"].toString()
          ];
          following[instance["id"].toString()] = friends;
        }
      }
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to fetch data');
    }
    return following;
  }

  static followUser(token, String userId) async {
    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "/user/follow",
    );

    var body = {"userToFollowId": userId};
    return http
        .post(uri,
            headers: {
              "Content-Type": "application/json",
              "authorization": "Bearer $token"
            },
            body: jsonEncode(body))
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      print(jsonEncode(body));
      if (statusCode < 200 || statusCode > 400 || json == null) {
        print(statusCode);
        print(json);
        throw new Exception("Error while fetching data");
      }
    });
  }

  static Future<String> unfollowUser(token, String userId) async {
    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "/user/unfollow",
    );

    var body = {"userToUnfollowId": userId};
    return http
        .post(uri,
            headers: {
              "Content-Type": "application/json",
              "authorization": "Bearer $token"
            },
            body: jsonEncode(body))
        .then((http.Response response) {
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

  static void removeFCM(token) async {
    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "fcmToken",
    );

    return http.delete(
      uri,
      headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer $token"
      },
    ).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        print(statusCode);
        print(json);
        throw new Exception("Error while fetching data");
      }

      return null;
    });
  }

  static Future<Map<String, String>> getCreatedEvents(String id) async {
    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "/user/created",
    );

    Map<String, String> result = new Map<String, String>();

    final response = await http.get(uri, headers: {
      "Content-Type": "application/json",
      "authorization": "Bearer $id"
    });

    if (response.statusCode == 200) {
      var userContainer = json.decode(response.body);

      if (userContainer != null) {
        for (var instance in userContainer) {
          result[instance["id"].toString()] = instance["name"].toString();
        }
      }
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
    return result;
  }

  ///Get events user clicked "going to"
  static Future<Map<String, String>> getSubscribedEvents(String id) async {
    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "/user/subscribed",
    );

    Map<String, String> result = new Map<String, String>();

    final response = await http.get(uri, headers: {
      "Content-Type": "application/json",
      "authorization": "Bearer $id"
    });

    if (response.statusCode == 200) {
      var userContainer = json.decode(response.body);

      if (userContainer != null) {
        for (var instance in userContainer) {
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
    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "/user/pending",
    );

    Map<String, String> result = new Map<String, String>();

    final response = await http.get(uri, headers: {
      "Content-Type": "application/json",
      "authorization": "Bearer $id"
    });

    if (response.statusCode == 200) {
      var userContainer = json.decode(response.body);
      if (userContainer != null) {
        for (var instance in userContainer) {
          result[instance["id"].toString()] = instance["name"].toString();
        }
      }
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
    return result;
  }

  ///Respond "going" to event invite
  static postSubscribe(String token, body) async {
    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "/user/subscribe",
    );

    return http
        .post(uri,
            headers: {
              "Content-Type": "application/json",
              "authorization": "Bearer $token"
            },
            body: jsonEncode(body))
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        print(statusCode);
        print(json);
        throw new Exception("Error while fetching data");
      }
    });
  }

  ///Respond "not going" to event invite
  static postNotGoing(String token, body) async {
    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "/user/declineInvite",
    );

    return http
        .post(uri,
            headers: {
              "Content-Type": "application/json",
              "authorization": "Bearer $token"
            },
            body: jsonEncode(body))
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
    });
  }

  ///Unsubscribe from an event
  static postUnsubscribe(String token, body) async {
    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "/user/unsubscribe",
    );

    return http
        .post(uri,
            headers: {
              "Content-Type": "application/json",
              "authorization": "Bearer $token"
            },
            body: jsonEncode(body))
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      print(jsonEncode(body));
      print(response.statusCode);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        print(statusCode);
        print(json);
        throw new Exception("Error while fetching data");
      }
    });
  }
}
