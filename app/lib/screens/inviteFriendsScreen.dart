import 'package:flutter/material.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/reusableFunctions.dart';

import 'package:app/controllers/userController.dart';

import 'package:app/models/fcmToken.dart';


class InviteFriendsPage extends StatefulWidget {

  @override
  _InviteFriendsPageState createState() => _InviteFriendsPageState();
}

class _InviteFriendsPageState extends State<InviteFriendsPage> {
  String userToken;

  List<String> rows = new List<String>();
  List<String> ids = new List<String>();
  List<String> usersToInvite = new List<String>();


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
    return Scaffold(
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
      return ListTile(
        title: ReusableFunctions.listItemText(item),
        trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      ReusableFunctions.showInSnackBar("Friend Invited", context);
                      usersToInvite.add(id);
                    });
                  }
              ),
            ]
        ),
      );
    }
  }

  _getUsers() async {
    var response = await UserController.getUserFollowing(userToken);
    if(response != null) {
      response.forEach((key, value){
          ids.add(key);
          rows.add(value);
      });
    }
  }
}