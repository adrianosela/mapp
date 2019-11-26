import 'package:app/screens/subscribedScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geocoder/geocoder.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:app/controllers/eventController.dart';
import 'package:app/controllers/userController.dart';

import 'package:app/models/eventModel.dart';
import 'package:app/models/fcmToken.dart';
import 'package:app/models/announcementModel.dart';

import 'package:app/components/reusableFunctions.dart';
import 'package:app/components/router.dart';

import 'package:app/screens/inviteFriendsScreen.dart';

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
  bool going = true;
  List<String> usersToInvite = new List<String>();
  List<Announcement> rows = new List<Announcement>();

  _EventPageState({this.eventId});

  @override
  void initState() {
    super.initState();
    this.userToken = FCM.getToken();
    _getEvent().then((result) {
      this.event = result;
      setState(() {});
    });
    _getAnnouncements().then((result) {
      setState(() {});
    });
    _seeIfGoing().then((result) {
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
      return new Scaffold(
          appBar: AppBar(
            title: Text("Event Details"),
          ),
          body: Card(
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Center(
                        child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.all(3.0),
                                    child: Text(event.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                            color: Colors.blue))),
                                Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Card(
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                    builder: (context, setState) {
                                                      return SimpleDialog(
                                                        title: ReusableFunctions.titleText(
                                                            event.name),
                                                        children: <Widget>[
                                                          SimpleDialogOption(
                                                            child: Text(event.description,
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 18.0)),
                                                          )
                                                        ],
                                                      );
                                                    });
                                              });
                                        },
                                        child: ListTile(
                                          title: Text("About",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Colors.blue)),
                                          subtitle: Text(event.description,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              )),
                                        ),
                                      ),
                                    )),
                                Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Text(
                                      (event.public) ? "Public Event" : "Private Event",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 15.0)),
                                ),
                                Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Text(
                                        "Starts on " +
                                            new DateFormat.yMMMEd().format(event.date) +
                                            " " +
                                            new DateFormat.jm().format(event.date),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 15.0))),
                                Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Text(
                                        "Ends on " +
                                            new DateFormat.yMMMEd().format(event.duration) +
                                            " " +
                                            new DateFormat.jm().format(event.duration),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 15.0))),
                                Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Text(address,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                      )),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(1.0),
                                      child: RaisedButton(
                                        color: Colors.blue,
                                        textColor: Colors.white,
                                        disabledColor: Colors.grey,
                                        disabledTextColor: Colors.black,
                                        padding: EdgeInsets.all(0),
                                        splashColor: Colors.blueAccent,
                                        onPressed: _openMap,
                                        child: Text('Directions',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0)),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(1.0),
                                      child: RaisedButton(
                                        color: Colors.blue,
                                        textColor: Colors.white,
                                        disabledColor: Colors.grey,
                                        disabledTextColor: Colors.black,
                                        padding: EdgeInsets.all(0),
                                        splashColor: Colors.blueAccent,
                                        onPressed: (() async {
                                          if (going) {
                                            Map<String, dynamic> toJson() =>
                                                {'eventIds': eventId};

                                            await UserController.postSubscribe(
                                                userToken, toJson());
                                            _showAlert("Subscribed");

                                            setState(() {
                                              going = false;
                                            });

                                          } else {
                                            Map<String, dynamic> toJson() =>
                                                {'eventIds': eventId};

                                            await UserController.postUnsubscribe(
                                                userToken, toJson());
                                            _showAlert("Unsubscribed");

                                            setState(() {
                                              going = true;
                                            });

                                          }
                                        }),
                                        child: (going)
                                            ? Text('Subscribe',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0))
                                            : Text('Unsubscribe',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0)),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(1.0),
                                      child: RaisedButton(
                                        color: Colors.blue,
                                        textColor: Colors.white,
                                        disabledColor: Colors.grey,
                                        disabledTextColor: Colors.black,
                                        padding: EdgeInsets.all(0),
                                        splashColor: Colors.blueAccent,
                                        onPressed: () async {
                                          final result = await Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                  new InviteFriendsPage(
                                                      eventId: eventId)));
                                          usersToInvite = result;
                                          _inviteToEvent();
                                        },
                                        child: Text('Invite',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0)),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(1.0),
                                      child: IconButton(
                                        icon: new Icon(Icons.people, color: Colors.blue),
                                        onPressed: () async {
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) => new SubscribedPage(
                                                      eventId: eventId)));
                                        },

                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ))),
                  ),
                  Card(
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Column(children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text("Announcements",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: Colors.blue)),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.35,
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      this._buildRow(context, index)),
                            ),
                          ]))),
                ],
              )),
          floatingActionButton: new FloatingActionButton(
              elevation: 0.0,
              child: new Icon(Icons.check),
              backgroundColor: Colors.blue,
              onPressed: () async {
                Navigator.pop(context);
              }));
    }
  }

  _buildRow(BuildContext context, int index) {
    while (rows != null && index < rows.length) {
      final item = rows[index];
      return Card(
        child: ListTile(
          title: Text(item.message),
          subtitle: Text(new DateFormat.yMMMEd().format(item.date) +
              " " +
              new DateFormat.jm().format(item.date)),
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

  _getAnnouncements() async {
    List<Announcement> announcements =
        await EventController.getAnnouncements(userToken, eventId);

    if (announcements != null) {
      announcements.forEach((announcement) {
        rows.add(announcement);
      });
    }
    Iterable inReverse = rows.reversed;
    rows = inReverse.toList();
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

  _inviteToEvent() async {
    Map<String, dynamic> eventToJson() =>
        {'invited': usersToInvite, 'eventId': eventId};

    EventController.inviteToEvent(userToken, eventToJson());
  }

  _seeIfGoing() async {
    var responseSaved = await UserController.getSubscribedEvents(userToken);
    var responseCreated = await UserController.getCreatedEvents(userToken);

    if (responseCreated.toString().contains(eventId) ||
        responseSaved.toString().contains(eventId)) {
      going = false;
    } else {
      going = true;
    }
  }

  _showAlert(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Text(text,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17.0))),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(3.0),
                      splashColor: Colors.blueAccent,
                      child: Text("Ok",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.0)),
                      onPressed: () async {
                        //navigate to login screen
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
