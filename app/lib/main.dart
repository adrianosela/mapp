import 'package:flutter/material.dart';
import 'package:app/screens/map.dart';

void main() => runApp(MyApp());

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

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                    child: TextFormField(
                      /*validator: (value) {
                        if (value.isEmpty) {
                          //TODO
                          return 'Please enter some text';
                        }
                        return null;
                      },*/
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'username'
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 250,
                    child: TextFormField(
                      /*validator: (value) {
                        if (value.isEmpty) {
                          //TODO
                          return 'Please enter some text';
                        }
                        return null;
                      },*/
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'password'
                      ),
                    ),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapPage()),
                    );
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 20.0),
                  ),
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapPage()),
                      );
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