import 'package:flutter/material.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/reusableFunctions.dart';

import 'package:app/controllers/userController.dart';


class SavedEventsPage extends StatefulWidget {
  final String userToken;
  SavedEventsPage({this.userToken});

  @override
  _SavedEventsPageState createState() => _SavedEventsPageState(userToken: userToken);
}


class _SavedEventsPageState extends State<SavedEventsPage> {

  final String userToken;
  _SavedEventsPageState({this.userToken});

  List<String> rows = new List<String>();

  @override
  void initState() {
    super.initState();
    _getSubscribedEvents().then((result) {
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Saved Events"),
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
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      rows.removeAt(index);
                      ReusableFunctions.showInSnackBar(
                          "Unsibscribed", context);
                      //TODO send call to backend - user no longer going to event
                    });
                  }
              ),
            ]
        ),
      );
    }
  }

  //TODO finish this call
  _getSubscribedEvents() async {
    var response = await UserController.getSubscribedEvents(userToken);
    print("-NNNNNNNNNNNNNNNNNNNNNNNNNNN-----------");
    print(response);
  }
}