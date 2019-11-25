import 'package:flutter/material.dart';

import 'package:app/components/router.dart';
import 'package:app/components/reusableStlyes.dart';

import 'package:app/controllers/loginController.dart';

import 'package:app/models/userModel.dart';
import 'package:app/models/fcmToken.dart';

import 'package:shared_preferences/shared_preferences.dart';


class ReusableFunctions{

  static TextEditingController usernameController = new TextEditingController();
  static TextEditingController passwordController = new TextEditingController();
  static TextEditingController nameController = new TextEditingController();
  static var userToken;

  ///confirmation message alert
  static void showInSnackBar(String value, BuildContext context) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      duration: const Duration(seconds: 2),
    ));
  }

  ///sidebar list items
  static Text listItemText(String text) {
    return new Text(
      text,
      style: ReusableStyles.listItem(),
    );
  }

  ///any widget title heading
  static Text titleText(String text) {
    return new Text(
      text,
      style: ReusableStyles.formTitle(),
    );
  }

  ///create/update event form input fields
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

  static TextFormField formInputMultiLine(String text, [TextEditingController controller]) {
    return new TextFormField(
      textInputAction: TextInputAction.go,
      decoration: InputDecoration(
        hintText: text,
      ),
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: null,
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
      key: (text == "Login") ? new Key('login_button') : new Key('register_button'),
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
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('token', userToken);
              Navigator.pushNamedAndRemoveUntil(context, Router.mapRoute, (_) => false);

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
      key: (text == 'password') ? new Key('password') : ((text == 'email') ? new Key('login') : new Key('name')),
      obscureText: (text == 'Password') ? true : false,
      validator: (value) {
        if(text == 'Email' && !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
          return 'Invalid email';
        }
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      controller: (text == 'Email') ? usernameController : ((text == 'Password') ? passwordController : nameController),
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: text
      ),
    );
  }

  ///returns input field text
  static String getLoginText(String text) {
    var returnText;

    if(text == 'Email') {
      returnText = usernameController.text;
      usernameController.clear();
    } else if (text == 'Password') {
      returnText = passwordController.text;
      passwordController.clear();
    } else {
      returnText = nameController.text;
      nameController.clear();
    }
    return returnText;
  }

  ///used in registration confirmation
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