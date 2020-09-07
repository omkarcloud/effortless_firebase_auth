import 'dart:async';

import 'package:allsirsa/Methods/email.dart';
import 'package:allsirsa/Methods/fb.dart';
import 'package:allsirsa/Methods/google.dart';
import 'package:allsirsa/Methods/phone.dart';
import 'package:allsirsa/infrastructure/base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:global_wings/global_wings.dart';
import 'package:logger/logger.dart';

var L = Logger();

// Please check your email inbox (a@g.com) for steps to reset your password.
// By continuing, you agree to Wattpad's Terms of Service and Privacy Policy.
class Home extends StatelessWidget {
  Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final phone = Email(config: EmailConfig());
    Timer.periodic(Duration(seconds: 3), (Timer t) async {
      final user = currUser();
      await user.reload();
      // print(
      //     'firebase auth user state ${currUser().emailVerified} local function user state ${currUser().emailVerified}');
    });

    phone.inSignIn = true;
    save('email', 'chetansirsa11@gmail.com');
    save('password', '12345678');

    phone.sign(true, getAuth());
    return SingleChildScrollView(
      child: Column(
        children: [phone.getSignInWidget()],
      ),
    );
  }

  perform() async {
    // await signOut();
    // logUser();
    await phoneDemo();
    // return await facebookDemo();
  }

  Future signOut() async {
    await getAuth().signOut();
  }

  Future googleDemo() async {
    final dynamic google = Google();
    print(google.ss);
    return;
    await google.perform();
  }

  Future facebookDemo() async {
    final fb = Facebook();
    await fb.perform();
  }

  Future phoneDemo() async {
    final phone = Phone();
    phone.inSignIn = true;
    await phone.beginSigning();
  }

  Future emailDemo() async {
    final email = Email();
    await email.perform(email: 'chetansirsa@gmail.com', password: '12345678');
  }
}

User currUser() {
  return getAuth().currentUser;
}

logUser() {
  L.i(currUser());
}
