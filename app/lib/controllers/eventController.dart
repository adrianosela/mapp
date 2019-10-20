import 'dart:async';
import 'dart:convert';

import 'package:app/Models/eventModel.dart';
import 'package:http/http.dart' as http;

class EventController {

  List<Event> getEvents(int radius, double longitude, double latitude){
    return null;
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