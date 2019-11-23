import 'package:flutter/material.dart';

import 'package:app/components/router.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Constants {
  static const String Logout = "Logout";

  static const List<String> choices = <String>[
    Logout
  ];
}

///side logout menu
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

  static void choiceAction(String choice) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', null);
    Navigator.pushNamedAndRemoveUntil(mycontext, Router.homeRoute, (_) => false);
  }
}

