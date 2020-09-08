import 'package:easy_firebase_auth/Methods/email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_firebase_auth/screens/signin.dart';
import 'package:easy_firebase_auth/infrastructure/utils.dart';

/**
 * Makes sure that onUnAutheticated access see the Widget
 *  [onAuthenticated] Widget to be protected
 */
Widget protect(
    {@required Function0<Widget> onAuthenticated,
    Function0<Widget> onUnAutheticated,
    FirebaseAuth auth}) {
  auth ??= FirebaseAuth.instance;
  onUnAutheticated ??= () {
    return SignIn(
      themeColor: Colors.deepPurple,
      methods: [Email(config: EmailConfig(emailVerificationRequired: false))],
      auth: FirebaseAuth.instance,
      onSuccess: (user, context, fields) {
        protect(
          onAuthenticated: onAuthenticated,
          auth: auth,
        );
      },
    );
  };

  if (isNull(auth.currentUser)) {
    return onUnAutheticated();
  } else {
    return onAuthenticated();
  }
}
