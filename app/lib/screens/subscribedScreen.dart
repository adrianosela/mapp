import 'package:app/controllers/eventController.dart';
import 'package:flutter/material.dart';

import 'package:app/components/drawerWidget.dart';
import 'package:app/components/reusableFunctions.dart';
import 'package:app/components/router.dart';

import 'package:app/controllers/userController.dart';

import 'package:app/models/fcmToken.dart';


class SubscribedPage extends StatefulWidget {

  final String eventId;
  SubscribedPage({this.eventId});
  @override
  _SubscribedPageState createState() => _SubscribedPageState(eventId: this.eventId);
}

class _SubscribedPageState extends State<SubscribedPage> {
  String userToken;

  List<String> rows = new List<String>();
  List<String> ids = new List<String>();

  final String eventId;

  _SubscribedPageState({this.eventId});

  @override
  void initState() {
    super.initState();
    this.userToken = FCM.getToken();
    ///fetch going users
    _getUsers().then((result) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Subscribers"),
      ),
      body: ListView.builder(
        // itemCount: this.count,
          itemBuilder: (context, index) => this._buildRow(context, index)),
    );
  }

  _buildRow(BuildContext context, int index) {
    while (rows != null && index < rows.length) {
      final item = rows[index];
      return Card (
          child:ListTile(
        title: ReusableFunctions.listItemText(item),
      ));
    }
  }

  _getUsers() async {
    setState(() {
      rows.clear();
    });

    var response = await EventController.getSubscribedUsers(userToken, eventId);
    rows = response;
  }
}