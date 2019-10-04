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
  List<String> rows = ["1", "2", "3", "4", "5", "6", "7"];

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
          MyPopupMenu.createPopup(context),
        ],
      ),
      body: ListView.builder(
        // itemCount: this.count,
          itemBuilder: (context, index) => this._buildRow(context, index)
      ),
    );
  }

  _buildRow(BuildContext context, int index) {
    while (index < rows.length) {
      final item = rows[index];
      return ListTile(
        //TODO make title clickable
        title: ReusableFunctions.listItemText("Item " + item),
        trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    setState(() {
                      rows.removeAt(index);
                      ReusableFunctions.showInSnackBar(
                          "Invite accepted", context);
                      //TODO send call to backend to accept
                    });
                  }
              ),
              IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      rows.removeAt(index);
                      ReusableFunctions.showInSnackBar(
                          "Invite rejected", context);
                      //TODO send call to backend to delete
                    });
                  }
              ),
            ]
        ),
      );
    }
  }
}