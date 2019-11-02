import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as prefix0;
import 'dart:io' show Platform;
import 'package:location/location.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/reusableFunctions.dart';
import 'package:app/components/reusableStlyes.dart';

import 'package:app/controllers/eventController.dart';
import 'package:app/controllers/loginController.dart';

import 'package:app/models/eventModel.dart';
import 'package:app/models/fcmToken.dart';

import 'package:app/screens/inviteFriendsScreen.dart';

class MapPage extends StatefulWidget {
  final String userId;
  final String userToken;

  MapPage({this.userId, this.userToken});

  @override
  _MapPageState createState() =>
      _MapPageState(userId: userId, userToken: userToken);
}

class _MapPageState extends State<MapPage> {
  final String userId;
  final String userToken;

  _MapPageState({this.userId, this.userToken});

  List<String> usersToInvite;

  GoogleMapController mapController;
  Location location = Location();

  Icon cusIcon = Icon(Icons.search);
  Widget cusWidget = Text("Map View");
  final _formKey = GlobalKey<FormState>();
  bool isSwitched = true;
  var searchText;
  var eventDate;
  var eventId;
  var msg;

  Map<String, String> eventsInRadius = new Map<String, String>();

  //Text Controllers
  TextEditingController eventNameCont = TextEditingController();
  TextEditingController eventDescriptionCont = TextEditingController();
  TextEditingController eventDurationCont = TextEditingController();
  EventController eventController = EventController();

  //TODO sets the initial view of the map needs to be changed to user location
  static const LatLng _center = const LatLng(49.2827, -123.1207);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  //Set map Screen only once
  bool mapSet = false;

  //Fetch events every N location updates
  int locationCount = 0;
  int updateEvents = 0;

