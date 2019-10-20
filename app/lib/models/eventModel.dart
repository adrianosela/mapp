import 'dart:convert';

class Event {

  final String name;
  final double longitude;
  final double latitude;
  final String description;
  final DateTime date;
  final bool public;

  Event({this.name, this.description, this.longitude, this.latitude, this.date, this.public});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      name: json['name'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      description: json['description'],
      date: new DateTime.fromMicrosecondsSinceEpoch(json['date']*1000),
      public: json['public'],
    );
  }

  Map<String, dynamic> toJson() => {

    'name' : name,
    'longitude' : longitude,
    'latitude' : latitude,
    'description' : description,
    'eventDate' : (date.toUtc().millisecondsSinceEpoch/1000).round(),
    'endsAt' : (date.toUtc().millisecondsSinceEpoch/1000 +1).round(),
    'public' :  public
  };

}
