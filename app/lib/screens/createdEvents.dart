import 'package:flutter/material.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';


class CreatedEventsPage extends StatefulWidget {

  @override
  _CreatedEventsPageState createState() => _CreatedEventsPageState();
}

class _CreatedEventsPageState extends State<CreatedEventsPage> {

  Icon cusIcon = Icon(Icons.search);
  Widget cusWidget = Text("Created Events");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
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
                  this.cusWidget = Text("Created Events");
                }
              });
            },
            icon: cusIcon,
          ),
        ],
      ),
      body: Center(),
    );
  }
}