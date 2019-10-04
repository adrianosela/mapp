import 'package:flutter/material.dart';

import 'package:app/components/router.dart';


class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

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
                  Navigator.pushNamed(context, Router.friendsRoute);
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