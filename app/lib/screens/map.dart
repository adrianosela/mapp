import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/resuableFunctions.dart';


class MapPage extends StatefulWidget {

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  Icon cusIcon = Icon(Icons.search);
  Widget cusWidget = Text("Map View");
  final _formKey = GlobalKey<FormState>();
  bool isSwitched = true;

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
          MyPopupMenu.createPopup(context),
        ],
      ),
      body: Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
                          child: ReusableFunctions.formInput("enter event name"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(2.0),
                          child: ReusableFunctions.formInput("enter event description"),
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
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                              }
                              //TODO append event to list of created events, show new pin on map?
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}