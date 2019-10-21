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
      longitude: json['location']['coordinates'][0],
      latitude: json['location']['coordinates'][1],
      description: json['description'],
      date: new DateTime.fromMicrosecondsSinceEpoch(json['startTime']*1000),
      public: json['public'],
    );
  }

  Map<String, dynamic> toJson() => {

    'name' : name,
    'longitude' : longitude,
    'latitude' : latitude,
    'description' : description,
    'startTime' : (date.toUtc().millisecondsSinceEpoch/1000).round(),
    'endTime' : (date.toUtc().millisecondsSinceEpoch/1000 +1).round(),
    'public' :  public
  };

}
