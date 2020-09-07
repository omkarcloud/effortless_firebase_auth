import 'package:allsirsa/Methods/email.dart';
import 'package:allsirsa/infrastructure/base.dart';
import 'package:allsirsa/infrastructure/baseui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final List<AuthMethod> methods;
  final FirebaseAuth auth;
  final Function3<User, BuildContext, Map<String, dynamic>, dynamic> onSuccess;
  final Color themeColor;
  final Widget privacyPolicy;

  SignIn(
      {@required this.auth,
      @required this.methods,
      @required this.onSuccess,
      Key key,
      this.themeColor = Colors.blue,
      this.privacyPolicy = const Text(
          "By continuing, you agree to Wattpad's Terms of Service and Privacy Policy.")})
      : super(key: key);

  @override
  _SignInState createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignIn> {
  // Could be moved to constructor here it is to facilitate hot reload
  void setUp() {
    setAuth(widget.auth);
    widget.methods.forEach((element) {
      element.setOnSuccess(widget.onSuccess);
    });
  }

  @override
  Widget build(BuildContext context) {
    setUp();

    return SafeArea(
      child: Scaffold(
        body: Container(),
      ),
    );
  }
}
