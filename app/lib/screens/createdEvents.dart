import 'package:app/controllers/eventController.dart';
import 'package:flutter/material.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/reusableFunctions.dart';
import 'package:app/components/router.dart';

import 'package:app/controllers/userController.dart';

import 'package:app/models/fcmToken.dart';
import 'package:app/models/eventModel.dart';
import 'package:app/screens/eventScreen.dart';

class CreatedEventsPage extends StatefulWidget {
  @override
  _CreatedEventsPageState createState() => _CreatedEventsPageState();
}

class _CreatedEventsPageState extends State<CreatedEventsPage> {
  String userToken;

  List<String> rows = new List<String>();
  List<String> ids = new List<String>();

  ///vars for edit event alert dialog
  var eventDate;
  var eventDuration;
  final _formKey = GlobalKey<FormState>();
  TextEditingController announcementCont = TextEditingController();
  bool isSwitched;
  @override
  void initState() {
    super.initState();
    this.userToken = FCM.getToken();
    _getCreatedEvents().then((result) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Created Events"),
        actions: <Widget>[
          MyPopupMenu.createPopup(context),
        ],
      ),
      body: ListView.builder(
          itemBuilder: (context, index) => this._buildRow(context, index)),
    );
  }

  _buildRow(BuildContext context, int index) {
    while (rows != null && index < rows.length) {
      final item = rows[index];
      final id = ids[index];
      return Card(
          child: ListTile(
            title: ReusableFunctions.listItemText(item),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new EventPage(eventId: id)));
            },
            trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              IconButton(
                  icon: Icon(Icons.message, color: Colors.green),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return SimpleDialog(
                              title: ReusableFunctions.titleText(
                                  "Create Announcement"),
                              children: <Widget>[
                                SimpleDialogOption(
                                  child: ReusableFunctions.formInputMultiLine(
                                      "Create Announcement... ", 100, announcementCont),
                                ),
                                SimpleDialogOption(
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: RaisedButton(
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          disabledColor: Colors.grey,
                                          disabledTextColor: Colors.black,
                                          padding: EdgeInsets.all(2.0),
                                          splashColor: Colors.blueAccent,
                                          child: Text("Post"),
                                          onPressed: () async {
                                            if (announcementCont.text
                                                .toString()
                                                .length !=
                                                0) {
                                              await _createAnnouncement(
                                                  announcementCont.text, id);
                                              announcementCont.clear();
                                              Navigator.pop(context);
                                            } else {
                                              _showAlert();
                                            }
                                          }),
                                    )),
                              ],
                            );
                          });
                        });
                  }),
              IconButton(
                  icon: Icon(Icons.edit, color: Colors.green),
                  onPressed: () {
                    setState(() {
                      _update(id);
                    });
                  }),
              IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    setState(() {
                      rows.removeAt(index);
                      ReusableFunctions.showInSnackBar("Event Deleted", context);
                      EventController.deleteEvent(userToken, id);
                    });
                  }),
            ]),
          ));
    }
  }

  _update(String id) async {
    Event event_prev = await EventController.getEventObject(userToken, id);

    TextEditingController eventNameCont =
        TextEditingController(text: event_prev.name);
    TextEditingController eventDescriptionCont =
        TextEditingController(text: event_prev.description);
      setState(() {
        isSwitched = event_prev.public;
      });

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ReusableFunctions.titleText("Update Event"),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: ReusableFunctions.formInput(
                            "Enter Event Name", 30, eventNameCont),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: ReusableFunctions.formInput(
                            "Enter Event Description", 200, eventDescriptionCont),
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
                              'Pick Event Date',
                              style: TextStyle(color: Colors.blue),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: FlatButton(
                            onPressed: () {
                              DatePicker.showTimePicker(context,
                                  
                                  showTitleActions: true,
                                  onChanged: (date) {}, onConfirm: (date) {
                                    eventDuration = date;
                                  },
                                  currentTime: DateTime(0,0,0,0,0),
                                  locale: LocaleType.en);
                            },
                            child: Text(
                              'Pick Event Duration (hh:mm:ss)',
                              style: TextStyle(color: Colors.blue),
                            )),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: Text("Private Event?"),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.14,
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
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: RaisedButton(
                          child: Text("Save"),
                          color: Colors.blue,
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          padding: EdgeInsets.all(2.0),
                          splashColor: Colors.blueAccent,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              if (eventDate == null) {
                                eventDate = event_prev.date;

                              }
                              if (eventDuration == null) {
                                eventDuration = event_prev.duration;

                              }

                              Map<String, dynamic> toJson() => {
                                    'startTime': (eventDate
                                                .toUtc()
                                                .millisecondsSinceEpoch /
                                            1000)
                                        .round(),
                                    'endTime': (eventDate.add(new Duration(hours: eventDuration.hour, minutes: eventDuration.minute))
                                        .toUtc()
                                        .millisecondsSinceEpoch /
                                        1000)
                                        .round(),
                                    'name': eventNameCont.text,
                                    'description': eventDescriptionCont.text,
                                    'public': isSwitched,
                                    'longitude': event_prev.longitude,
                                    'latitude': event_prev.latitude,
                                  };

                              Map<String, dynamic> eventToJson() =>
                                  {'event': toJson(), 'eventId': id};

                              await EventController.updateEvent(
                                  userToken, eventToJson());

                              ///clear text controllers
                              eventNameCont.clear();
                              eventDescriptionCont.clear();

                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.pushNamed(
                                  context, Router.createdEventsRoute);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                )),
          );
        });
  }

  _getCreatedEvents() async {
    setState(() {
      ids.clear();
      rows.clear();
    });

    var response = await UserController.getCreatedEvents(userToken);
    if (response != null) {
      response.forEach((id, name) {
        ids.add(id);
        rows.add(name);
      });
    }
  }

  _createAnnouncement(String announcement, String eventId) async {
    await EventController()
        .createAnnouncement(userToken, eventId, announcement);
  }

  _showAlert() {
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
                      child: Text("Announcement cannot be empty",
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
