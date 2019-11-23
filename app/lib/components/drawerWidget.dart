import 'package:flutter/material.dart';

import 'package:app/components/router.dart';

import 'package:app/models/fcmToken.dart';


class MyDrawer extends StatefulWidget {

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  String userToken;

  @override
  void initState() {
    super.initState();
    userToken = FCM.getToken();
  }


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
                  Navigator.pushNamedAndRemoveUntil(context, Router.mapRoute, (_) => false);
                },
              ),
              ListTile(
                title: Text('Followers'),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context, Router.mapRoute, (_) => false);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyDrawer()));
                  Navigator.pushNamed(context, Router.followersRoute);
                },
              ),
              ListTile(
                title: Text('Following'),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context, Router.mapRoute, (_) => false);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyDrawer()));
                  Navigator.pushNamed(context, Router.followingRoute);
                },
              ),
              ListTile(
                title: Text('Created Events'),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context, Router.mapRoute, (_) => false);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyDrawer()));
                  Navigator.pushNamed(context, Router.createdEventsRoute);
                },
              ),
              ListTile(
                title: Text('Saved Events'),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context, Router.mapRoute, (_) => false);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyDrawer()));
                  Navigator.pushNamed(context, Router.savedEventsRoute);
                },
              ),
              ListTile(
                title: Text('Pending Invites'),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context, Router.mapRoute, (_) => false);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyDrawer()));
                  Navigator.pushNamed(context, Router.pendingInvitesRoute);
                },
              ),
            ],
          ),
      ),
    );
  }
}