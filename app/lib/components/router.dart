import 'package:flutter/material.dart';

import 'package:app/main.dart';
import 'package:app/screens/calendar.dart';
import 'package:app/screens/createdEvents.dart';
import 'package:app/screens/editEventPage.dart';
import 'package:app/screens/editSettingsPage.dart';
import 'package:app/screens/friends.dart';
import 'package:app/screens/inviteFriendsScreen.dart';
import 'package:app/screens/map.dart';
import 'package:app/screens/notifications.dart';
import 'package:app/screens/pendingInvites.dart';
import 'package:app/screens/registerScreen.dart';
import 'package:app/screens/savedEvents.dart';

class Router {

  static const String homeRoute = '/';
  static const String calendarRoute = '/calendar';
  static const String createdEventsRoute = '/createdEvents';
  static const String editEventRoute = '/createdEvents/editEvent';
  static const String editSettingsRoute = '/editSettings';
  static const String friendsRoute = '/friends';
  static const String inviteRoute = '/inviteFriends';
  static const String mapRoute = '/map';
  static const String notificationsRoute = '/notifications';
  static const String pendingInvitesRoute = '/pendingInvites';
  static const String registerRoute = '/registerRoute';
  static const String savedEventsRoute = '/savedEvents';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case calendarRoute:
        return MaterialPageRoute(builder: (_) => CalendarPage());
      case createdEventsRoute:
        return MaterialPageRoute(builder: (_) => CreatedEventsPage());
      case editEventRoute:
        return MaterialPageRoute(builder: (_) => EditEventPage());
      case editSettingsRoute:
        return MaterialPageRoute(builder: (_) => EditSettingsPage());
      case friendsRoute:
        return MaterialPageRoute(builder: (_) => FriendsPage());
      case inviteRoute:
        return MaterialPageRoute(builder: (_) => InviteFriendsPage());
      case mapRoute:
        return MaterialPageRoute(builder: (_) => MapPage());
      case notificationsRoute:
        return MaterialPageRoute(builder: (_) => NotificationsPage());
      case pendingInvitesRoute:
        return MaterialPageRoute(builder: (_) => PendingInvitesPage());
      case registerRoute:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case savedEventsRoute:
        return MaterialPageRoute(builder: (_) => SavedEventsPage());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                  child: Text('No route defined for ${settings.name}')
              ),
            )
        );
    }
  }
}