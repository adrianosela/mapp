import 'package:flutter/material.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/reusableFunctions.dart';

import 'package:app/controllers/userController.dart';

import 'package:app/models/fcmToken.dart';


class PendingInvitesPage extends StatefulWidget {

  @override
  _PendingInvitesPageState createState() => _PendingInvitesPageState();
}

class _PendingInvitesPageState extends State<PendingInvitesPage> {

  String userToken;

  List<String> rows = new List<String>();
  List<String> ids = new List<String>();

  @override
  void initState() {
    super.initState();
    this.userToken = FCM.getToken();
    _getPendingInvites().then((result) {
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Pending Invites"),
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
      final id = ids[index];
      return ListTile(
        title: ReusableFunctions.listItemTextButton(item, id, context),
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
                      UserController.postSubscribe(userToken, _toJson(id));
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
                      UserController.postNotGoing(userToken, _toJson(id));
                    });
                  }
              ),
            ]
        ),
      );
    }
  }

  _getPendingInvites() async {
    var response = await UserController.getPendingEvents(userToken);
    if(response != null) {
      response.forEach((id, name){
        ids.add(id);
        rows.add(name);
      });
    }
  }

  Map<String, dynamic> _toJson(id) => {
    'eventIds' : id
  };
}