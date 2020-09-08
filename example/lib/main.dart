import 'package:flutter/material.dart';
import 'package:effortless_firebase_auth/effortless_firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        // Sign in and Sign Up fields are customizable in EmailConfig
        methods: [Google(), Email(config: EmailConfig())],
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
