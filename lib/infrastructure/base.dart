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
  );

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
        final response = baseerrMsg(e, true, fex);
        // Don't know how to handle exception
        if (isNull(response)) {
          // throw 'Unhandled Firebase Exception' + e;
          return fex.message;
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

/**
 * Extracts the firebase error message that may occur when executing the function.
 * If no errors encountered it gives a null response indicating success!! 
 * Use case is to extract the error message and display it to user in a snackbar form.
 *  TODO CHANGE PACKAGE NAME
      import 'package:flutter/material.dart';
  
      final firebaseErrorMessage =
          await fireErr(() => FirebaseAuth.instance.currentUser.reload());
      if (isNonNull(firebaseErrorMessage)) {        
        showSnackBar(firebaseErrorMessage, context);
      }

 *    
 */
Future<String> fireErr(Function0<Future> args) async {
  try {
    await args();
    return null;
  } catch (e) {
    if (isFirebaseEx(e)) {
      final fex = FirebaseExceptionData();
      fex.message = e.message;
      return fex.message;
    } else {
      print('Non Firebase Exception not handled $e');
      return '$e';
    }
  }
}
