import 'package:flutter/material.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/resuableFunctions.dart';

class PendingInvitesPage extends StatefulWidget {

  @override
  _PendingInvitesPageState createState() => _PendingInvitesPageState();
}

class _PendingInvitesPageState extends State<PendingInvitesPage> {

  Icon cusIcon = Icon(Icons.search);
  Widget cusWidget = Text("Pending Invites");
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
                  this.cusWidget = Text("Pending Invites");
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
            width: 210,
          ),
          Container(
            child: IconButton(
              icon: Icon(Icons.check),
              onPressed: (){
                //TODO confirm invite, add event to saved events, show pop-up confirm message, delete item from list
              },
            ),
          ),
          Container(
            child: IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                //TODO cancel invite, show pop-up confirm message, delete item from list
              },
            ),
          ),
        ],
      );
    }
  }
}