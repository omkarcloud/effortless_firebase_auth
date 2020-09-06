typedef B Function1<A, B>(A a);

bool isNull(dynamic args) {
  if (args == null) {
    return true;
  }
  return false;
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
