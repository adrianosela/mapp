import 'package:flutter/material.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/reusableFunctions.dart';
import 'package:app/components/reusableStlyes.dart';

import 'package:app/controllers/userController.dart';



class InviteFriendsPage extends StatefulWidget {

  final String userId;
  InviteFriendsPage({this.userId});

  @override
  _InviteFriendsPageState createState() => _InviteFriendsPageState(userId: userId);
}

class _InviteFriendsPageState extends State<InviteFriendsPage> {

  final String userId;
  _InviteFriendsPageState({this.userId});

  Icon cusIcon = Icon(Icons.search);
  Widget cusWidget = Text("Invite Friends");
  List<String> rows;
  var searchText;


  @override
  void initState() {
    super.initState();
    //fetch user's friends
    _getUsers();
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
                  this.cusWidget = Text("Invite Friends");
                }
              });
            },
            icon: cusIcon,
          ),
          MyPopupMenu.createPopup(context),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => this._buildRow(context, index)
      ),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.check),
            backgroundColor: Colors.blue,
            onPressed: (){
              Navigator.of(context).pop();
            }
        )
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
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() async {
                      ReusableFunctions.showInSnackBar(
                          "Friend Invited", context);
                      //TODO send call to backend
                    });
                  }
              ),
            ]
        ),
      );
    }
  }

  ///TODO
  _getUsers() async {
    var response = await UserController.getUser(userId);
    if(response != null) {
      for(String item in response) {
        rows.add(item);
      }
    }
  }
}