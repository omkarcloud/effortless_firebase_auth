import 'package:allsirsa/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Phone {
  Phone();

  Future<bool> perform() async {
    try {
      final auth = FirebaseAuth.instance;
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
          PhoneAuthCredential phoneAuthCredential =
              PhoneAuthProvider.credential(
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

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is Phone;
  }

  @override
  String toString() {
    return 'Phone {}';
  }
}
