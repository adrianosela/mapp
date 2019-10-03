import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/resuableFunctions.dart';


class MapPage extends StatefulWidget {

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {


  Completer<GoogleMapController> _controller = Completer();
  Icon cusIcon = Icon(Icons.search);
  Widget cusWidget = Text("Map View");
  final _formKey = GlobalKey<FormState>();
  bool isSwitched = true;

  //Text Controllers
  TextEditingController eventNameCont = TextEditingController();
  TextEditingController eventDescriptionCont = TextEditingController();


  //TODO sets the intial view of the map needs to be changed to user location
  static const LatLng _center = const LatLng(49.2827, -123.1207);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
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
                                //print('confirm $date');
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
                    //TODO change this to location picker
                    padding: EdgeInsets.all(2.0),
                    child: TextFormField(
                    ),
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
                        onPressed: (){
                          //TODO show a list of friends? open search menu?
                        },
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: RaisedButton(
                      child: Text("Save"),
                      onPressed: () {
                        //TODO Figure out what this commented code does
//                              if (_formKey.currentState.validate()) {
//
//                                _formKey.currentState.save();
//                              }
                        //TODO Need to pass Title to add to marker
                        _addMarkerLongPressed(latlang);
                        //TODO append event to list of created events, show new pin on map?
                        Navigator.of(context).pop();
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
      final MarkerId markerId = MarkerId(eventNameCont.text);
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
                              this.cusWidget = ReusableFunctions.cusWidgetTextField();
                          } else {
                              this.cusIcon = Icon(Icons.search);
                              this.cusWidget = Text("Map View");
                          }
                });
            },
            icon: cusIcon,
          ),
          MyPopupMenu.createPopup(),
        ],
      ),
      body: _initializeMap(),
    );
  }
}