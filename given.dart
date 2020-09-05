import 'package:meta/meta.dart';

class Email {
  Email();

  bool perform({@required String email, @required String password}) {
    print('Hello from perform');
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
