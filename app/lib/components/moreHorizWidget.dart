import 'package:flutter/material.dart';

import 'package:app/components/router.dart';

///
class Constants {
  static const String Settings = "Settings";
  static const String Logout = "Logout";

  static const List<String> choices = <String>[
    Settings,
    Logout,
  ];
}


///
class MyPopupMenu {

  static BuildContext mycontext;

  static PopupMenuButton<String> createPopup(context) {
    mycontext = context;
    return PopupMenuButton<String>(
      onSelected: choiceAction,
      itemBuilder: (BuildContext context) {
        return Constants.choices.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }
        ).toList();
      },
      icon: Icon(Icons.more_horiz),
    );
  }

  static void choiceAction(String choice) {
    if(choice == Constants.Logout) {
      Navigator.pushNamed(mycontext, Router.homeRoute);
    } else if (choice == Constants.Settings) {
      Navigator.pushNamed(mycontext, Router.editSettingsRoute);
    }
  }
}

