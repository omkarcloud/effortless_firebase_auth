import 'package:flutter/material.dart';
// import 'package:firebase/firebase.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Auth',
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Easy Auth'),
          ),
          body: Home(),
        ),
      ),
    );
  }
}
