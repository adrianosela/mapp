import 'package:flutter/material.dart';

import 'package:app/components/router.dart';
import 'package:app/screens/friends.dart';
import 'package:app/screens/notifications.dart';

class MyDrawer extends StatefulWidget {
  final String userId;
  final String userToken;
  final String msg;
  final Map<String, String> events;
  MyDrawer({this.userId, this.userToken, this.msg, this.events});

  @override
  _MyDrawerState createState() => _MyDrawerState(userId: userId, userToken: userToken, msg: msg, events: events);
}

class _MyDrawerState extends State<MyDrawer> {
  final String userId;
  final String userToken;
  final String msg;
  final Map<String, String> events;
  _MyDrawerState({this.userId, this.userToken, this.msg, this.events});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(
                height: 100,
                child:  DrawerHeader(
                  child: Text('MAPP Menu'),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
              ),
              ListTile(
                title: Text('Map'),
                onTap: () {
                  Navigator.pushNamed(context, Router.mapRoute);
                },
              ),
              ListTile(
                title: Text('Notifications'),
                onTap: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => new NotificationsPage(msg: msg)));
                },
              ),
              ListTile(
                title: Text('Friends'),
                onTap: () {
                  //TODO remove userid, usertoken
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => new FriendsPage(userToken: userToken, events: events)));
                },
              ),
              ListTile(
                title: Text('Created Events'),
                onTap: () {
                  Navigator.pushNamed(context, Router.createdEventsRoute);
                },
              ),
              ListTile(
                title: Text('Saved Events'),
                onTap: () {
                  Navigator.pushNamed(context, Router.savedEventsRoute);
                },
              ),
              ListTile(
                title: Text('Pending Invites'),
                onTap: () {
                  Navigator.pushNamed(context, Router.pendingInvitesRoute);
                },
              ),
            ],
          ),
      ),
    );
  }
}