import 'package:app/controllers/eventController.dart';
import 'package:flutter/material.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/reusableFunctions.dart';

import 'package:app/controllers/userController.dart';

import 'package:app/models/fcmToken.dart';


class InviteFriendsPage extends StatefulWidget {
  final String eventId;

  InviteFriendsPage({this.eventId});

  @override
  _InviteFriendsPageState createState() => _InviteFriendsPageState(eventId: eventId);
}

class _InviteFriendsPageState extends State<InviteFriendsPage> {
  String userToken;
  String eventId;

  _InviteFriendsPageState({this.eventId});

  List<String> rows = new List<String>();
  List<String> ids = new List<String>();
  List<bool> follow = new List<bool>();
  Map<String, bool> temp = new Map<String, bool>();
  List<String> usersToInvite = new List<String>();
  var event;
  List<bool>add_button = new List<bool>();


  @override
  void initState() {
    super.initState();
    this.userToken = FCM.getToken();
    //fetch user's friends
    _getUsers().then((result) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Invite Friends"),
        actions: <Widget>[
          MyPopupMenu.createPopup(context),
        ],
      ),
      body: ListView.builder(
        itemBuilder:  (context, index) => this._buildRow(context, index)
      ),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.check),
            backgroundColor: Colors.blue,
            onPressed: () async {
              Navigator.pop(context, usersToInvite);
            }
        )
    );
  }

  _buildRow(BuildContext context, int index) {
    while (rows != null && index < rows.length) {
      final item = rows[index];
      final id = ids[index];
      return new ListTile(
        title: ReusableFunctions.listItemText(item),
        trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                  icon: (eventId == null || add_button[index]) ? Icon(Icons.add, color: Colors.green) : Icon(Icons.add, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      if(eventId == null || add_button[index]) {
                        ReusableFunctions.showInSnackBar(
                            "Friend Invited", context);
                        usersToInvite.add(id);
                      } else {
                        ReusableFunctions.showInSnackBar(
                            "Already Invited", context);
                      }
                    });
                  }
              ),
            ]
        ),
      );
    }
  }

  _getUsers() async {
    if(eventId != null) {
      ///fetch event if this isnt a newly created one
      event = await EventController.getEvent(userToken, eventId);
    }

    setState(() {
      ids.clear();
      rows.clear();
      follow.clear();
    });

    var response = await UserController.getUserFollowers(userToken);
    if(response != null) {
      response.forEach((key, value){
          ids.add(key);

          if(eventId == null || (event['followers'].toString().length == 2 && event['invited'].toString().length == 2)) {
            add_button.add(true);
          } else if(event['followers'].toString().contains(key.toString()) || event['invited'].toString().contains(key.toString())) {
            add_button.add(false);
          } else {
            add_button.add(true);
          }

          temp = value;
          value.forEach((name, following){
            rows.add(name);
            follow.add(!following);
          });
      });
    }
  }
}