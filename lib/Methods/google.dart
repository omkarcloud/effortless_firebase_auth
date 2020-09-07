import 'package:allsirsa/infrastructure/base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Google {
  Google();

  Future<bool> perform() async {
    try {
      await signInWithGoogle();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // L.i('aaaaaaaaaaaaaaaa');

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

    // Once signed in, return the UserCredential
    return await getAuth().signInWithCredential(credential);
  }
}
