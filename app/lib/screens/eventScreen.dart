import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:geocoder/geocoder.dart';
import 'package:app/controllers/eventController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/models/eventModel.dart';
import 'package:app/models/fcmToken.dart';
import 'package:url_launcher/url_launcher.dart';

class EventPage extends StatefulWidget {
  final String eventId;

  EventPage({this.eventId});

  @override
  _EventPageState createState() => _EventPageState(eventId: this.eventId);
}

class _EventPageState extends State<EventPage> {
  String userToken;
  Event event;
  final String eventId;
  String address;

  _EventPageState({this.eventId});

  @override
  void initState() {
    super.initState();
    this.userToken = FCM.getToken();
    _getEvent().then((result) {
      this.event = result;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (event == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Loading Event..."),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(event.name),
        ),
        body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Text("Event Details",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.blue
                      ))
                ),
                Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text("About: " + event.description,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0
                      )
                    ),
                ),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text((event.public) ? "Public Event" : "Private Event",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0
                      )),
                ),
                Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text("Starts on " +
                        new DateFormat.yMMMEd().format(event.date) +
                        " " +
                        new DateFormat.jm().format(event.date),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0
                        ))),
                Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text("Ends on " +
                        new DateFormat.yMMMEd().format(event.date
                            .add(new Duration(hours: int.parse(event.duration)))) +
                        " " +
                        new DateFormat.jm().format(event.date
                            .add(new Duration(hours: int.parse(event.duration)))),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0
                        ))),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text(address,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child: RaisedButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(2.0),
                        splashColor: Colors.blueAccent,
                        onPressed: _openMap,
                        child: Text('Directions',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(3.0),
                    ),
                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child: RaisedButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(2.0),
                        splashColor: Colors.blueAccent,
                        onPressed: _subscribeToEvent,
                        child: Text('Going',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0
                            )),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(2.0),
                    splashColor: Colors.blueAccent,
                    child: Text("Ok",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0
                        )),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            )
        ),
      );
    }
  }

  Future<Event> _getEvent() async {
    Event event = await EventController.getEventObject(userToken, eventId);
    final coordinates = new Coordinates(event.latitude, event.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    this.address = addresses.first.addressLine;
    return event;
  }

  _openMap() async {
    var url =
        'https://www.google.com/maps/search/?api=1&query=${event.latitude},${event.longitude}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _subscribeToEvent() async {
    await UserController.postSubscribe(userToken, {'eventIds': eventId});
  }
}
