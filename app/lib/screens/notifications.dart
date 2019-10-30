import 'package:flutter/material.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/reusableFunctions.dart';


class NotificationsPage extends StatefulWidget {

  final String msg;
  NotificationsPage({this.msg});

  @override
  _NotificationsPageState createState() => _NotificationsPageState(msg: msg);
}

class _NotificationsPageState extends State<NotificationsPage> {

  final String msg;
  _NotificationsPageState({this.msg});

  Icon cusIcon = Icon(Icons.search);
  Widget cusWidget = Text("Notifications");
  List<String> rows = new List<String>();
  var searchText;

  @override
  void initState() {
    super.initState();
    rows.add(msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: cusWidget,
        actions: <Widget>[
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
    while (rows != null && index < rows.length) {
      final item = rows[index];
      return ListTile(
          //TODO make title clickable
          title: ReusableFunctions.listItemText("Item " + item),
          trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        rows.removeAt(index);
                        ReusableFunctions.showInSnackBar(
                            "Notification deleted", context);
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