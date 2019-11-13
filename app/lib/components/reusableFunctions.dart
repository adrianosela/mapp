import 'package:flutter/material.dart';

import 'package:app/components/router.dart';
import 'package:app/components/reusableStlyes.dart';

import 'package:app/controllers/loginController.dart';
import 'package:app/controllers/eventController.dart';

import 'package:app/models/userModel.dart';
import 'package:app/models/fcmToken.dart';

import 'package:app/screens/map.dart';

class ReusableFunctions{

  static TextEditingController usernameController = new TextEditingController();
  static TextEditingController passwordController = new TextEditingController();
  static TextEditingController nameController = new TextEditingController();
  static var userToken;

  //TODO
  static void showInSnackBar(String value, BuildContext context) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      duration: const Duration(seconds: 2),
    ));
  }

  //TODO
  static Text listItemText(String text) {
    return new Text(
      text,
      style: ReusableStyles.listItem(),
    );
  }

  //TODO
  static GestureDetector listItemTextButton(String text, String id, context) {
    return new GestureDetector(
      child: Text(
        text,
        style: ReusableStyles.listItem(),
      ),
      onTap: () async {
        var response = await EventController.getEvent(userToken, id.toString());
        //TODO add styling
        showDialog(
            context: context,
            builder: (BuildContext context)
            {
              return AlertDialog(
                content: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ReusableFunctions.titleText("Event Details"),
                      Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text("Event Name: " + response["name"].toString())
                      ),
                      Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                              "Description: " + response["description"].toString())
                      ),
                      Padding(
                          padding: EdgeInsets.all(2.0),
                          //TODO fix how this is displayed
                          child: Text("Start Time: " +
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(response["startTime"]) * 1000)
                                  .toString())
                      ),
                      Padding(
                          padding: EdgeInsets.all(2.0),
                          //TODO fix how this is displayed
                          child: Text("End Time: " +
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(response["endTime"]) * 1000).toString())
                      ),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text((response["privateEvent"] == "true")
                            ? "Private Event"
                            : "Public Event"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: RaisedButton(
                          child: Text("Ok"),
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
        );
      },
    );
  }

  //TODO
  static Text titleText(String text) {
    return new Text(
      text,
      style: ReusableStyles.formTitle(),
    );
  }

  //TODO
  static TextFormField formInput(String text, [TextEditingController controller]) {
    return new TextFormField(
      validator: (value) {
        if(text == "enter event duration (hours)" && !RegExp("^([0-9]|[1-3][0-9][0-9]|400)").hasMatch(value)) {
          return 'Event duration must be a number smaller than 400';
        }
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      textInputAction: TextInputAction.go,
      decoration: InputDecoration(
        hintText: text,
      ),
      controller: controller,
      style: ReusableStyles.formInputField(),
    );
  }

  /// login/ register button constructor
  static FlatButton loginButton(BuildContext context, String text, GlobalKey<FormState> _formKey){

    return new FlatButton(
      color: Colors.blue,
      textColor: Colors.white,
      disabledColor: Colors.grey,
      disabledTextColor: Colors.black,
      padding: EdgeInsets.all(8.0),
      splashColor: Colors.blueAccent,
      onPressed: () async {

        if(text == "Register") {

          Navigator.pushNamed(context, Router.registerRoute);

        } else {
          if (_formKey.currentState.validate()) {

            User user = new User(
                name: nameController.text,
                email: usernameController.text,
                password: passwordController.text
            );

            var response = await LoginController.loginUser(
                "https://mapp-254321.appspot.com/login",
                user.toJson());

            if(response == "User with that email already exists"
                || response == "Unauthorized"
                || response == "Could not save new user") {
              //alert error to the user
              ReusableFunctions.ackAlert(context, response);
            } else {
              //save user token
              userToken = response;
              FCM.setToken(userToken);
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => new MapPage(
                      userToken: userToken.toString())));
            }

            ///cleanup
            nameController.clear();
            usernameController.clear();
            passwordController.clear();
          }
        }
      },
      child: Text(
        text,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  ///input field constructor
  static TextFormField loginInputField(String text) {
    return new TextFormField(
      obscureText: (text == 'password') ? true : false,
      validator: (value) {
        if(text == 'email' && !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
          return 'Invalid email';
        }
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      controller: (text == 'email') ? usernameController : ((text == 'password') ? passwordController : nameController),
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: text
      ),
    );
  }

  ///returns input field text
  static String getLoginText(String text) {
    var returnText;

    if(text == 'email') {
      returnText = usernameController.text;
      usernameController.clear();
    } else if (text == 'password') {
      returnText = passwordController.text;
      passwordController.clear();
    } else {
      returnText = nameController.text;
      nameController.clear();
    }
    return returnText;
  }

  ///returns user token
  static String getToken() {
    return userToken;
  }

  ///TODO add styling?
  static Future<void> ackAlert(BuildContext context, String response) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(response),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}