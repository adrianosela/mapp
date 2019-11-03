import 'package:flutter/material.dart';

import 'package:app/main.dart';
import 'package:app/screens/createdEvents.dart';
import 'package:app/screens/editSettingsPage.dart';
import 'package:app/screens/friends.dart';
import 'package:app/screens/inviteFriendsScreen.dart';
import 'package:app/screens/inviteToEventsScreen.dart';
import 'package:app/screens/map.dart';
import 'package:app/screens/pendingInvites.dart';
import 'package:app/screens/registerScreen.dart';
import 'package:app/screens/savedEvents.dart';
import 'package:app/screens/searchedEvents.dart';

class Router {

  static const String homeRoute = '/';
  static const String createdEventsRoute = '/createdEvents';
  static const String editSettingsRoute = '/editSettings';
  static const String friendsRoute = '/friends';
  static const String inviteRoute = '/inviteFriends';
  static const String inviteToRoute = '/inviteToEvents';
  static const String mapRoute = '/map';
  static const String pendingInvitesRoute = '/pendingInvites';
  static const String registerRoute = '/registerRoute';
  static const String savedEventsRoute = '/savedEvents';
  static const String searchedEventsRoute = '/searchedEvents';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case createdEventsRoute:
        return MaterialPageRoute(builder: (_) => CreatedEventsPage());
      case editSettingsRoute:
        return MaterialPageRoute(builder: (_) => EditSettingsPage());
      case friendsRoute:
        return MaterialPageRoute(builder: (_) => FriendsPage());
      case inviteRoute:
        return MaterialPageRoute(builder: (_) => InviteFriendsPage());
      case inviteToRoute:
        return MaterialPageRoute(builder: (_) => InviteToEventsPage());
      case mapRoute:
        return MaterialPageRoute(builder: (_) => MapPage());
      case pendingInvitesRoute:
        return MaterialPageRoute(builder: (_) => PendingInvitesPage());
      case registerRoute:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case savedEventsRoute:
        return MaterialPageRoute(builder: (_) => SavedEventsPage());
      case searchedEventsRoute:
        return MaterialPageRoute(builder: (_) => SearchedEventsPage());
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