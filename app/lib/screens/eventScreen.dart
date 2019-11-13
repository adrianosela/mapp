import 'package:flutter/material.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/reusableFunctions.dart';

import 'package:app/controllers/eventController.dart';
import 'package:app/models/eventModel.dart';
import 'package:app/models/fcmToken.dart';

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
      );
    }
  }

  Future<Event> _getEvent() async {
    return await EventController.getEventObject(userToken, eventId);
  }
}
