import 'package:allsirsa/Methods/email.dart';
import 'package:allsirsa/Methods/fb.dart';
import 'package:allsirsa/Methods/google.dart';
import 'package:allsirsa/Methods/phone.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

var L = Logger();

class Home extends StatelessWidget {
  Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    perform();

    return Container(
      child: Text("Hello from Home"),
    );
  }

  perform() async {
    // await signOut();
    // logUser();
    return await facebookDemo();
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future googleDemo() async {
    final google = Google();
    await google.perform();
  }

  Future facebookDemo() async {
    final fb = Facebook();
    await fb.perform();
  }

  Future phoneDemo() async {
    final phone = Phone();
    await phone.perform();
  }

  Future emailDemo() async {
    final email = Email();
    await email.perform(email: 'chetansirsa@gmail.com', password: '12345678');
  }
}

User currUser() {
  return FirebaseAuth.instance.currentUser;
}

logUser() {
  L.i(currUser());
}
