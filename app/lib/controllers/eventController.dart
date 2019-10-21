import 'dart:async';
import 'dart:convert';

import 'package:app/Models/eventModel.dart';
import 'package:http/http.dart' as http;

class EventController {

  Future<List<Event>> getEvents(int radius, double longitude, double latitude) async {

    Map<String, String> query = {
      'radius' : radius.toString(),
      'longitude' : longitude.toString(),
      'latitude' : latitude.toString(),
    };

    var uri = Uri.https(
        "mapp-254321.appspot.com",
        "/findEvents",
        query,
    );

    final response = await http.get(uri);

    List<Event> allEvents = new List<Event>();

    if (response.statusCode == 200) {
      var events = json.decode(response.body);
      for (var event in events) {
        allEvents.add(Event.fromJson(event));
      }
      print(allEvents);
      return allEvents;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }

  }

  Future<String> createEvent(String url, body) async {
    return http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(body)).then((http.Response response) {
      final int statusCode = response.statusCode;
      print(jsonEncode(body));
      if (statusCode < 200 || statusCode > 400 || json == null) {
        print(statusCode);
        print(json);
        throw new Exception("Error while fetching data");
      }
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse["data"]["eventId"];
    });
  }
}