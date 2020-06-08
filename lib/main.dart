import 'package:flutter/material.dart';

import 'home.dart';

void main() => runApp(Home());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('All Sirsa'),
        ),
        body: Home(),
      ),
    );
  }
}
