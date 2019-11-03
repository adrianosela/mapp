import 'package:app/models/eventModel.dart';
import 'package:flutter/material.dart';
import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/reusableFunctions.dart';
import 'package:app/controllers/userController.dart';


class SearchedEventsPage extends StatefulWidget {
  final String userToken;
  final List<Event> events;
  SearchedEventsPage({this.userToken, this.events});

  @override
  _SearchedEventsPageState createState() => _SearchedEventsPageState(userToken: userToken, events: this.events);
}


class _SearchedEventsPageState extends State<SearchedEventsPage> {

  final String userToken;
  final List<Event> events;
  _SearchedEventsPageState({this.userToken, this.events});

  List<String> rows = new List<String>();
  List<String> ids = new List<String>();



  @override
  void initState() {
    super.initState();
    _createSearchedEvents().then((result) {
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Search Results"),
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
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _goToEventPage();
                    });
                  }
              ),
            ]
        ),
      );
    }
  }

  _goToEventPage() {
    //TODO

  }

  _createSearchedEvents() async {
    if(events != null) {
      for(Event event in events) {
        ids.add(event.eventId);
        rows.add(event.name);
      }
    }
  }
}