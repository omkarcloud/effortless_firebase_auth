import 'package:intl/intl.dart';

typedef B Function1<A, B>(A a);

bool isNull(dynamic args) {
  if (args == null) {
    return true;
  }
  return false;
}

bool validateDate(String value) {
  try {
    DateFormat('d/M/yyyy').parse(value);
    return true;
  } catch (e) {
    return false;
  }
}

bool isNonNull(dynamic args) {
  return !isNull(args);
}

bool isFirebaseEx(e) {
  bool isFirebaseException;
  try {
    isFirebaseException = isNonNull(e.code) && isNonNull(e.message);
  } catch (e) {
    isFirebaseException = false;
  }
  return isFirebaseException;
}

class FirebaseExceptionData {
  String code;
  String message;
}
