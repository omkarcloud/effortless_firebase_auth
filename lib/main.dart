import 'package:flutter/material.dart';

import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material Application',
      home: Scaffold(
        appBar: AppBar(
          title: Text('All sssssssssssss'),
        ),
        body: Home(),
      ),
    );
  }
}
