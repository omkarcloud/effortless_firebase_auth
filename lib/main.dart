import 'package:allsirsa/Methods/email.dart';
import 'package:allsirsa/Methods/phone.dart';
import 'package:allsirsa/Methods/send.email.dart';
import 'package:allsirsa/infrastructure/uiutils.dart';
import 'package:allsirsa/screens/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:firebase/firebase.dart';
import 'Methods/google.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Auth',
      debugShowCheckedModeBanner: false,
      home: SignIn(
        themeColor: Colors.deepPurple,
        methods: [
          Google(),
          Email(config: EmailConfig(emailVerificationRequired: false))
        ],
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
