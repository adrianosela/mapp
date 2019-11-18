import 'package:flutter/material.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/reusableFunctions.dart';
import 'package:app/components/reusableStlyes.dart';

import 'package:app/controllers/userController.dart';

import 'package:app/models/fcmToken.dart';

import 'package:app/screens/inviteToEventsScreen.dart';

class FriendsPage extends StatefulWidget {
  final Map<String, String> events;

  FriendsPage({this.events});

  @override
  _FriendsPageState createState() => _FriendsPageState(events: events);
}

class _FriendsPageState extends State<FriendsPage> {
  String userToken;
  final Map<String, String> events;

  _FriendsPageState({this.events});

  Icon cusIcon = Icon(Icons.search);
  Widget cusWidget = Text("My Friends");
  List<String> rows = new List<String>();
  List<String> ids = new List<String>();
  var searchText;

  bool canAdd = false;

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
                        canAdd = true;
                        _getSearch(searchText);
                      });
                    },
                  );
                } else {
                  this.cusIcon = Icon(Icons.search);
                  this.cusWidget = Text("Friends");
                  setState(() {
                    canAdd = false;
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

      if (canAdd) {
        return ListTile(
          title: ReusableFunctions.listItemText(item),
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
          title: ReusableFunctions.listItemText(item),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            IconButton(
                icon: Icon(Icons.note_add, color: Colors.green),
                onPressed: () async {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new InviteToEventsPage(
                              events: events, userId: id)));
                }),
            IconButton(
                icon: Icon(Icons.delete_forever, color: Colors.red),
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
          rows.add(name);
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
      print("here");
      print(search);
      print(response);
      response.forEach((id, name) {
        setState(() {
          ids.add(id);
          rows.add(name);
        });
      });
    }
  }
}
