import 'package:effortless_firebase_auth/Methods/email.dart';
import 'package:effortless_firebase_auth/infrastructure/base.dart';
import 'package:effortless_firebase_auth/infrastructure/baseui.dart';
import 'package:effortless_firebase_auth/infrastructure/utils.dart';
import 'package:effortless_firebase_auth/screens/signUp.dart';
import 'package:effortless_firebase_auth/screens/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:global_wings/global_wings.dart';

class SignUp extends StatefulWidget {
  final List<AuthMethod> methods;
  final FirebaseAuth auth;
  final Function3<User, BuildContext, Map<String, dynamic>, dynamic> onSuccess;
  final Color themeColor;
  final Widget privacyPolicy;

  SignUp(
      {@required this.auth,
      @required this.methods,
      @required this.onSuccess,
      Key key,
      @required this.themeColor,
      @required this.privacyPolicy})
      : super(key: key);

  @override
  _SignUpState createState() {
    return _SignUpState();
  }
}

bool hasEmail(List<AuthMethod> methods) {
  return methods.any((element) => element.getName() == 'email');
}

const smalltextStyle = TextStyle(
    fontSize: 12,
    color: const Color(0xFF000000),
    fontWeight: FontWeight.w500,
    fontFamily: "Roboto");

Color _c;
void setColor(Color a) {
  assert(isNonNull(a));
  _c = a;
}

Color getColor() {
  assert(isNonNull(_c));
  return _c;
}

class _SignUpState extends State<SignUp> {
  // Could be moved to constructor here it is to facilitate hot reload
  void setUp() {
    setAuth(widget.auth);
    setColor(widget.themeColor);
    widget.methods.forEach((element) {
      element.setOnSuccess(widget.onSuccess);
      element.themeColor = widget.themeColor;
      element.inSignIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    setUp();
    return (wrap(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Px50(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: buildText(
                  'Sign up for your account',
                ),
              ),
            ),
            Px20(),
            ...getSSOWidget(),
            hasEmail(widget.methods)
                ? Column(
                    children: [
                      widget.methods.length == 1 ? Container() : OrWidget(),
                      getEmailWidget(),
                    ],
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Already have an account? Sign In',
                  style: smalltextStyle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: widget.privacyPolicy),
            )
          ],
        ),
      ),
    ));
  }

  List<Widget> getSSOWidget() {
    return widget.methods
        .where((element) => element.getName() == SingleSignOn)
        .toList()
        .map((e) {
      return e.getSignInWidget();
    }).toList();
  }

  Widget getEmailWidget() {
    return widget.methods
        .where((element) => element.getName() == 'email')
        .toList()
        .map((e) {
      return e.getSignInWidget();
    }).toList()[0];
  }
}