  Map<String, bool> categoriesMap = {
    'social': true,
    'community': true,
    'corporate': true,
    'sports': true,
    'other': true,
  };

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    location.onLocationChanged().listen((location) async {
      if (!mapSet) {
        mapSet = true;
        mapController?.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                location.latitude,
                location.longitude,
              ),
              zoom: 13.0,
            ),
          ),
        );
      }
      if (true) {
        _addMarkers(location);
      }
      locationCount++;
    });

    ///only show notifications for Android
    if (Platform.isAndroid) {
      _firebaseMessaging.getToken().then((token) {
        print(
            '-----------------------------------------------------------------------------------------------');
        FCM fcm = new FCM(token: token);
        LoginController.postFCM(fcm.toJson(), userToken);

        print('---------------------------------');
        print(userId);

        print("-----------------");
        print(userToken);
        //print(token);
      });

      _firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) async {
        setState(() {
          msg = "$message";
        });
        _showNotification();
        print('on message $message');
      });
    }
  }

  GoogleMap _initializeMap() {
    return GoogleMap(
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11.0,
      ),
      onLongPress: _onLongTapMap,
      markers: Set<Marker>.of(markers.values),
    );
  }

  _onLongTapMap(LatLng latlang) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ReusableFunctions.titleText("Create New Event"),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: ReusableFunctions.formInput(
                            "enter event name", eventNameCont),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: ReusableFunctions.formInput(
                            "enter event description", eventDescriptionCont),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: FlatButton(
                            onPressed: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(2019, 3, 5),
                                  maxTime: DateTime(2023, 6, 7),
                                  onChanged: (date) {
                                //print('change $date');
                              }, onConfirm: (date) {
                                eventDate = date;
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                            child: Text(
                              //TODO
                              'pick event date',
                              style: TextStyle(color: Colors.blue),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        //TODO calculate and send to backend properly
                        child: ReusableFunctions.formInput(
                            "enter event duration (hours)", eventDurationCont),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Private Event?",
                              style: TextStyle(
                                  //TODO
                                  ),
                            ),
                          ),
                          Container(
                            width: 100,
                          ),
                          Container(
                            child: Switch(
                              value: isSwitched,
                              onChanged: (value) {
                                setState(() {
                                  isSwitched = value;
                                });
                              },
                              activeTrackColor: Colors.lightBlueAccent,
                              activeColor: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Invite Friends",
                              style: TextStyle(
                                  //TODO
                                  ),
                            ),
                          ),
                          Container(
                            width: 110,
                          ),
                          IconButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          new InviteFriendsPage(
                                              userId: userId,
                                              userToken: userToken)));
                              usersToInvite = result;
                            },
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: RaisedButton(
                          child: Text("Save"),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              Event event = new Event(
                                  name: eventNameCont.text,
                                  description: eventDescriptionCont.text,
                                  longitude: latlang.longitude,
                                  latitude: latlang.latitude,
                                  date: eventDate,
                                  public: true,
                                  invited: usersToInvite);

                              eventId = await eventController.createEvent(
                                  "https://mapp-254321.appspot.com/event",
                                  userToken,
                                  event.toJson());

                              //TODO Need to pass Title to add to marker
                              _addMarkerLongPressed(latlang);

                              //TODO append event to list of created events, show new pin on map?
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  //TODO Need to pass event related info to marker to display, maybe different colors for different events
  Future _addMarkerLongPressed(LatLng latlang) async {
    setState(() {
      //TODO need to pass event_id into the MarkerId, using event name for now
      final MarkerId markerId = MarkerId(eventId);
      Marker marker = Marker(
        markerId: markerId,
        draggable: false,
        position: latlang,
        //With this parameter you automatically obtain latitude and longitude
        infoWindow: InfoWindow(
          title: eventNameCont.text,
          snippet: eventDescriptionCont.text,
        ),
        //TODO Change color of marker depending on event type
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      );

      //Clear Text Controllers
      eventNameCont.clear();
      eventDescriptionCont.clear();
      markers[markerId] = marker;
    });
  }

  Future _addMarkers(location) async {
    List<Event> events = await eventController.getEvents(
        5000, location.longitude, location.latitude, userToken);
    setState(() {
      for (Event event in events) {
        print(event.name);
        print(event.eventId);

        eventsInRadius[event.eventId] = event.name;

        final MarkerId markerId = MarkerId(event.eventId);

        final LatLng position =
            new prefix0.LatLng(event.latitude, event.longitude);
        Marker marker = Marker(
          markerId: markerId,
          draggable: false,
          position: position,
          //With this parameter you automatically obtain latitude and longitude
          infoWindow: InfoWindow(
            title: event.name,
            snippet: event.description,
          ),
          //TODO Change color of marker depending on event type
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
        );
        markers[markerId] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(
          userId: userId, userToken: userToken, events: eventsInRadius),
      appBar: AppBar(
        title: cusWidget,
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return SimpleDialog(
                        title: ReusableFunctions.titleText("Categories"),
                        children: <Widget>[
                          SimpleDialogOption(
                            child: CheckboxListTile(
                              title: Text("Social"),
                              value: categoriesMap['social'],
                              onChanged: (val) {
                                setState(() {
                                  categoriesMap['social'] =
                                      !categoriesMap['social'];
                                });
                              },
                            ),
                          ),
                          SimpleDialogOption(
                            child: CheckboxListTile(
                              title: Text("Community"),
                              value: categoriesMap['community'],
                              selected: categoriesMap['community'],
                              onChanged: (bool val) {
                                setState(() {
                                  categoriesMap['community'] = val;
                                });
                              },
                            ),
                          ),
                          SimpleDialogOption(
                            child: CheckboxListTile(
                              title: Text("Sports"),
                              value: categoriesMap['sports'],
                              onChanged: (val) {
                                setState(() {
                                  categoriesMap['sports'] = val;
                                });
                              },
                            ),
                          ),
                          SimpleDialogOption(
                            child: CheckboxListTile(
                              title: Text("Corporate"),
                              value: categoriesMap['corporate'],
                              onChanged: (val) {
                                setState(() {
                                  categoriesMap['corporate'] = val;
                                });
                              },
                            ),
                          ),
                          SimpleDialogOption(
                            child: CheckboxListTile(
                              title: Text("Other"),
                              value: categoriesMap['other'],
                              onChanged: (val) {
                                setState(() {
                                  categoriesMap['other'] = val;
                                });
                              },
                            ),
                          ),
                          SimpleDialogOption(
                              child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: RaisedButton(
                              child: Text("Save"),
                              onPressed: () async {},
                            ),
                          )),
                        ],
                      );
                    });
                  });
            },
            child: Text("Filter Events"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
          MyPopupMenu.createPopup(context),
        ],
      ),
      body: _initializeMap(),
    );
  }

  Future _showNotification() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: new Text(msg),
            children: <Widget>[
              new SimpleDialogOption(
                child: new Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
