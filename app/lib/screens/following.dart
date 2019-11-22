import 'package:flutter/material.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/reusableFunctions.dart';
import 'package:app/components/reusableStlyes.dart';

import 'package:app/controllers/userController.dart';

import 'package:app/models/fcmToken.dart';


class FollowingPage extends StatefulWidget {
  final Map<String, String> events;

  FollowingPage({this.events});

  @override
  _FollowingPageState createState() => _FollowingPageState(events: events);
}

class _FollowingPageState extends State<FollowingPage> {
  String userToken;
  final Map<String, String> events;

  _FollowingPageState({this.events});

  Icon cusIcon = Icon(Icons.search);
  Widget cusWidget = Text("Following");
  List<List<String>> rows = new List<List<String>>();
  List<String> ids = new List<String>();
  var searchText;


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
        title: cusWidget,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                if (this.cusIcon.icon == Icons.search) {
                  this.cusIcon = Icon(Icons.cancel);
                  this.cusWidget = TextField(
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "search for ...",
                    ),
                    style: ReusableStyles.cusWidget(),
                    onSubmitted: (String str) {
                      setState(() {
                        searchText = str;
                        _getSearch(searchText);
                      });
                    },
                  );
                } else {
                  this.cusIcon = Icon(Icons.search);
                  this.cusWidget = Text("Following");
                  setState(() {
                    _getUsers();
                  });
                }
              });
            },
            icon: cusIcon,
          ),
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

      if (item[1] == "false") {
        return ListTile(
          title: ReusableFunctions.listItemText(item[0]),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            IconButton(
                icon: Icon(Icons.person_add, color: Colors.green),
                onPressed: () {
                  UserController.followUser(userToken, id);
                  setState(() {
                    rows.removeAt(index);
                  });
                }),
          ]),
        );
      } else {
        return ListTile(
          title: ReusableFunctions.listItemText(item[0]),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  UserController.unfollowUser(userToken, id);
                  setState(() {
                    rows.removeAt(index);
                  });
                }),
          ]),
        );
      }
    }
  }

  _getUsers() async {
    setState(() {
      ids.clear();
      rows.clear();
    });
    var response = await UserController.getUserFollowing(userToken);
    if (response != null) {
      response.forEach((id, name) {
        setState(() {
          ids.add(id);
          rows.add([name, "true"]);
        });
      });
    }
  }

  _getSearch(String search) async {
    setState(() {
      ids.clear();
      rows.clear();
    });
    var response = await UserController.searchUsers(userToken, search);
    if (response != null) {
      response.forEach((id, user) {
        setState(() {
          ids.add(id);
          rows.add(user);
        });
      });
    }
  }
}
