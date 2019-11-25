import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

import 'package:app/components/reusableFunctions.dart';
import 'package:app/components/router.dart';

import 'package:app/models/userModel.dart';

import 'package:app/controllers/loginController.dart';



class RegisterPage extends StatefulWidget {

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _formKey = GlobalKey<FormState>();
  bool expanded = false;

  @protected
  void initState() {
    super.initState();

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          expanded = visible;
        });
        print(expanded);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                width: (!expanded) ? 200 : 0,
                height: (!expanded) ? 200 : 0,
                child: Image.asset("assets/mapp_icon.png"),
              ),
              Padding(
                padding: (!expanded) ? EdgeInsets.all(15.0) : EdgeInsets.all(0.0),
              ),
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
                            name: ReusableFunctions.getLoginText('Name'),
                            email: ReusableFunctions.getLoginText('Email'),
                            password: ReusableFunctions.getLoginText('Password')
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
              Padding(
                padding: (!expanded) ? EdgeInsets.all(15.0) : EdgeInsets.all(0.0),
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