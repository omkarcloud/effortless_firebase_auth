import 'package:flutter/material.dart';

void showSnackBar(String msg, BuildContext context) {
  final snackBar = SnackBar(
    content: Text(msg),
    duration: Duration(milliseconds: 6500),
  );
  Scaffold.of(context).showSnackBar(snackBar);
}
