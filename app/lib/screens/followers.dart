import 'package:flutter/material.dart';

import 'package:app/components/drawerWidget.dart';
import 'package:app/components/reusableFunctions.dart';

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
      return ListTile(
        title: ReusableFunctions.listItemText(item),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          IconButton(
              icon: Icon(Icons.person_add, color: Colors.green),
              onPressed: () {
                UserController.followUser(userToken, id);
                setState(() {});
              }),
        ]),
      );
    }
  }

  _getUsers() async {
    setState(() {
      ids.clear();
      rows.clear();
    });
    var response = await UserController.getUserFollowers(userToken);
    if (response != null) {
      response.forEach((id, name) {
        setState(() {
          ids.add(id);
          rows.add(name);
        });
      });
    }
  }
}