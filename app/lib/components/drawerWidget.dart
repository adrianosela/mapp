import 'package:flutter/material.dart';

import 'package:app/screens/calendar.dart';
import 'package:app/screens/createdEvents.dart';
import 'package:app/screens/friends.dart';
import 'package:app/screens/notifications.dart';
import 'package:app/screens/pendingInvites.dart';
import 'package:app/screens/savedEvents.dart';


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
                title: Text('Notifications'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationsPage()),
                  );
                },
              ),
              ListTile(
                title: Text('Friends'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FriendsPage()),
                  );
                },
              ),
              ListTile(
                title: Text('Created Events'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreatedEventsPage()),
                  );
                },
              ),
              ListTile(
                title: Text('Saved Events'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SavedEventsPage()),
                  );
                },
              ),
              ListTile(
                title: Text('Pending Invites'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PendingInvitesPage()),
                  );
                },
              ),
              ListTile(
                title: Text('Calendar'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CalendarPage()),
                  );
                },
              ),
            ],
          ),
      ),
    );
  }
}