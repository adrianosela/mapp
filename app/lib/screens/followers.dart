import 'package:flutter/material.dart';

import 'package:app/components/drawerWidget.dart';
import 'package:app/components/reusableFunctions.dart';
import 'package:app/components/router.dart';

import 'package:app/controllers/userController.dart';

import 'package:app/models/fcmToken.dart';


class FollowersPage extends StatefulWidget {

  @override
  _FollowersPageState createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  String userToken;

  List<String> rows = new List<String>();
  List<String> ids = new List<String>();
  List<bool> following = new List<bool>();
  List<bool> follow = new List<bool>();
  Map<String, bool> temp = new Map<String, bool>();


  @override
  void initState() {
    super.initState();
    this.userToken = FCM.getToken();
    ///fetch user's friends
    _getUsers().then((result) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Followers"),
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
      return Card (
          child:ListTile(
        title: ReusableFunctions.listItemText(item),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          IconButton(
              icon: (follow[index]) ? new Icon(Icons.person_add, color: Colors.green) : new Icon(Icons.check, color: Colors.grey),
              onPressed: () {
                setState(() {
                  if(follow[index]) {
                    ReusableFunctions.showInSnackBar(
                        "Followed User", context);
                    UserController.followUser(userToken, id);
                    follow[index] = false;
                  } else {
                    ReusableFunctions.showInSnackBar(
                        "Already Following", context);
                  }
                });
              }
          ),
        ]),
      ));
    }
  }

  _getUsers() async {
    setState(() {
      ids.clear();
      rows.clear();
      follow.clear();
    });
    var response = await UserController.getUserFollowers(userToken);
    if(response != null) {
      response.forEach((key, value){
        ids.add(key);
        temp = value;
        value.forEach((name, following){
          rows.add(name);
          follow.add(!following);
        });
      });
    }
  }
}