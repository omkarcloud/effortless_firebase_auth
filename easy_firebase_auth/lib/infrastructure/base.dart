import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

typedef D Function3<A, B, C, D>(A a, B b, C c);

FirebaseAuth _auth;
void setAuth(FirebaseAuth a) {
  assert(isNonNull(a));
  _auth = a;
}

FirebaseAuth getAuth() {
  assert(isNonNull(_auth));
  return _auth;
}

abstract class Base {
  Function3<User, BuildContext, Map<String, dynamic>, dynamic> onSuccess;
  // Either in SignIn Flow or in SignOut Flow
  bool inSignIn;

  Base();

  void setOnSuccess(
      Function3<User, BuildContext, Map<String, dynamic>, dynamic> args) {
    onSuccess = args;
  }

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
        case 'user-not-found':
          return 'There is no user record corresponding to this identifier. Please create an account';
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
  ) {
    return null;
  }

  Future<String> beginSigning() async {
    assert(isNonNull(inSignIn));

    try {
      await sign(inSignIn, getAuth());
      return null;
    } catch (e) {
      if (isFirebaseEx(e)) {
        final fex = FirebaseExceptionData();
        fex.code = e.code;
        fex.message = e.message;
        print('HANDLED FIREBASE EXCEPTION $e  $fex');

        final response = baseerrMsg(e, true, fex);
        // Don't know how to handle exception
        if (isNonNull(response)) {
          // throw 'Unhandled Firebase Exception' + e;
          return response;
        } else {
          return fex.message;
        }
      } else {
        print('ENCOUNTERED EXCEPTION $e');

        final response = baseerrMsg(e, false, null);
        // Don't know how to handle exception
        if (isNull(response)) {
          throw 'Exception not handled $e';
        } else {
          return response;
        }
      }
    }
  }

  Future<void> sign(bool isInSignIn, FirebaseAuth auth);
}
