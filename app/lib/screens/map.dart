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

import 'package:app/controllers/eventController.dart';
import 'package:app/controllers/loginController.dart';

import 'package:app/models/eventModel.dart';
import 'package:app/models/fcmToken.dart';

import 'package:app/screens/inviteFriendsScreen.dart';
import 'package:app/screens/searchedEvents.dart';
import 'package:app/screens/eventScreen.dart';

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
  String userToken;

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

  double radius = 5.0;
  double newRadius = 0;

  Map<String, String> eventsInRadius = new Map<String, String>();

  //Map Filter
  Map<String, bool> categoriesMap = {
    'social': false,
    'community': false,
    'corporate': false,
    'sports': false,
    'other': false,
  };
  Map<String, bool> eventCategoriesMap = {
    'social': false,
    'community': false,
    'corporate': false,
    'sports': false,
    'other': false,
  };

  Map<MarkerId, String> eventIds = new Map<MarkerId, String>();

  //Text Controllers
  TextEditingController eventNameCont = TextEditingController();
  TextEditingController eventDescriptionCont = TextEditingController();
  TextEditingController eventDurationCont = TextEditingController();
  TextEditingController eventSearchCont = TextEditingController();
  EventController eventController = EventController();

  //TODO sets the initial view of the map needs to be changed to user location
  static const LatLng _center = const LatLng(49.2827, -123.1207);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  ///Set map Screen only once
  bool mapSet = false;

  ///Fetch events every N location updates
  int locationCount = 0;
  int updateEvents = 10;



  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    this.userToken = FCM.getToken();

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
      if (locationCount % updateEvents == 0) {
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

  _onActionButtonTap() {
    newRadius = radius;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return SimpleDialog(
              title: ReusableFunctions.titleText("Event Search Radius (km)"),
              children: <Widget>[
                SimpleDialogOption(
                    child: Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Slider(
                    min: 0.0,
                    max: 20,
                    divisions: 20,
                    label: newRadius.toString(),

                    onChanged: (val) {
                      setState(() => newRadius = val);
                    },
                    value: newRadius,
                  ),
                )),
                SimpleDialogOption(
                    child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: RaisedButton(
                    child: Text("Update Map"),
                    onPressed: () async {
                      radius = newRadius;
                      LocationData curLocation = await location.getLocation();
                      await _addMarkers(curLocation);
                      Navigator.of(context).pop();
                    },
                  ),
                )),
              ],
            );
          });
        });
  }

  _onLongTapMap(LatLng latlang) {
    for (String category in eventCategoriesMap.keys) {
      eventCategoriesMap[category] = false;
    }
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
                              DatePicker.showDateTimePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime.now(),
                                  maxTime: DateTime.now()
                                      .add(new Duration(days: 365)),
                                  onChanged: (date) {}, onConfirm: (date) {
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
                                          new InviteFriendsPage()));
                              usersToInvite = result;
                            },
                            icon: Icon(Icons.person_add),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: RaisedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return SimpleDialog(
                                      title: ReusableFunctions.titleText(
                                          "Categories"),
                                      children: <Widget>[
                                        SimpleDialogOption(
                                          child: CheckboxListTile(
                                            title: Text("Social"),
                                            value: eventCategoriesMap['social'],
                                            selected:
                                                eventCategoriesMap['social'],
                                            onChanged: (val) {
                                              setState(() {
                                                eventCategoriesMap['social'] =
                                                    val;
                                              });
                                            },
                                          ),
                                        ),
                                        SimpleDialogOption(
                                          child: CheckboxListTile(
                                            title: Text("Community"),
                                            value:
                                                eventCategoriesMap['community'],
                                            selected:
                                                eventCategoriesMap['community'],
                                            onChanged: (bool val) {
                                              setState(() {
                                                eventCategoriesMap[
                                                    'community'] = val;
                                              });
                                            },
                                          ),
                                        ),
                                        SimpleDialogOption(
                                          child: CheckboxListTile(
                                            title: Text("Sports"),
                                            value: eventCategoriesMap['sports'],
                                            selected:
                                                eventCategoriesMap['sports'],
                                            onChanged: (val) {
                                              setState(() {
                                                eventCategoriesMap['sports'] =
                                                    val;
                                              });
                                            },
                                          ),
                                        ),
                                        SimpleDialogOption(
                                          child: CheckboxListTile(
                                            title: Text("Corporate"),
                                            selected:
                                                eventCategoriesMap['corporate'],
                                            value:
                                                eventCategoriesMap['corporate'],
                                            onChanged: (val) {
                                              setState(() {
                                                eventCategoriesMap[
                                                    'corporate'] = val;
                                              });
                                            },
                                          ),
                                        ),
                                        SimpleDialogOption(
                                          child: CheckboxListTile(
                                            title: Text("Other"),
                                            selected:
                                                eventCategoriesMap['other'],
                                            value: eventCategoriesMap['other'],
                                            onChanged: (val) {
                                              setState(() {
                                                eventCategoriesMap['other'] =
                                                    val;
                                              });
                                            },
                                          ),
                                        ),
                                        SimpleDialogOption(
                                            child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: RaisedButton(
                                            child: Text("Ok"),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        )),
                                      ],
                                    );
                                  });
                                });
                          },
                          child: Text("Select Categories"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: RaisedButton(
                          child: Text("Save"),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              List<String> categories = new List<String>();

                              for (String category in eventCategoriesMap.keys) {
                                if (eventCategoriesMap[category]) {
                                  categories.add(category);
                                }
                              }
                              Event event = new Event(
                                name: eventNameCont.text,
                                description: eventDescriptionCont.text,
                                longitude: latlang.longitude,
                                latitude: latlang.latitude,
                                date: eventDate,
                                duration: eventDurationCont.text,
                                public: isSwitched,
                                invited: usersToInvite,
                                categories: categories,
                              );

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
      eventIds[markerId] = eventId;
      Marker marker = Marker(
        markerId: markerId,
        draggable: false,
        position: latlang,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      new EventPage(eventId: eventIds[markerId])));
        },
        //With this parameter you automatically obtain latitude and longitude
        infoWindow: InfoWindow(
          title: eventNameCont.text,
          snippet: eventDescriptionCont.text,
        ),
        //TODO Change color of marker depending on event type
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      );

      ///clear text controllers
      eventNameCont.clear();
      eventDescriptionCont.clear();
      eventDurationCont.clear();

      markers[markerId] = marker;
    });
  }

  Future _addMarkers(location) async {
    List<Event> events = await eventController.getEvents(
        radius.toInt()*1000, location.longitude, location.latitude, userToken);

    print(radius);
    setState(() {
      markers.clear();
      for (Event event in events) {
        print(event.name);
        print(event.eventId);

        eventsInRadius[event.eventId] = event.name;

        final MarkerId markerId = MarkerId(event.eventId);

        eventIds[markerId] = event.eventId;

        final LatLng position =
            new prefix0.LatLng(event.latitude, event.longitude);
        Marker marker = Marker(
          markerId: markerId,
          draggable: false,
          position: position,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        new EventPage(eventId: eventIds[markerId])));
          },
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
      drawer: MyDrawer(events: eventsInRadius),
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
                              selected: categoriesMap['social'],
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
                              selected: categoriesMap['sports'],
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
                              selected: categoriesMap['corporate'],
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
                              selected: categoriesMap['other'],
                              value: categoriesMap['other'],
                              onChanged: (val) {
                                setState(() {
                                  categoriesMap['other'] = val;
                                });
                              },
                            ),
                          ),
                          SimpleDialogOption(
                            child: ReusableFunctions.formInput(
                                "Search event... ", eventSearchCont),
                          ),
                          SimpleDialogOption(
                              child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: RaisedButton(
                              child: Text("Search"),
                              onPressed: () async {
                                List<String> categories = new List<String>();

                                for (String category in categoriesMap.keys) {
                                  if (categoriesMap[category]) {
                                    categories.add(category);
                                  }
                                }
                                List<Event> events =
                                    await eventController.searchEvents(
                                        eventSearchCont.text,
                                        categories,
                                        userToken);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            new SearchedEventsPage(
                                                events: events)));
                                eventSearchCont.clear();
                              },
                            ),
                          )),
                        ],
                      );
                    });
                  });
            },
            child: Text("Search"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
          MyPopupMenu.createPopup(context),
        ],
      ),
      body: _initializeMap(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _onActionButtonTap();
        },
        child: Icon(Icons.filter_tilt_shift),
        backgroundColor: Colors.green,
      ),
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
