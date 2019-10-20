import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:app/components/router.dart';
import 'package:app/components/reusableStlyes.dart';

class ReusableFunctions{

  static TextEditingController usernameController = new TextEditingController();
  static TextEditingController passwordController = new TextEditingController();

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

  //TODO delete?
  /*static TextField cusWidgetTextField() {
    return new TextField(
      textInputAction: TextInputAction.go,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "search for ...",
      ),
      style: ReusableStyles.cusWidget(),
    );
  }*/

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
        //TODO perform authentication
        var username = usernameController.text;
        var password = passwordController.text;
        //print(username.toString());
        //print(password.toString());
        //TODO if successful, then:
        Navigator.pushNamed(context, Router.mapRoute);
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
      //TODO add validation?
      controller: (text == 'username') ? usernameController : passwordController,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: text
      ),
    );
  }

  //TODO
  static String getLoginText(String text) {
    return (text == 'username') ? usernameController.text.toString() : passwordController.text.toString();
  }
}