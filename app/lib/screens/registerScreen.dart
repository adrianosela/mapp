import 'package:flutter/material.dart';

import 'package:app/components/moreHorizWidget.dart';
import 'package:app/components/drawerWidget.dart';
import 'package:app/components/reusableFunctions.dart';
import 'package:app/components/router.dart';

import 'package:app/models/userModel.dart';

import 'package:app/controllers/loginController.dart';



class RegisterPage extends StatefulWidget {

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  var userId;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Register"),
        actions: <Widget>[
          MyPopupMenu.createPopup(context),
        ],
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 250,
                  child: ReusableFunctions.loginInputField('Name'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 250,
                  child: ReusableFunctions.loginInputField('Email'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 250,
                  child: ReusableFunctions.loginInputField('Password'),
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

                      ///check that all form's fields have user-entered values
                      if (_formKey.currentState.validate()) {

                        //send new user info to backend
                        User user = new User(
                            name: ReusableFunctions.getLoginText('name'),
                            email: ReusableFunctions.getLoginText('email'),
                            password: ReusableFunctions.getLoginText('password')
                        );

                        var response = await LoginController.registerUser(
                            "https://mapp-254321.appspot.com/register",
                            user.toJson());

                        if(response == "User with that email already exists"
                            || response == "Unauthorized"
                            || response == "Could not save new user"
                            || response == "Could not save new user settings") {
                          //alert error to the user
                          ReusableFunctions.ackAlert(context, response);
                        } else {
                          //save userId
                          user.userId = response;
                          _showAlert();
                        }
                      }
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

  _showAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Text(
                        "Succesfully Registered",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0
                        )
                    )
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(3.0),
                    splashColor: Colors.blueAccent,
                    child: Text("Ok",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0
                        )),
                    onPressed: () async {
                      //navigate to login screen
                      Navigator.pushNamedAndRemoveUntil(context, Router.homeRoute, (_) => false);
                    },
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}