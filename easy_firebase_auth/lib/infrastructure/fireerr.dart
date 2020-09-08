import 'package:easy_firebase_auth/infrastructure/utils.dart';

typedef A Function0<A>();

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
