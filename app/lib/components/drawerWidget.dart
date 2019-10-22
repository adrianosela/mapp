import 'package:flutter/material.dart';

import 'package:app/components/router.dart';
import 'package:app/screens/friends.dart';


class MyDrawer extends StatefulWidget {
  final String userId;
  final String userToken;
  MyDrawer({this.userId, this.userToken});

  @override
  _MyDrawerState createState() => _MyDrawerState(userId: userId, userToken: userToken);
}

class _MyDrawerState extends State<MyDrawer> {
  final String userId;
  final String userToken;
  _MyDrawerState({this.userId, this.userToken});

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
                  Navigator.pushNamed(context, Router.notificationsRoute);
                },
              ),
              ListTile(
                title: Text('Friends'),
                onTap: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => new FriendsPage(userId: userId, userToken: userToken)));
                  //Navigator.pushNamed(context, Router.friendsRoute);
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
              ListTile(
                title: Text('Calendar'),
                onTap: () {
                  Navigator.pushNamed(context, Router.calendarRoute);
                },
              ),
            ],
          ),
      ),
    );
  }
}