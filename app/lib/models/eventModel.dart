class Event {

  final String name;
  final double longitude;
  final double latitude;
  final String description;
  final DateTime date;
  final DateTime duration;
  final bool public;
  final List<String> invited;
  final List<String> categories;
  final String relevance;
  String eventId;

  Event({this.name, this.description, this.longitude, this.latitude, this.date, this.duration, this.public, this.invited, this.categories, this.relevance});

  factory Event.fromJson(Map<String, dynamic> json) {
    Event event = new Event(
      name: json['name'],
      longitude: json['location']['coordinates'][0],
      latitude: json['location']['coordinates'][1],
      description: json['description'],
      date: new DateTime.fromMillisecondsSinceEpoch(json['startTime']*1000),
      duration: DateTime.fromMillisecondsSinceEpoch(json['endTime']*1000),
      public: json['public'],
      relevance: json['relevance'],
    );
    event.eventId = json['_id'];
    return event;
  }

  Map<String, dynamic> toJson() => {
    
    'name' : name,
    'longitude' : longitude,
    'latitude' : latitude,
    'description' : description,
    'startTime' : (date.toUtc().millisecondsSinceEpoch/1000).round(),
    'endTime' : (date.add(new Duration(hours: duration.hour, minutes: duration.minute)).millisecondsSinceEpoch/1000).round(),
    'public' :  public,
    'invited' : invited,
    'categories': categories
  };

}
