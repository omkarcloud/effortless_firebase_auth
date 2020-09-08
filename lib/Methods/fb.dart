import 'package:effortless_firebase_auth/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Facebook {
  Facebook();

  Future<bool> perform() async {
    try {
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
