import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:corsac_jwt/corsac_jwt.dart';

import 'package:app/components/router.dart';
import 'package:app/components/reusableFunctions.dart';

import 'package:app/models/fcmToken.dart';


// This will works always for lock screen Orientation.
void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Welcome to MAPP'),
      onGenerateRoute: Router.generateRoute,
      initialRoute: Router.homeRoute,
    );
  }
}


/// Login Page
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

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

    _login();

  }

  _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    if(token != null){
      var decodedToken = new JWT.parse(token);
      if( DateTime.fromMillisecondsSinceEpoch(decodedToken.expiresAt*1000).isAfter(DateTime.now().add(new Duration(hours: 1)))){
        await FCM.setToken(token);
        await Navigator.pushNamedAndRemoveUntil(context, Router.mapRoute, (_) => false);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                width: (!expanded) ? 180 : 0,
                height: (!expanded) ? 180 : 0,
                child: (!expanded) ? Image.asset("assets/mapp_icon.png") : null,
              ),
              Padding(
                padding: (!expanded) ? EdgeInsets.all(15.0) : EdgeInsets.all(0.0),
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
                child: ReusableFunctions.loginButton(context, "Login", _formKey),
              ),
              SizedBox(
                width: 250,
                child: ReusableFunctions.loginButton(context, "Register", _formKey),
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
}