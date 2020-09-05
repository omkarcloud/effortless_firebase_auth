import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meta/meta.dart';

class Email {
  Email();

  Future<bool> perform(
      {@required String email, @required String password}) async {
    try {
      var fa = FirebaseAuth.instance;
      await fa.signInWithEmailAndPassword(email: email, password: password);
      await emailVerify(fa);

      await resetPassword(fa, email);
    } catch (e) {
      print(e);
    }
  }

  Future resetPassword(FirebaseAuth fa, String email) async {
    await fa.sendPasswordResetEmail(email: email);
  }

  Future emailVerify(FirebaseAuth fa) async {
    User uu = fa.currentUser;
    await uu.sendEmailVerification();
  }

  Future<UserCredential> register(String email, String password) async {
    final user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return user;
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is Email;
  }

  @override
  String toString() {
    return 'Email {}';
  }
}
