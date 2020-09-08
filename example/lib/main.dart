import 'package:flutter/material.dart';
import 'package:effortless_firebase_auth/effortless_firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

/**
 * Extend AuthMethod to create a new method
 */
class Google extends AuthMethod {
  /**
   * Provide the look and feel of the Provider Button
   */
  @override
  Widget getLayout(bool isInSignIn, BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(0),
        child: NiceButton(
          elevation: 8.0,
          onPressed: () {
            /**
            * Kick off the signing Process
            */
            startSigning(context);
          },
          text: "Google",
          width: double.infinity,
          radius: 40,
          fontSize: 16,
          background: Color(0xffc4302b),
        ));
  }

  /**
    * Perform the siging
   */
  @override
  Future<void> sign(bool isInSignIn, FirebaseAuth auth) async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, Call firebase to sign in with the credentials
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

class CustomErrorMessage extends Email {
  CustomErrorMessage({@required EmailConfig config}) : super(config: config);

  @override
  String errMsg(e, bool isFirebaseException, FirebaseExceptionData fe) {
    if (isFirebaseException) {
      switch (fe.code) {
        case 'user-not-found':
          // Default message is 'There is no user record corresponding to this identifier. Please create an account'
          // We change it to 'Please create an Account'
          return 'Please create an account';
          break;
        default:
      }
    }

    return null;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Auth',
      debugShowCheckedModeBanner: false,
      home: SignIn(
        themeColor: Colors.deepPurple,
        // Sign in and Sign Up fields are customizable in EmailConfig
        methods: [ CustomErrorMessage(config: EmailConfig())],
        auth: FirebaseAuth.instance,
        onSuccess: (user, context, fields) {
          showSnackBar(
              'You made the signUp flow in record time. Cheers.', context);
          print('user: $user \n fields: $fields');
        },
      ),
    );
  }
}
