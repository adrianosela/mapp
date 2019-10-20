
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
      date: new DateTime.fromMicrosecondsSinceEpoch(json['date']),
      public: json['public'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();

    map['name'] = name;
    map['longitude'] = longitude;
    map['latitude'] = latitude;
    map['description'] = description;
    map['date'] = date.toUtc().millisecondsSinceEpoch;
    map['public'] = public;

    return map;
  }
}