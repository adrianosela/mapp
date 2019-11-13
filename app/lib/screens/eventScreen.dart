import 'package:flutter/material.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/reusableFunctions.dart';
import 'package:intl/intl.dart';
import 'package:geocoder/geocoder.dart';
import 'package:app/controllers/eventController.dart';
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
        body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ReusableFunctions.titleText("Event Details"),
          Padding(
              padding: EdgeInsets.all(2.0),
              child: Text("About: " + event.description)
          ),

          Padding(
              padding: EdgeInsets.all(2.0),
              child: Text("Starts on " + new DateFormat.yMMMEd().format(event.date) + " " + new DateFormat.jm().format(event.date))
          ),
          Padding(
              padding: EdgeInsets.all(2.0),
              child: Text("Ends on " + new DateFormat.yMMMEd().format(event.date.add(new Duration(hours: int.parse(event.duration)))) + " " + new DateFormat.jm().format(event.date.add(new Duration(hours: int.parse(event.duration)))))
          ),
          Padding(
            padding: EdgeInsets.all(2.0),
            child: Text(address),
          ),
          Padding(
            padding: EdgeInsets.all(2.0),
            child: RaisedButton(
              onPressed: _openMap,
              child: Text('Directions'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(2.0),
            child: Text((event.public) ? "Private Event" : "Public Event"),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: RaisedButton(
              child: Text("Ok"),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
      );
    }
  }

  Future<Event> _getEvent() async {
    Event event = await EventController.getEventObject(userToken, eventId);
    final coordinates = new Coordinates(
        event.latitude, event.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);
    this.address = addresses.first.addressLine;
    return event;
  }

  _openMap() async {
    var url = 'https://www.google.com/maps/search/?api=1&query=${event.latitude},${event.longitude}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
