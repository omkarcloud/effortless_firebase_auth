import 'package:allsirsa/home.dart';
import 'package:allsirsa/infrastructure/base.dart';
import 'package:allsirsa/infrastructure/baseui.dart';
import 'package:allsirsa/infrastructure/uiutils.dart';
import 'package:allsirsa/infrastructure/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:nice_button/nice_button.dart';

class Phone extends AuthMethod {
  Phone();

  @override
  String errMsg(e, bool isFirebaseException, FirebaseExceptionData fe) {
    print('errMsg $e $isFirebaseException $fe');
    return 'sss';
  }

  @override
  Future<void> sign(bool isInSignIn, FirebaseAuth auth) async {
    print('object');
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
          text: "Facebook",
          width: double.infinity,
          radius: 40,
          fontSize: 16,
          background: Colors.blue[900]),
    );
  }
}

Future<bool> perform() async {
  try {
    final auth = getAuth();
    await auth.verifyPhoneNumber(
      phoneNumber: '+91 44 4444 4444',
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!

        // Sign the user in (or link) with the auto-generated credential
        final cred = await auth.signInWithCredential(credential);

        // print(auth.currentUser);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
          return;
        }
        print(e);
      },
      codeSent: (String verificationId, int resendToken) async {
        L.i(currUser());

        print('verificationId:' + verificationId);
        // Update the UI - wait for the user to enter the SMS code
        String smsCode = '65432144';

        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);
        // return;
        // phoneAuthCredential.
        // Sign the user in (or link) with the credential
        final cred = await auth.signInWithCredential(phoneAuthCredential);

        // await currUser().linkWithCredential(phoneAuthCredential);

        // print(cred);
        await auth.currentUser.updatePhoneNumber(phoneAuthCredential);

        L.i(currUser());
      },
      timeout: const Duration(seconds: 0),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  } catch (e) {
    print(e);
  }
}
