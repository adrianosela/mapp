import 'package:flutter/material.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/reusableFunctions.dart';

class PendingInvitesPage extends StatefulWidget {
  final String userToken;
  PendingInvitesPage({this.userToken});

  @override
  _PendingInvitesPageState createState() => _PendingInvitesPageState(userToken: userToken);
}

class _PendingInvitesPageState extends State<PendingInvitesPage> {

  final String userToken;
  _PendingInvitesPageState({this.userToken});

  List<String> rows = new List<String>();

  @override
  void initState() {
    super.initState();
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
    while (index < rows.length) {
      final item = rows[index];
      return ListTile(
        //TODO make title clickable
        title: ReusableFunctions.listItemText(item),
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

  //TODO finish this call
  _getPendingInvites() async {
  }
}