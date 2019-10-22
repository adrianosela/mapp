import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:app/components/router.dart';
import 'package:app/components/reusableStlyes.dart';
import 'package:app/models/userModel.dart';
import 'package:app/controllers/loginController.dart';

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

  ///login/ register button constructor
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

            //save user token
            userToken = await LoginController.loginUser(
                "https://mapp-254321.appspot.com/login",
                user.toJson());

            Navigator.pushNamed(context, Router.mapRoute);
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

  ///returns input field text
  static String getLoginText(String text) {
    if(text == 'email') return usernameController.text;
    else if (text == 'password') return passwordController.text;
    return nameController.text;
  }

  ///returns user token
  static String getToken() {
    return userToken;
  }
}