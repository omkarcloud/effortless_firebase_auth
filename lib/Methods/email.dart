import 'dart:async';

import 'package:allsirsa/Methods/forgot.password.dart';
import 'package:allsirsa/home.dart';
import 'package:allsirsa/infrastructure/baseui.dart';
import 'package:allsirsa/infrastructure/utils.dart';
import 'package:allsirsa/infrastructure/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:global_wings/store.dart';
import 'package:meta/meta.dart';
import 'package:nice_button/nice_button.dart';

Future resetPassword(FirebaseAuth fa, String email) async {
  await fa.sendPasswordResetEmail(email: email);
}

Future emailVerify(FirebaseAuth fa) async {
  User uu = fa.currentUser;
  await uu.sendEmailVerification();
}

Future<UserCredential> register(String email, String password) async {
  final user = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email, password: password);
  return user;
}

List<Widget Function(GlobalKey<FormBuilderState>)> getSignInFields() {
  return [
    emailFeild,
    passwordFeild,
  ].map((e) {
    return ((GlobalKey<FormBuilderState> a) => fieldToFormField(e, a));
  }).toList();
}

List<Widget Function(GlobalKey<FormBuilderState>)> getSignUpFields() {
  return [
    nameField,
    emailFeild,
    passwordFeild,
  ].map((e) {
    return ((GlobalKey<FormBuilderState> a) => fieldToFormField(e, a));
  }).toList();
}

class EmailConfig {
  List<Function1<GlobalKey<FormBuilderState>, Widget>> signIn;
  List<Function1<GlobalKey<FormBuilderState>, Widget>> signUp;

  EmailConfig({this.signIn = const [], this.signUp = const []}) {
    if ((this.signIn.isEmpty)) {
      this.signIn = getSignInFields();
    }
    if ((this.signUp.isEmpty)) {
      this.signUp = getSignUpFields();
    }
  }
}

class Email extends BaseUI {
  final EmailConfig config;
  Email({@required this.config});

  Future<bool> perform(
      {@required String email, @required String password}) async {
    final a = TextFormField(
        validator: EmailValidator(errorText: 'enter a valid email address'));
    try {
      var fa = FirebaseAuth.instance;
      await fa.signInWithEmailAndPassword(email: email, password: password);
      currUser().reload();

      await emailVerify(fa);
      await resetPassword(fa, email);
    } catch (e) {
      print(e);
    }
  }

  @override
  bool isProvidingFullLayout() {
    return true;
  }

  @override
  String errMsg(e, bool isFirebaseException, FirebaseExceptionData fe) {
    print('errMsg $e $isFirebaseException $fe');
    return 'sss';
  }

  @override
  Future sign(bool isInSignIn, FirebaseAuth auth) async {
    final email = serve('email');
    final password = serve('password');

    assert(isNonNull(email));
    assert(isNonNull(password));

    if (isInSignIn) {
      await auth.signInWithEmailAndPassword(email: email, password: password);

      currUser().sendEmailVerification();
      Timer.periodic(Duration(seconds: 3), (Timer t) async {
        final user = currUser();
        await user.reload();
        print(
            'firebase auth user state ${currUser().emailVerified} local function user state ${currUser().emailVerified}');
      });
    } else {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    }
  }

  @override
  Widget getLayout(bool isInSignIn) {
    if (isInSignIn) {
      return Builder(builder: (context) {
        return Column(
          children: [
            Formok(
                fields: config.signIn,
                onSuccess: () async {
                  await beginTheFlow(context);
                }),
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen()));
                  },
                  child: Text(
                    'Forgot password?',
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(
                    //           MaterialPageRoute(
                    //             builder: (context) => Demo2Page()
                    //           ),
                  },
                  child: Text(
                    'Don\'t have an account? Sign Up',
                  )),
            ),
          ],
        );
      });
    } else {
      return Builder(builder: (context) {
        return Column(
          children: [
            Formok(
              fields: config.signUp,
              onSuccess: () async {
                await beginTheFlow(context);
              },
            ),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Already have an account? Sign In',
                )),
          ],
        );
      });
    }
  }
}

typedef A Function0<A>();

class Formok extends StatefulWidget {
  final List<Function1<GlobalKey<FormBuilderState>, Widget>> fields;
  final Function0 onSuccess;
  const Formok({
    Key key,
    this.fields,
    @required this.onSuccess,
  }) : super(key: key);

  @override
  _FormokState createState() => _FormokState();
}

final theme = Colors.blue;

class _FormokState extends State<Formok> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FormBuilder(
          key: _fbKey,
          autovalidate: false,
          child: Column(
            children: [...widget.fields.map((e) => e(_fbKey)).toList()],
          ),
        ),
        Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: NiceButton(
                  elevation: 8.0,
                  text: "Submit",
                  radius: 40,
                  fontSize: 14,
                  background: theme,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
