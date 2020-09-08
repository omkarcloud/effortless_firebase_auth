import 'package:allsirsa/Methods/email.dart';
import 'package:allsirsa/infrastructure/base.dart';
import 'package:allsirsa/infrastructure/baseui.dart';
import 'package:allsirsa/infrastructure/utils.dart';
import 'package:allsirsa/screens/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:global_wings/global_wings.dart';

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
        "By continuing, you agree to our Terms of Service and Privacy Policy.",
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 12,
            color: const Color(0xFF000000),
            fontWeight: FontWeight.w500,
            fontFamily: "Roboto"),
      )})
      : super(key: key);

  @override
  _SignInState createState() {
    return _SignInState();
  }
}

bool hasEmail(List<AuthMethod> methods) {
  return methods.any((element) => element.getName() == 'email');
}

Color _c;
void setColor(Color a) {
  assert(isNonNull(a));
  _c = a;
}

Color getColor() {
  assert(isNonNull(_c));
  return _c;
}

/**
* A simple and no headache solution to implement Responsiveness
* It uses the Widely accepted simple fact that you can bascially limit the maxwidth and center the Screen to make it look good on tablets and Desktops.
* It is used by the library to implement responsiveness for all screens (viz SignIn, SignUp, EmalVerify...)
*    
*     wrap(() => ScreenToBeMadeResponsive());
*
* PROTIP: To visually see how app looks on different screen sizes see the package device_preview:https://pub.dev/packages/device_preview/ 
*/

Widget wrap(Function0<Widget> f) {
  return Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Center(
            child: Container(
                constraints: BoxConstraints(minWidth: 100, maxWidth: 400),
                child: f())),
      ),
    ),
  );
}

class _SignInState extends State<SignIn> {
  // Could be moved to constructor here it is to facilitate hot reload
  void setUp() {
    setAuth(widget.auth);
    setColor(widget.themeColor);
    widget.methods.forEach((element) {
      element.setOnSuccess(widget.onSuccess);
      element.themeColor = widget.themeColor;
      element.inSignIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    setUp();
    return (wrap(() => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Px50(),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: buildText(
                    'Log in to your account',
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignUp(
                                auth: widget.auth,
                                methods: widget.methods,
                                onSuccess: widget.onSuccess,
                                privacyPolicy: widget.privacyPolicy,
                                themeColor: widget.themeColor,
                              )));
                    },
                    child: Text(
                      'Don\'t have an account? Sign Up',
                      style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF000000),
                          fontWeight: FontWeight.w500,
                          fontFamily: "Roboto"),
                    )),
              ),
            ],
          ),
        )));
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

class Px20 extends StatelessWidget {
  const Px20({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
    );
  }
}

class Px50 extends StatelessWidget {
  const Px50({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
    );
  }
}

Text buildText(String s) {
  return Text(
    s,
    style: new TextStyle(
        fontSize: 20,
        color: const Color(0xFF000000),
        fontWeight: FontWeight.w900,
        fontFamily: "Roboto"),
  );
}

class OrWidget extends StatelessWidget {
  const OrWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 0.5,
                  color: Colors.black,
                ),
              ),
              Text(
                '   OR   ',
                style: new TextStyle(
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w700,
                    fontFamily: "Roboto"),
              ),
              Expanded(
                child: Container(
                  height: 0.5,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
