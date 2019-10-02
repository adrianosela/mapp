import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:app/components/reusableStlyes.dart';

class ReusableFunctions{

  //TODO
  static void showInSnackBar(String value, BuildContext context) {
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(value)
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
  static TextField cusWidgetTextField() {
    return new TextField(
      textInputAction: TextInputAction.go,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "search for ...",
      ),
      style: ReusableStyles.cusWidget(),
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
  static TextFormField formInput(String text) {
    return new TextFormField(
      textInputAction: TextInputAction.go,
      decoration: InputDecoration(
        hintText: text,
      ),
      style: ReusableStyles.formInputField(),
    );
  }
}