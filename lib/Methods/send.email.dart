import 'package:allsirsa/home.dart';
import 'package:allsirsa/infrastructure/uiutils.dart';
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

    currUser().sendEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Builder(builder: (context) {
          return Center(
            child: Column(
              children: [
                Center(
                  child: new Text(
                    "Verify your email to continue",
                    style: new TextStyle(
                        fontSize: 34.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Roboto"),
                  ),
                ),
                Text(
                  // , please confirm the verification email.
                  "A verificatiom email has been sent to ${serve('email')}.",
                  style: new TextStyle(
                      fontSize: 20.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Roboto"),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: NiceButton(
                        elevation: 8.0,
                        text: "Email Verified",
                        radius: 40,
                        fontSize: 14,
                        background: theme,
                        onPressed: () {
                          if (currUser().emailVerified) {
                            showSnackBar(
                                'Your Email has been verified', context);
                            widget.onSuccess();
                          } else {
                            showSnackBar('Your Email is not verified', context);
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
                        background: theme,
                        onPressed: () async {
                          try {
                            await currUser().sendEmailVerification();
                            showSnackBar(
                                'Email verification link has been sent to your email',
                                context);
                          } catch (e) {
                            print(e);
                            showSnackBar(e.message, context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                // Cancel Button
              ],
            ),
          );
        }),
      ),
    );
  }
}
