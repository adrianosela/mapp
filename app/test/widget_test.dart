// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/gestures.dart';

import 'package:app/main.dart';
import 'package:app/screens/registerScreen.dart';
import 'package:app/screens/map.dart';
import 'package:app/screens/createdEvents.dart';
import 'package:app/screens/friends.dart';
import 'package:app/screens/pendingInvites.dart';
import 'package:app/screens/savedEvents.dart';


const PointerDownEvent down = PointerDownEvent(
  pointer: 5,
  position: Offset(10, 10),
);


void main() {

  testWidgets('Test Login Page', (WidgetTester tester) async {

    await tester.pumpWidget(new MyApp());

    Finder email = find.byKey(new Key('login'));
    Finder pwd = find.byKey(new Key('password'));

    Finder formWidgetFinder = find.byType(Form);
    Form formWidget = tester.widget(formWidgetFinder) as Form;
    GlobalKey<FormState> formKey = formWidget.key as GlobalKey<FormState>;

    expect(formKey.currentState.validate(), isFalse);

    await tester.enterText(email, "email@email.com");
    await tester.enterText(pwd, "123456textemptynot");
    await tester.pump();

    expect(formKey.currentState.validate(), isTrue);

    Finder loginButton = find.byKey(new Key('login_button'));

    await tester.tap(loginButton);
  });



  testWidgets('Test Register Page input fields', (WidgetTester tester) async {

    RegisterPage page = new RegisterPage();
    var app = new MediaQuery(data: new MediaQueryData(), child: new MaterialApp(home: page));

    await tester.pumpWidget(app);

    Finder name = find.byKey(new Key('name'));
    Finder email = find.byKey(new Key('login'));
    Finder pwd = find.byKey(new Key('password'));

    Finder formWidgetFinder = find.byType(Form);
    Form formWidget = tester.widget(formWidgetFinder) as Form;
    GlobalKey<FormState> formKey = formWidget.key as GlobalKey<FormState>;

    expect(formKey.currentState.validate(), isFalse);

    await tester.enterText(name, "name");
    await tester.enterText(email, "email@email.com");
    await tester.enterText(pwd, "123456textemptynot");
    await tester.pump();

    expect(formKey.currentState.validate(), isTrue);

  });



  testWidgets('Test Create Event functionality', (WidgetTester tester) async {

    MapPage page = new MapPage();
    var app = new MediaQuery(data: new MediaQueryData(), child: new MaterialApp(home: page));

    await tester.pumpWidget(app);

    Finder press = find.byKey(new Key('longpress'));

    await tester.longPress(press);
    await tester.pump();
    await tester.pump(const Duration(seconds: 5));

    Finder search = find.byKey(new Key('search'));

    //TODO press search isnt pressing
    await tester.press(search);
    //TODO need to find how to pass radius into getevents call


  });

  //TODO create event test

}
