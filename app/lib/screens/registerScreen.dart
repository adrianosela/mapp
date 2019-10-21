import 'package:flutter/material.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/resuableFunctions.dart';
import 'package:app/components/reusableStlyes.dart';
import 'package:app/components/router.dart';
import 'package:app/models/userModel.dart';
import 'package:app/controllers/loginController.dart';


class RegisterPage extends StatefulWidget {

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  Icon cusIcon = Icon(Icons.search);
  Widget cusWidget = Text("Register");
  var searchText;
  var userId;

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
                  this.cusWidget = Text("Register");
                }
              });
            },
            icon: cusIcon,
          ),
          MyPopupMenu.createPopup(context),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Container(
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 250,
                  child: ReusableFunctions.loginInputField('name'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 250,
                  child: ReusableFunctions.loginInputField('email'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 250,
                  child: ReusableFunctions.loginInputField('password'),
                ),
              ),
              SizedBox(
                width: 250,
                child: FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () async {
                    //send new user info to backend
                    User user = new User(name: ReusableFunctions.getLoginText('name'),
                        email: ReusableFunctions.getLoginText('email'),
                        password: ReusableFunctions.getLoginText('password')
                    );
                    print("=================");
                    print(ReusableFunctions.getLoginText('first name'));
                    print(ReusableFunctions.getLoginText('email'));
                    //save userId
                    userId = await LoginController.registerUser("https://mapp-254321.appspot.com/register", user.toJson());
                    print(userId.toString());
                    //navigate to map screen
                    Navigator.pushNamed(context, Router.mapRoute);
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(fontSize: 20.0),
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}