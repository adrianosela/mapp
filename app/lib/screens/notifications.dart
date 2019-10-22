import 'package:flutter/material.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/reusableFunctions.dart';
import 'package:app/components/reusableStlyes.dart';

import 'package:firebase_messaging/firebase_messaging.dart';


class NotificationsPage extends StatefulWidget {

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

  Icon cusIcon = Icon(Icons.search);
  Widget cusWidget = Text("Notifications");
  List<String> rows = ["1", "2", "3", "4", "5", "6", "7"];
  var searchText;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    //TODO notifications test
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
        return null;
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
        return null;
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
        return null;
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token){
      print(token);
    });
  }

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
                    style: ReusableStyles.cusWidget(),
                    onSubmitted: (String str) {
                      //TODO send to backend
                      setState(() {
                        searchText = str;
                      });
                    },
                  );
                } else {
                  this.cusIcon = Icon(Icons.search);
                  this.cusWidget = Text("Notifications");
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