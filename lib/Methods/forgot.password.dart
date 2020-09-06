import 'package:allsirsa/infrastructure/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:global_wings/global_wings.dart';

import 'email.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Center(
                child: new Text(
                  "Lost your password",
                  style: new TextStyle(
                      fontSize: 34.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w700,
                      fontFamily: "Roboto"),
                ),
              ),
              Text(
                "Type your email below and we'll send you instructions on how to reset it.",
                style: new TextStyle(
                    fontSize: 20.0,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w500,
                    fontFamily: "Roboto"),
              ),

              Center(
                child: Formok(
                  fields: [
                    emailFeild,
                  ].map((e) {
                    return ((GlobalKey<FormBuilderState> a) =>
                        fieldToFormField(e, a));
                  }).toList(),
                  onSuccess: () async {
                    final email = serve('email');
                    await resetPassword(FirebaseAuth.instance, email);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              // Cancel Button
            ],
          ),
        ),
      ),
    );
  }
}
