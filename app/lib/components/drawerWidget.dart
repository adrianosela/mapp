import 'package:flutter/material.dart';

import 'package:back_button_interceptor/back_button_interceptor.dart';

import 'package:app/components/router.dart';

import 'package:app/screens/friends.dart';


class MyDrawer extends StatefulWidget {
  final String userId;
  final String userToken;
  final Map<String, String> events;
  MyDrawer({this.userId, this.userToken, this.events});

  @override
  _MyDrawerState createState() => _MyDrawerState(userId: userId, userToken: userToken, events: events);
}

class _MyDrawerState extends State<MyDrawer> {
  final String userId;
  final String userToken;
  final Map<String, String> events;
  _MyDrawerState({this.userId, this.userToken, this.events});

  //TODO works but getting a bunch of errors when reloading map page??
  // TODO test on an actual device and see if events pop up
  /*@override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  ///forces back navigation to map screen
  bool myInterceptor(bool stopDefaultButtonEvent) {
    Navigator.pushNamedAndRemoveUntil(context, Router.mapRoute, (_) => false);
    return true;
  }*/

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
                title: Text('Friends'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FriendsPage(events: events)));
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