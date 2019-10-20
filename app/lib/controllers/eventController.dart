import 'dart:async';
import 'dart:convert';

import 'package:app/Models/eventModel.dart';
import 'package:http/http.dart' as http;

class EventController {

  List<Event> getEvents(int radius, double longitude, double latitude){
    return null;
  }


  Future<String> createEvent(String url, {Map body}) async {
    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }

      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse["eventId"];
    });
  }
}