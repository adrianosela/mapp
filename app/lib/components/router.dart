import 'package:flutter/material.dart';

import 'package:app/main.dart';
import 'package:app/screens/createdEvents.dart';
import 'package:app/screens/followers.dart';
import 'package:app/screens/following.dart';
import 'package:app/screens/inviteFriendsScreen.dart';
import 'package:app/screens/map.dart';
import 'package:app/screens/pendingInvites.dart';
import 'package:app/screens/registerScreen.dart';
import 'package:app/screens/savedEvents.dart';
import 'package:app/screens/searchedEvents.dart';
import 'package:app/screens/eventScreen.dart';

class Router {
  static const String homeRoute = '/';
  static const String createdEventsRoute = '/createdEvents';
  static const String followersRoute = '/followers';
  static const String followingRoute = '/following';
  static const String inviteRoute = '/inviteFriends';
  static const String mapRoute = '/map';
  static const String pendingInvitesRoute = '/pendingInvites';
  static const String registerRoute = '/registerRoute';
  static const String savedEventsRoute = '/savedEvents';
  static const String searchedEventsRoute = '/searchedEvents';
  static const String eventRoute = '/event';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case createdEventsRoute:
        return MaterialPageRoute(builder: (_) => CreatedEventsPage());
      case followersRoute:
        return MaterialPageRoute(builder: (_) => FollowersPage());
      case followingRoute:
        return MaterialPageRoute(builder: (_) => FollowingPage());
      case inviteRoute:
        return MaterialPageRoute(builder: (_) => InviteFriendsPage());
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
      case eventRoute:
        return MaterialPageRoute(builder: (_) => EventPage());
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
