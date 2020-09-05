import 'package:allsirsa/Methods/email.dart';
import 'package:allsirsa/Methods/google.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final email = Google();
    email.perform();
    return Container(
      child: Text("Hello from Home"),
    );
  }
}
