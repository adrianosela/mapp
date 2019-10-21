import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:app/components/router.dart';
import 'package:app/components/reusableStlyes.dart';

class ReusableFunctions{

  static TextEditingController usernameController = new TextEditingController();
  static TextEditingController passwordController = new TextEditingController();
  static TextEditingController nameController = new TextEditingController();

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
  static Text titleText(String text) {
    return new Text(
      text,
      style: ReusableStyles.formTitle(),
    );
  }

  //TODO
  static TextFormField formInput(String text, [TextEditingController controller]) {
    return new TextFormField(
      textInputAction: TextInputAction.go,
      decoration: InputDecoration(
        hintText: text,
      ),
      controller: controller,
      style: ReusableStyles.formInputField(),
    );
  }

  //TODO
  static FlatButton loginButton(BuildContext context, String text){
    return new FlatButton(
      color: Colors.blue,
      textColor: Colors.white,
      disabledColor: Colors.grey,
      disabledTextColor: Colors.black,
      padding: EdgeInsets.all(8.0),
      splashColor: Colors.blueAccent,
      onPressed: () {
        var username = usernameController.text;
        var password = passwordController.text;
        if(text == "Register") {
          Navigator.pushNamed(context, Router.registerRoute);
        } else {
          //TODO perform authentication
          //Sring result = await LoginController.loginUser("https://mapp-254321.appspot.com/" + "userId");
          Navigator.pushNamed(context, Router.mapRoute);
        }
      },
      child: Text(
        text,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  //TODO
  static TextFormField loginInputField(String text) {
    return new TextFormField(
      validator: (value) {
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

  //TODO
  static String getLoginText(String text) {
    if(text == 'email') return usernameController.text;
    else if (text == 'password') return passwordController.text;
    return nameController.text;
  }
}