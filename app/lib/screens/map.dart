import 'package:flutter/material.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';


class MapPage extends StatefulWidget {

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  Icon cusIcon = Icon(Icons.search);
  Widget cusWidget = Text("Map View");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        /*leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: (){
            MyDrawer();
          },
        ),*/
        title: cusWidget,
        actions: <Widget>[
          IconButton(
            onPressed: (){
                setState(() {
                          if(this.cusIcon.icon == Icons.search) {
                              this.cusIcon = Icon(Icons.cancel);
                              this.cusWidget = TextField(
                                textInputAction: TextInputAction.go,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "search for ...",
                                ),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              );
                          } else {
                              this.cusIcon = Icon(Icons.search);
                              this.cusWidget = Text("Map View");
                          }
                });
            },
            icon: cusIcon,
          ),
          PopupMenuButton<String>(
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
          ),
        ],
      ),
      body: Center(),
    );
  }
}