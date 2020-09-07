import 'package:allsirsa/infrastructure/base.dart';
import 'package:allsirsa/infrastructure/baseui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nice_button/nice_button.dart';

class Google extends AuthMethod {
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, Call firebase to sign in with the credentials
    return await getAuth().signInWithCredential(credential);
  }

  @override
  Widget getLayout(bool isInSignIn, BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(0),
        child: NiceButton(
          elevation: 8.0,
          onPressed: () {
            startSigning(context);
          },
          text: "Google",
          width: double.infinity,
          radius: 40,
          fontSize: 16,
          background: Color(0xffc4302b),
        ));
  }

  @override
  Future<void> sign(bool isInSignIn, FirebaseAuth auth) async {
    await signInWithGoogle();
  }
}
