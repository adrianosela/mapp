import 'package:flutter/material.dart';

import 'package:app/components/router.dart';
import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/reusableFunctions.dart';
import 'package:app/components/reusableStlyes.dart';


class CreatedEventsPage extends StatefulWidget {

  @override
  _CreatedEventsPageState createState() => _CreatedEventsPageState();
}

class _CreatedEventsPageState extends State<CreatedEventsPage> {

  Icon cusIcon = Icon(Icons.search);
  Widget cusWidget = Text("Created Events");
  List<String> rows = ["1", "2", "3", "4", "5", "6", "7"];
  var searchText;

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
                  this.cusWidget = Text("Created Events");
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
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      Navigator.pushNamed(context, Router.editEventRoute);
                    });
                  }
              ),
            ]
        ),
      );
    }
  }
}