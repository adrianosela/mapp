import 'package:flutter/material.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/resuableFunctions.dart';


class FriendsPage extends StatefulWidget {

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {

  Icon cusIcon = Icon(Icons.search);
  Widget cusWidget = Text("Friends");
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
                  this.cusWidget = Text("Friends");
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
              child: Text(
                "Item " + index.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          Container(
            width: 250,
          ),
          Container(
            child: IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: (){
                //TODO pop-up to invite to an event, or unfriend
              },
            ),
          ),
        ],
      );
    }
  }
}