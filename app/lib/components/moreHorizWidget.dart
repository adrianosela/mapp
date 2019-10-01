import 'package:flutter/material.dart';

class Constants {
  static const String Settings = "Settings";
  static const String Logout = "Logout";

  static const List<String> choices = <String>[
    Settings,
    Logout,
  ];
}

class MyPopupMenu {
  static PopupMenuButton<String> createPopup() {
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
}

void choiceAction(String choice) {
  if(choice == Constants.Logout) {
    //TODO pop context stack
  } else if (choice == Constants.Settings) {
    //TODO open settings pop up
  }
}