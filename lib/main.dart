import 'package:allsirsa/Methods/email.dart';
import 'package:allsirsa/Methods/send.email.dart';
import 'package:allsirsa/screens/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      home: SignIn(
        methods: [Email(config: EmailConfig())],
        auth: FirebaseAuth.instance,
        onSuccess: (user, buildContext, fields) {},
      ),
    );
  }
}
