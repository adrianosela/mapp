import 'dart:async';
import 'dart:convert';

import 'package:app/models/eventModel.dart';
import 'package:app/models/announcementModel.dart';
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

  ///create an event
  createAnnouncement(token, String eventId, String announcement) async {
    var body = {"message": announcement, "eventId": eventId};

    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "/event/announcement",
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

  ///get specific event object by event id
  static Future<List<Announcement>> getAnnouncements(
      String token, String eventId) async {
    Map<String, String> query = {'id': eventId};

    var uri = Uri.https(
      "mapp-254321.appspot.com",
      "/event/announcements",
      query,
    );

    final response = await http.get(uri, headers: {
      "Content-Type": "application/json",
      "authorization": "Bearer $token"
    });

    List<Announcement> annnouncements = new List<Announcement>();
    print(response.body);
    if (response.statusCode == 200) {
      var decodedResp = json.decode(response.body);
      if (decodedResp != null) {
        for (var announcement in decodedResp["messages"]) {
          annnouncements.add(Announcement.fromJson(announcement));
        }
      }
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
    return annnouncements;
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

  ///get specific event object by event id
  static Future<Map<String, dynamic>> getEvent(String token, String eventId) async {
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

    if (response.statusCode == 200) {
      var eventJson = json.decode(response.body);
      return eventJson;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  ///delete an event
  static Future<String> deleteEvent(String token, eventId) async {
    Map<String, String> query = {'id': eventId};

    var uri = Uri.https("mapp-254321.appspot.com", "/event", query);

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

  ///updates an event
  static Future<String> updateEvent(token, body) async {
    return http
        .put("https://mapp-254321.appspot.com/event",
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

      return null;
    });
  }

  ///invite users to an event
  static Future<String> inviteToEvent(token, body) async {
    return http
        .post("https://mapp-254321.appspot.com/event/invite",
        headers: {
          "Content-Type": "application/json",
          "authorization": "Bearer $token"
        },
        body: jsonEncode(body))
        .then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("Error while fetching data");
      }

      return statusCode.toString();
    });
  }

  ///Get a map of users the current user is following => map(userid, username)
  static Future<List<String>> getSubscribedUsers(token, eventId) async {

    Map<String, String> query = {'id': eventId};
    var uri = Uri.https("mapp-254321.appspot.com", "/event/subscribed", query);

    List<String> subscribed = new List<String>();

    final response = await http.get(uri, headers: {
      "Content-Type": "application/json",
      "authorization": "Bearer $token"
    });

    if (response.statusCode == 200) {
      var userContainer = json.decode(response.body);
      print(userContainer);
      if (userContainer != null) {
        for (var instance in userContainer) {
          subscribed.add(instance["name"].toString());
        }
      }
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to fetch data');
    }
    return subscribed;
  }
}
