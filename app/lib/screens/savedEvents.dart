import 'package:flutter/material.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/reusableFunctions.dart';
import 'package:app/components/router.dart';

import 'package:app/controllers/userController.dart';

import 'package:app/models/fcmToken.dart';

import 'package:app/screens/eventScreen.dart';


class SavedEventsPage extends StatefulWidget {
  @override
  _SavedEventsPageState createState() => _SavedEventsPageState();
}

class _SavedEventsPageState extends State<SavedEventsPage> {
  String userToken;

  List<String> rows = new List<String>();
  List<String> ids = new List<String>();
  List<bool> buttons = new List<bool>();

  @override
  void initState() {
    super.initState();
    this.userToken = FCM.getToken();
    _getSubscribedEvents().then((result) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Saved Events"),
        actions: <Widget>[
          MyPopupMenu.createPopup(context),
        ],
      ),
      body: ListView.builder(
          // itemCount: this.count,
          itemBuilder: (context, index) => this._buildRow(context, index)),
    );
  }

  _buildRow(BuildContext context, int index) {
    while (rows != null && index < rows.length) {
      final item = rows[index];
      final id = ids[index];
      return new Card(
          child: ListTile(
        title: ReusableFunctions.listItemText(item),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new EventPage(eventId: id)));
        },
        trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                  icon: (buttons[index]) ? new Icon(Icons.cancel, color: Colors.green) : new Icon(Icons.cancel, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      if(buttons[index]) {
                        ReusableFunctions.showInSnackBar(
                            "Unsubscribed", context);
                        UserController.postUnsubscribe(userToken, _toJson(id));
                        Navigator.pop(context);
                        Navigator.pushNamed(context, Router.savedEventsRoute);
                      } else {
                        ReusableFunctions.showInSnackBar(
                            "Creator Cannot Unsubscribe", context);
                      }
                    });
                  }
              ),
            ]
        ),
      ));
    }
  }

  _getSubscribedEvents() async {
    setState(() {
      ids.clear();
      rows.clear();
      buttons.clear();
    });

    var response = await UserController.getSubscribedEvents(userToken);
    var responseCreated = await UserController.getCreatedEvents(userToken);

    if (response != null) {
      response.forEach((id, name) {
        ids.add(id);
        rows.add(name);
        buttons.add(true);
      });
    }

    if(responseCreated != null) {
      responseCreated.forEach((id, name) {
        ids.add(id);
        rows.add(name);
        buttons.add(false);
      });
    }
  }

  Map<String, dynamic> _toJson(id) => {
    'eventIds' : id
  };
}
