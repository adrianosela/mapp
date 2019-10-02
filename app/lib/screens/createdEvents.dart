import 'package:flutter/material.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/resuableFunctions.dart';


class CreatedEventsPage extends StatefulWidget {

  @override
  _CreatedEventsPageState createState() => _CreatedEventsPageState();
}

class _CreatedEventsPageState extends State<CreatedEventsPage> {

  Icon cusIcon = Icon(Icons.search);
  Widget cusWidget = Text("Created Events");
  int count = 0;

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
                  this.cusWidget = Text("Created Events");
                }
              });
            },
            icon: cusIcon,
          ),
          MyPopupMenu.createPopup(),
        ],
      ),
      body: ListView.builder(
        // itemCount: this.count,
          itemBuilder: (context, index) => this._buildRow(index)
      ),
    );
  }

  _buildRow(int index) {
    while(count < 10) {
      count++;
      return Row(
        children: [
          Container(
            width: 100,
            padding: EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () {
                //TODO open info popup
              },
              child: ReusableFunctions.listItemText("Item " + index.toString()),
            ),
          ),
          Container(
            width: 250,
          ),
          Container(
            child: IconButton(
              icon: Icon(Icons.create),
              onPressed: (){
                //TODO pop-up with edit event options
              },
            ),
          ),
        ],
      );
    }
  }
}