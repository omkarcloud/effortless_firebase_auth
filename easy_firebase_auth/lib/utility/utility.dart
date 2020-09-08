import 'package:easy_firebase_auth/Methods/email.dart';
import 'package:easy_firebase_auth/Methods/google.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_firebase_auth/screens/signin.dart';
import 'package:easy_firebase_auth/infrastructure/utils.dart';

// /**
//  * Makes sure that onUnAutheticated access see the Widget
//  *  [onAuthenticated] Widget to be protected
//  */
// Widget protect(
//     {@required Widget onAuthenticated,
//     Widget onUnAutheticated,
//     @required FirebaseAuth auth}) {
//   print([auth, onAuthenticated, onUnAutheticated]);

//   print([auth, isNull(auth.currentUser), onAuthenticated, onUnAutheticated]);
//   if (isNull(auth.currentUser)) {
//     onUnAutheticated ??= SignIn(
//       themeColor: Colors.deepPurple,
//       methods: [
//         Google(),
//         Email(config: EmailConfig(emailVerificationRequired: false))
//       ],
//       auth: auth,
//       onSuccess: (user, context, fields) {
//         Navigator.of(context).pop();
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) {
//             return onAuthenticated;
//           },
//         ));
//       },
//     );

//     return onUnAutheticated;
//   } else {
//     return onAuthenticated;
//   }
// }

/**
 * Makes sure that onUnAutheticated access see the Widget
 * It actually works and protect the routes  
 * But the problem is on hotreload
 * hotreload works when we have the user authenticated 
 * but seems not to work when we reauthenticate the user.
 *  For example 
 *  User is Unauthenticated 
 *  We present auth screen 
 *  when user is authenticated we present the [onAuthenticated Widget]. 
 *  Problem 
 *  Now it seems that widget gets cached and build method of [onAuthenticated Widget] only gets called once.
 * 
 * 
 *  [onAuthenticated] Widget to be protected
 * I do not think there will be any issue regarding to screen flow other that for developer(only when we reauthenricate which happens quite less.)
 * 
 */
class Protection extends StatefulWidget {
  final Widget onAuthenticated;
  final Widget onUnAutheticated;
  final FirebaseAuth auth;

  const Protection(
      {Key key,
      @required this.onAuthenticated,
      this.onUnAutheticated,
      @required this.auth})
      : super(key: key);

  @override
  _ProtectionState createState() => _ProtectionState();
}

class _ProtectionState extends State<Protection> {
  @override
  Widget build(BuildContext context) {
    var auth = widget.auth;
    var onAuthenticated = widget.onAuthenticated;
    var onUnAutheticated = widget.onUnAutheticated;

    print([auth, isNull(auth.currentUser), onAuthenticated, onUnAutheticated]);
    if (isNull(auth.currentUser)) {
      if (isNull(onUnAutheticated)) {
        onUnAutheticated = SignIn(
          themeColor: Colors.deepPurple,
          methods: [
            Google(),
            Email(config: EmailConfig(emailVerificationRequired: false))
          ],
          auth: auth,
          onSuccess: (user, context, fields) {
            // Navigator.of(context).pop();

            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) {
                return onAuthenticated;
              },
            ));
            // Navigator.of(context).push();
          },
        );
      }
      return onUnAutheticated;
    } else {
      return onAuthenticated;
    }
  }
}
