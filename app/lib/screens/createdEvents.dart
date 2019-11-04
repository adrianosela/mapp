import 'package:flutter/material.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/reusableFunctions.dart';

import 'package:app/controllers/userController.dart';

import 'package:app/models/fcmToken.dart';


class CreatedEventsPage extends StatefulWidget {

  @override
  _CreatedEventsPageState createState() => _CreatedEventsPageState();
}


class _CreatedEventsPageState extends State<CreatedEventsPage> {
  String userToken;

  List<String> rows = new List<String>();
  List<String> ids = new List<String>();

  ///vars for edit event alert dialog
  bool isSwitched = true;
  var eventDate;
  final _formKey = GlobalKey<FormState>();
  TextEditingController eventNameCont = TextEditingController();
  TextEditingController eventDescriptionCont = TextEditingController();
  TextEditingController eventDurationCont = TextEditingController();


  @override
  void initState() {
    super.initState();

    if(userToken == null) {
      this.userToken = FCM.getToken();
    }

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
        // itemCount: this.count,
          itemBuilder: (context, index) => this._buildRow(context, index)
      ),
    );
  }

  _buildRow(BuildContext context, int index) {
    while (rows != null && index < rows.length) {
      final item = rows[index];
      final id = ids[index];
      return ListTile(
        title: ReusableFunctions.listItemTextButton(item, id, context),
        trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _update();
                    });
                  }
              ),
            ]
        ),
      );
    }
  }

  _update() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ReusableFunctions.titleText("Update Event"),
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
                              }, onConfirm: (date) {
                                eventDate = date;
                              }, currentTime: DateTime.now(), locale: LocaleType.en);
                        },
                        child: Text(
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
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: RaisedButton(
                      child: Text("Save"),
                      onPressed: () async {
                        if(_formKey.currentState.validate()) {

                          // TODO backend event update call
                          // TODO snackbar saying event updated

                          ///clear text controllers
                          eventNameCont.clear();
                          eventDescriptionCont.clear();
                          eventDurationCont.clear();
                          
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

  _getCreatedEvents() async {
    var response = await UserController.getCreatedEvents(userToken);
    if(response != null) {
      response.forEach((id, name){
        ids.add(id);
        rows.add(name);
      });
    }
  }
}