import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ReusableStyles {

  /// list item text style
  static TextStyle listItem() {
    return new TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
  }

  /// search widget text style
  static TextStyle cusWidget() {
    return new TextStyle(
      color: Colors.white,
      fontSize: 16.0,
    );
  }
}