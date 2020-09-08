import 'package:flutter/material.dart';

void showSnackBar(String msg, BuildContext context) {
  final snackBar = SnackBar(
    content: Text(msg),
    duration: Duration(milliseconds: 4000),
  );
  Scaffold.of(context).showSnackBar(snackBar);
}
