import 'package:flutter/material.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/resuableFunctions.dart';


class EditEventPage extends StatefulWidget {

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {

  Icon cusIcon = Icon(Icons.search);
  Widget cusWidget = Text("Edit Event");

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
                  this.cusWidget = ReusableFunctions.cusWidgetTextField();
                } else {
                  this.cusIcon = Icon(Icons.search);
                  this.cusWidget = Text("Edit Event");
                }
              });
            },
            icon: cusIcon,
          ),
          MyPopupMenu.createPopup(context),
        ],
      ),
      body: Center(),
    );
  }
}