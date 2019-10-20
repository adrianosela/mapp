
class Event {

  final String name;
  final double longitude;
  final double latitude;
  final String description;
  final DateTime date;
  final bool public;

  Event(this.name, this.description, this.longitude, this.latitude, this.date, this.public);
}