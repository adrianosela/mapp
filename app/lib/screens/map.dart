import 'dart:async';

import 'package:app/screens/inviteFriendsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as prefix0;
import 'package:location/location.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/reusableFunctions.dart';
import 'package:app/components/reusableStlyes.dart';

import 'package:app/controllers/eventController.dart';
import 'package:app/models/eventModel.dart';


class MapPage extends StatefulWidget {

  //passing user id from register screen
  final String userId;
  MapPage({this.userId});

  @override
  _MapPageState createState() => _MapPageState(userId: userId);
}

class _MapPageState extends State<MapPage> {

  //passing user id from register screen
  final String userId;
  _MapPageState({this.userId});

  GoogleMapController mapController;
  Location location = Location();

  Icon cusIcon = Icon(Icons.search);
  Widget cusWidget = Text("Map View");
  final _formKey = GlobalKey<FormState>();
  bool isSwitched = true;
  var searchText;
  var eventDate;
  var eventId;

  //Text Controllers
  TextEditingController eventNameCont = TextEditingController();
  TextEditingController eventDescriptionCont = TextEditingController();
  TextEditingController eventDurationCont = TextEditingController();
  EventController eventController = EventController();

  //TODO sets the initial view of the map needs to be changed to user location
  static const LatLng _center = const LatLng(49.2827, -123.1207);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    location.onLocationChanged().listen((location) async {
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
      _addMarkers(location);
    });
  }

  GoogleMap _initializeMap(){
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
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ReusableFunctions.titleText("Create New Event"),
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: ReusableFunctions.formInput("enter event name", eventNameCont),
                  ),
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: ReusableFunctions.formInput("enter event description", eventDescriptionCont),
                  ),
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: FlatButton(
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2019, 3, 5),
                              maxTime: DateTime(2023, 6, 7), onChanged: (date) {
                                //print('change $date');
                              }, onConfirm: (date) {
                                eventDate = date;
                              }, currentTime: DateTime.now(), locale: LocaleType.en);
                        },
                        child: Text(
                          //TODO
                          'pick event date',
                          style: TextStyle(color: Colors.blue),
                        )
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: ReusableFunctions.formInput("enter event duration (hours)", eventDurationCont),
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
                          Navigator.push(context, new MaterialPageRoute(builder: (context) => new InviteFriendsPage(userId: userId)));
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
                        if(_formKey.currentState.validate()) {

                          Event event = new Event(name: eventNameCont.text,
                              description: eventDescriptionCont.text,
                              longitude: latlang.longitude,
                              latitude: latlang.latitude,
                              date: eventDate,
                              public: true);

                          eventId = await eventController.createEvent(
                              "https://mapp-254321.appspot.com/event", event
                              .toJson());

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
        position: latlang, //With this parameter you automatically obtain latitude and longitude
        infoWindow: InfoWindow(
          title: eventNameCont.text,
          snippet: eventDescriptionCont.text,

        ),
        //TODO Change color of marker depending on event type
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      );

      //Clear Text Controllers
      eventNameCont.clear();
      eventNameCont.clear();
      markers[markerId] = marker;
    });

  }

  Future _addMarkers(location) async {

    List<Event> events = await eventController.getEvents(5000, location.longitude, location.latitude);
    setState(() {
      for (Event event in events) {
        print(event.name);
        print(event.eventId);
        final MarkerId markerId = MarkerId(event.eventId);

        final LatLng position = new prefix0.LatLng(event.latitude, event.longitude);
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
      drawer: MyDrawer(),
      appBar: AppBar(
        title: cusWidget,
        actions: <Widget>[
          IconButton(
            onPressed: (){
                setState(() {
                          if(this.cusIcon.icon == Icons.search) {
                              this.cusIcon = Icon(Icons.cancel);
                              this.cusWidget = TextField(
                                textInputAction: TextInputAction.go,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "search for ...",
                                ),
                                style: ReusableStyles.cusWidget(),
                                onSubmitted: (String str) {
                                  //TODO send to backend
                                  setState(() {
                                    searchText = str;
                                  });
                                },
                              );
                          } else {
                              this.cusIcon = Icon(Icons.search);
                              this.cusWidget = Text("Map View");
                          }
                });
            },
            icon: cusIcon,
          ),
          MyPopupMenu.createPopup(context),
        ],
      ),
      body: _initializeMap(),
    );
  }
}