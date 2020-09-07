import 'dart:async';

import 'package:allsirsa/Methods/forgot.password.dart';
import 'package:allsirsa/Methods/send.email.dart';
import 'package:allsirsa/home.dart';
import 'package:allsirsa/infrastructure/base.dart';
import 'package:allsirsa/infrastructure/baseui.dart';
import 'package:allsirsa/infrastructure/utils.dart';
import 'package:allsirsa/infrastructure/validators.dart';
import 'package:allsirsa/screens/signUp.dart';
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
  final user = await getAuth()
      .createUserWithEmailAndPassword(email: email, password: password);
  return user;
}

List<Widget Function(GlobalKey<FormBuilderState>)> getSignInFields() {
  return [
    emailFeild,
    passwordFeild,
  ].map((e) {
    return ((GlobalKey<FormBuilderState> a) => fieldToFormField(e, a, (v) {
          if (isFirstTimeSubmittedSignIn) {
            a.currentState.saveAndValidate();
          }
        }));
  }).toList();
}

List<Widget Function(GlobalKey<FormBuilderState>)> getSignUpFields() {
  return [
    nameField,
    emailFeild,
    passwordFeild,
  ].map((e) {
    return ((GlobalKey<FormBuilderState> a) => fieldToFormField(e, a, (v) {
          if (isFirstTimeSubmittedSignUp) {
            a.currentState.saveAndValidate();
          }
        }));
  }).toList();
}

class EmailConfig {
  List<Function1<GlobalKey<FormBuilderState>, Widget>> signInFields;
  List<Function1<GlobalKey<FormBuilderState>, Widget>> signUpFields;
  bool emailVerificationRequired;
  EmailConfig(
      {this.signInFields = const [],
      this.signUpFields = const [],
      this.emailVerificationRequired = true}) {
    if ((this.signInFields.isEmpty)) {
      this.signInFields = getSignInFields();
    }
    if ((this.signUpFields.isEmpty)) {
      this.signUpFields = getSignUpFields();
    }
  }
}

class Email extends AuthMethod {
  final EmailConfig config;
  Email({@required this.config});

  Future<bool> perform(
      {@required String email, @required String password}) async {
    final a = TextFormField(
        validator: EmailValidator(errorText: 'enter a valid email address'));
    try {
      var fa = getAuth();
      await fa.signInWithEmailAndPassword(email: email, password: password);
      currUser().reload();

      await emailVerify(fa);
      await resetPassword(fa, email);
    } catch (e) {
      print(e);
    }
  }

  @override
  String getName() {
    return 'email';
  }

  @override
  bool isProvidingFullLayout() {
    return true;
  }

  @override
  String errMsg(e, bool isFirebaseException, FirebaseExceptionData fe) {
    print('errMsg $e $isFirebaseException $fe');
  }

  @override
  Future<void> sign(bool isInSignIn, FirebaseAuth auth) async {
    final email = serve('email');
    final password = serve('password');

    assert(isNonNull(email));
    assert(isNonNull(password));

    if (isInSignIn) {
      await auth.signInWithEmailAndPassword(email: email, password: password);

      // currUser().sendEmailVerification();
      // Timer.periodic(Duration(seconds: 3), (Timer t) async {
      //   final user = currUser();
      //   await user.reload();
      //   print(
      //       'firebase auth user state ${currUser().emailVerified} local function user state ${currUser().emailVerified}');
      // });

    } else {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    }
  }

  @override
  Function0<void> onSuccessCallbackBeInvokedByChild(
      User user, BuildContext context, Map<String, dynamic> data) {
    return () {
      if (!config.emailVerificationRequired) {
        onSuccess(user, context, data);
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EmailVerify(
                  onSuccess: () {
                    onSuccess(user, context, data);
                  },
                )));
      }
    };
  }

  @override
  Widget getLayout(bool isInSignIn, BuildContext context) {
    if (isInSignIn) {
      return Builder(builder: (context) {
        return Column(
          children: [
            Formok(
              themeColor,
              fields: config.signInFields,
              onSuccess: () async {
                await startSigning(context);
              },
              onPressed: () {
                isFirstTimeSubmittedSignIn = true;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ForgotPasswordScreen(themeColor)));
                  },
                  child: Text('Forgot password?', style: smalltextStyle)),
            ),
          ],
        );
      });
    } else {
      return Builder(builder: (context) {
        return Column(
          children: [
            Formok(
              themeColor,
              onPressed: () {
                isFirstTimeSubmittedSignUp = true;
              },
              fields: config.signUpFields,
              onSuccess: () async {
                await startSigning(context);
              },
            ),
          ],
        );
      });
    }
  }
}

typedef A Function0<A>();

class Formok extends StatefulWidget {
  final List<Function1<GlobalKey<FormBuilderState>, Widget>> fields;
  final Function0 onSuccess, onPressed;
  final Color themeColor;

  const Formok(
    this.themeColor, {
    Key key,
    this.fields,
    @required this.onSuccess,
    @required this.onPressed,
  }) : super(key: key);

  @override
  _FormokState createState() => _FormokState();
}

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
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: NiceButton(
                  elevation: 8.0,
                  text: "Submit",
                  radius: 40,
                  fontSize: 14,
                  background: widget.themeColor,
                  onPressed: () {
                    // isFirstTimeSubmitted = true;
                    widget.onPressed();
                    if (_fbKey.currentState.saveAndValidate()) {
                      saveMultiple(_fbKey.currentState.value);
                      widget.onSuccess();
                    }
                    // git diff HEAD~2 HEAD -- email.dart
                  },
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
