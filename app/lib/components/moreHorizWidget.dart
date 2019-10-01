//import 'package:flutter/material.dart';

class Constants {
  static const String Settings = "Settings";
  static const String Logout = "Logout";

  static const List<String> choices = <String>[
    Settings,
    Logout,
  ];
}

void choiceAction(String choice) {
  if(choice == Constants.Logout) {
    //TODO pop context stack
  } else if (choice == Constants.Settings) {
    //TODO open settings pop up
  }
}

/*class MoreBox extends StatefulWidget {
  @override
  _MoreBoxState createState() => _MoreBoxState();
}

class _MoreBoxState extends State<MoreBox> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 100,
        width: 100,
        child: PopupMenuButton<String>(
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
        ),
      ),
    );
  }
}*/