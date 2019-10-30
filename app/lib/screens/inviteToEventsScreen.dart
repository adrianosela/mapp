import 'package:flutter/material.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/reusableFunctions.dart';


class InviteToEventsPage extends StatefulWidget {

  //id of the friend that user wants to invite to events
  final String userId;
  final  Map<String, String> events;
  InviteToEventsPage({this.userId, this.events});

  @override
  _InviteToEventsPageState createState() => _InviteToEventsPageState(userId: userId, events: events);
}


//TODO change this
class _InviteToEventsPageState extends State<InviteToEventsPage> {

  final String userId;
  final  Map<String, String> events;
  _InviteToEventsPageState({this.userId, this.events});

  Icon cusIcon = Icon(Icons.search);
  Widget cusWidget = Text("Invite To Evens(s)");
  List<String> rows = new List<String>();
  List<String> ids = new List<String>();
  List<String> inviteToEvents = new List<String>();
  var searchText;


  @override
  void initState() {
    super.initState();
    _getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          title: cusWidget,
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

              //TODO send call to backend to invite user to all events
              //inviteToEvents, userId
              Navigator.pop(context);
            }
        )
    );
  }

  _buildRow(BuildContext context, int index) {
    while (rows != null && index < rows.length) {
      final item = rows[index];
      final id = ids[index];
      return ListTile(
        //TODO make title clickable
        title: ReusableFunctions.listItemText(item),
        trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      ReusableFunctions.showInSnackBar("Friend Invited to Event", context);
                      inviteToEvents.add(id);
                    });
                  }
              ),
            ]
        ),
      );
    }
  }

  ///TODO
  _getEvents() {
    if(events != null) {
      events.forEach((key, value){
        ids.add(key);
        rows.add(value);
      });
    }
  }
}