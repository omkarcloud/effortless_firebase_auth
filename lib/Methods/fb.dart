import 'package:allsirsa/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Facebook {
  Facebook();

  Future<bool> perform() async {
    try {
      // Trigger the sign-in flow
      final LoginResult result = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final FacebookAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken.token);

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      logUser();
    } catch (e) {
      print(e);
    }
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is Facebook;
  }

  @override
  String toString() {
    return 'Facebook {}';
  }
}
