import 'dart:async';
import 'dart:convert';

import 'package:app/models/eventModel.dart';
import 'package:http/http.dart' as http;

class EventController {


  ///get all the public events in within user-preset radius
  Future<List<Event>> getEvents(int radius, double longitude, double latitude, token) async {

    Map<String, String> query = {
      'radius' : radius.toString(),
      'longitude' : longitude.toString(),
      'latitude' : latitude.toString(),
    };

    var uri = Uri.https(
        "mapp-254321.appspot.com",
        "/event/find",
        query,
    );

    final response = await http.get(uri, headers: {"Content-Type": "application/json", "authorization" : "Bearer $token"});

    List<Event> allEvents = new List<Event>();
    print(response.body);
    if (response.statusCode == 200) {
      var events = json.decode(response.body);
      print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
      print(events);
      for (var event in events) {
        allEvents.add(Event.fromJson(event));
      }
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
    return allEvents;
  }

  Future<List<Event>> searchEvents(String search, List<String> categories, token) async {

    Map<String, String> query = {
      'eventName' : search,
      'categories': categories.join(','),
    };

    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "/event/search",
      query,
    );
    print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    print("here");
    print(uri);

    final response = await http.get(uri, headers: {"Content-Type": "application/json", "authorization" : "Bearer $token"});

    List<Event> allEvents = new List<Event>();
    print(response.body);
    if (response.statusCode == 200) {
      var events = json.decode(response.body);
      print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
      print(events);
      for (var event in events) {
        allEvents.add(Event.fromJson(event));
      }
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
    return allEvents;
  }


  ///TODO
  Future<String> createEvent(String url, token, body) async {
    return http.post(url, headers: {"Content-Type": "application/json", "authorization" : "Bearer $token"}, body: jsonEncode(body)).then((http.Response response) {

      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }

      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse["data"]["eventId"];
    });
  }


  ///TODO
  static Future<String> inviteToEvent(String url, token, body) async {
    return http.post(url, headers: {"Content-Type": "application/json", "authorization" : "Bearer $token"}, body: jsonEncode(body)).then((http.Response response) {

      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }

      return statusCode.toString();
    });
  }


  ///get specific event object by event id
  static Future<Map<String, String>> getEvent(String token, String eventId) async {

    Map<String, String> query = {
      'id' : eventId
    };

    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "/event",
      query,
    );

    Map<String, String> result = new Map<String, String>();

    final response = await http.get(uri, headers: {"Content-Type": "application/json", "authorization" : "Bearer $token"});

    if (response.statusCode == 200) {
      var userContainer = json.decode(response.body);
      if(userContainer != null) {
        result["name"] = userContainer["name"].toString();
        result["description"] = userContainer["description"].toString();
        result["startTime"] = userContainer["startTime"].toString();
        result["endTime"] = userContainer["endTime"].toString();
        result["location"] = userContainer["location"].toString();
        result["public"] = userContainer["public"].toString();
        result["creator"] = userContainer["creator"].toString();
      }
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
    return result;
  }


  ///Delete an event
  static Future<String> deleteEvent(String token) async {

    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "/event",
    );

    final response = await http.get(uri, headers: {"Content-Type": "application/json", "authorization" : "Bearer $token"});
    if (response.statusCode < 200 || response.statusCode > 400 || json == null) {
      print(response.statusCode);
      print(json);
      throw new Exception("Error while fetching data");
    }

    return null;
  }
}