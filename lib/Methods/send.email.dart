import 'package:allsirsa/home.dart';
import 'package:allsirsa/infrastructure/base.dart';
import 'package:allsirsa/infrastructure/uiutils.dart';
import 'package:allsirsa/infrastructure/utils.dart';
import '../screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:global_wings/global_wings.dart';
import 'package:nice_button/NiceButton.dart';

import 'email.dart';

class EmailVerify extends StatefulWidget {
  final Function0 onSuccess;

  const EmailVerify({Key key, this.onSuccess}) : super(key: key);

  @override
  _EmailVerifyState createState() => _EmailVerifyState();
}

// confirm: 'A verificatiom email has been sent to {{}}, please confirm the verification mail.',
// Once verified click the button to complete process.
// Did not recieve the email?
// Resend

class _EmailVerifyState extends State<EmailVerify> {
  @override
  void initState() {
    super.initState();
    // currUser().sendEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Builder(builder: (context) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Center(
                      child: buildText(
                        "Verify your email to continue",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                          // , please confirm the verification email.
                          "A verificatiom email has been sent to ${serve('email')}.",
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontSize: 16.0,
                              color: const Color(0xFF000000),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto')),
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: NiceButton(
                            elevation: 8.0,
                            text: "Verified the email",
                            radius: 40,
                            fontSize: 14,
                            background: getColor(),
                            onPressed: () async {
                              final firebaseErrorMessage =
                                  await fireErr(() async {
                                await currUser().reload();
                                if (currUser().emailVerified) {
                                  showSnackBar(
                                      'Your Email has been verified', context);
                                  await Future.delayed(
                                      const Duration(seconds: 4), () => "1");
                                  // Let user see snack bar
                                  widget.onSuccess();
                                } else {
                                  showSnackBar(
                                      'Your Email is not verified', context);
                                }
                              });

                              if (isNonNull(firebaseErrorMessage)) {
                                showSnackBar(firebaseErrorMessage, context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: NiceButton(
                            elevation: 8.0,
                            text: "Resend Email",
                            radius: 40,
                            fontSize: 14,
                            background: getColor(),
                            onPressed: () async {
                              final firebaseErrorMessage = await fireErr(() {
                                return currUser().sendEmailVerification();
                              });

                              if (isNonNull(firebaseErrorMessage)) {
                                showSnackBar(firebaseErrorMessage, context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    // Cancel Button
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
