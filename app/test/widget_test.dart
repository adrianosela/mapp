// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';
import 'package:app/screens/registerScreen.dart';
import 'package:app/screens/map.dart';
import 'package:app/screens/createdEvents.dart';
import 'package:app/screens/friends.dart';
import 'package:app/screens/pendingInvites.dart';
import 'package:app/screens/savedEvents.dart';

void main() {
  //todo add login test
  testWidgets('Add and remove a todo', (WidgetTester tester) async {
    //build the widget
    await tester.pumpWidget(MyHomePage());

    //find the saved events widget
    expect(find.byWidget(MyHomePage()), findsOneWidget);

  });


  //todo add register test
  testWidgets('Add and remove a todo', (WidgetTester tester) async {
    //build the widget
    await tester.pumpWidget(RegisterPage());

    //find the created events widget
    expect(find.byWidget(RegisterPage()), findsOneWidget);
  });


  //todo add map test
  testWidgets('Add and remove a todo', (WidgetTester tester) async {
    //build the widget
    await tester.pumpWidget(MapPage());

    //find the created events widget
    expect(find.byWidget(MapPage()), findsOneWidget);
  });


  testWidgets('Add and remove a todo', (WidgetTester tester) async {
    //build the widget
    await tester.pumpWidget(CreatedEventsPage());

    //find the created events widget
    expect(find.byWidget(CreatedEventsPage()), findsOneWidget);
  });


  testWidgets('Add and remove a todo', (WidgetTester tester) async {
    //build the widget
    await tester.pumpWidget(FriendsPage());

    //find the friends widget
    expect(find.byWidget(FriendsPage()), findsOneWidget);
  });


  testWidgets('Add and remove a todo', (WidgetTester tester) async {
    //build the widget
    await tester.pumpWidget(PendingInvitesPage());

    //find the pending invites widget
    expect(find.byWidget(PendingInvitesPage()), findsOneWidget);
  });


  testWidgets('Add and remove a todo', (WidgetTester tester) async {
    //build the widget
    await tester.pumpWidget(SavedEventsPage());

    //find the saved events widget
    expect(find.byWidget(SavedEventsPage()), findsOneWidget);
  });
}
