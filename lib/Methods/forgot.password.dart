import 'package:effortless_firebase_auth/infrastructure/base.dart';
import 'package:effortless_firebase_auth/infrastructure/fireerr.dart';
import 'package:effortless_firebase_auth/infrastructure/uiutils.dart';
import 'package:effortless_firebase_auth/infrastructure/utils.dart';
import 'package:effortless_firebase_auth/infrastructure/validators.dart';
import 'package:effortless_firebase_auth/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:global_wings/global_wings.dart';

import 'email.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final Color themeColor;

  const ForgotPasswordScreen(
    this.themeColor, {
    Key key,
  }) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return (wrap(
      () => Center(
        child: Column(
          children: [
            Px50(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Center(
                    child: buildText("Lost your password?"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "Type your email below and we'll send you instructions on how to reset it.",
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontSize: 16.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Px20(),
            Center(
              child: Builder(builder: (context) {
                return Formok(
                  widget.themeColor,
                  onPressed: () {
                    isFirstTimeSubmittedForgotPassword = true;
                  },
                  fields: [
                    emailFeild..attribute = 'forgotpassword-email',
                  ].map((e) {
                    return ((GlobalKey<FormBuilderState> a) =>
                        fieldToFormField(e, a, (v) {
                          if (isFirstTimeSubmittedForgotPassword) {
                            a.currentState.saveAndValidate();
                          }
                        }));
                  }).toList(),
                  onSuccess: () async {
                    final email = serve('forgotpassword-email');
                    // FirebaseAuth.instance.currentUser.reload()
                    final firebaseErrorMessage = await fireErr(() async {
                      await resetPassword(getAuth(), email);
                      showSnackBar('Email has been sent to $email.', context);

                      await Future.delayed(
                          const Duration(seconds: 4), () => "1");

                      Navigator.of(context).pop();
                    });
                    if (isNonNull(firebaseErrorMessage)) {
                      showSnackBar(firebaseErrorMessage, context);
                    }
                  },
                );
              }),
            ),
            // Cancel Button
          ],
        ),
      ),
    ));
  }
}
