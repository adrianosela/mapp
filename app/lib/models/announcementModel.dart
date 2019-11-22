class Announcement {

  final String message;
  final DateTime date;

  String eventId;

  Announcement({this.message, this.date});

  factory Announcement.fromJson(Map<String, dynamic> json) {
    Announcement announcement = new Announcement(
      message: json['message'],
      date: new DateTime.fromMillisecondsSinceEpoch(json['timestamp']*1000),
    );

    return announcement;
  }

  Map<String, dynamic> toJson() => {
    'message' : message,
    'timestamp' : (date.toUtc().millisecondsSinceEpoch/1000).round(),
  };

}