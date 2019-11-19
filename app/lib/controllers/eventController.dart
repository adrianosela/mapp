import 'dart:async';
import 'dart:convert';

import 'package:app/models/eventModel.dart';
import 'package:http/http.dart' as http;

class EventController {
  ///get all the public events in within user-preset radius
  Future<List<Event>> getEvents(
      int radius, double longitude, double latitude, token) async {
    Map<String, String> query = {
      'radius': radius.toString(),
      'longitude': longitude.toString(),
      'latitude': latitude.toString(),
    };

    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "/event/find",
      query,
    );

    final response = await http.get(uri, headers: {
      "Content-Type": "application/json",
      "authorization": "Bearer $token"
    });

    List<Event> allEvents = new List<Event>();
    print(response.body);
    if (response.statusCode == 200) {
      var events = json.decode(response.body);
      for (var event in events) {
        allEvents.add(Event.fromJson(event));
      }
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
    return allEvents;
  }

  Future<List<Event>> searchEvents(
      String search, List<String> categories, token) async {
    Map<String, String> query = {
      'eventName': search,
      'categories': categories.join(','),
    };

    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "/event/search",
      query,
    );

    final response = await http.get(uri, headers: {
      "Content-Type": "application/json",
      "authorization": "Bearer $token"
    });

    List<Event> allEvents = new List<Event>();
    print(response.body);
    if (response.statusCode == 200) {
      var events = json.decode(response.body);
      for (var event in events) {
        allEvents.add(Event.fromJson(event));
      }
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
    return allEvents;
  }

  ///create an event
  Future<String> createEvent(String url, token, body) async {
    return http
        .post(url,
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

      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse["data"]["eventId"];
    });
  }

  ///invite users to an event
  static Future<String> inviteToEvent(String url, token, body) async {
    return http
        .post(url,
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

      return statusCode.toString();
    });
  }

  ///get specific event object by event id
  static Future<Event> getEventObject(String token, String eventId) async {
    Map<String, String> query = {'id': eventId};

    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "/event",
      query,
    );

    final response = await http.get(uri, headers: {
      "Content-Type": "application/json",
      "authorization": "Bearer $token"
    });

    Event event;
    print(eventId);
    print(response.body);
    if (response.statusCode == 200) {
      var eventJson = json.decode(response.body);
      if (eventJson != null) {
        event = new Event.fromJson(eventJson);
      }
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
    return event;
  }

  ///delete an event
  static Future<String> deleteEvent(String token, eventId) async {
    Map<String, String> query = {'id': eventId};

    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "/event",
      query
    );

    final response = await http.delete(uri, headers: {
      "Content-Type": "application/json",
      "authorization": "Bearer $token"
    });
    if (response.statusCode < 200 ||
        response.statusCode > 400 ||
        json == null) {
      print(response.statusCode);
      print(json);
      throw new Exception("Error while fetching data");
    }
    return null;
  }

  ///TODO update an event
  Future<String> updateEvent(String url, token, body) async {
    return http
        .put(url,
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

      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse["data"]["eventId"];
    });
  }

}
