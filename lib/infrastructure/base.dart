import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

abstract class Base {
  final Function1<User, dynamic> onSuccess;
  final FirebaseAuth auth;
  // Either in SignIn Flow or in SignOut Flow
  bool inSignIn;

  Base({
    @required this.onSuccess,
    @required this.auth,
  });

  // Handles error not handles by Providing Auth Service
  String baseerrMsg(
    dynamic e,
    bool isFirebaseException,
    FirebaseExceptionData fe,
  ) {
    final response = errMsg(e, isFirebaseException, fe);

    if (isNonNull(response)) return response;
    if (isFirebaseException) {
      switch (fe.code) {
        case '':
          break;
        default:
      }
    }
    return null;
  }

/*
 *
 * Recieves Exception thrown by sign() method  
 * if is not a FirebaseException then fe will be null 
 * else it will contain code and message of the exception 
 * With this knowledge you can handle errors appropriately as 
 
 if (isFirebaseException) {
      switch (fe.code) {
        case 'invalidPassword':
          break;
        default:
      }
    }
 */
  String errMsg(
    dynamic e,
    bool isFirebaseException,
    FirebaseExceptionData fe,
  );

  Future<String> beginSigning() async {
    assert(isNonNull(inSignIn));

    try {
      await sign(inSignIn, auth);
      return null;
    } catch (e) {
      if (isFirebaseEx(e)) {
        final fex = FirebaseExceptionData();
        fex.code = e.code;
        fex.message = e.message;
        final response = baseerrMsg(e, true, fex);
        // Don't know how to handle exception
        if (isNull(response)) {
          throw 'Unhandled Firebase Exception' + e;
        } else {
          return response;
        }
      } else {
        final response = baseerrMsg(e, false, null);
        // Don't know how to handle exception
        if (isNull(response)) {
          throw ' Exception not handled $e';
        } else {
          return response;
        }
      }
    }
  }

  Future sign(bool isInSignIn, FirebaseAuth auth);
}
