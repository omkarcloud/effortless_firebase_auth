import 'package:easy_firebase_auth/Methods/email.dart';
import 'package:easy_firebase_auth/infrastructure/uiutils.dart';
import 'package:easy_firebase_auth/infrastructure/utils.dart';
import 'package:easy_firebase_auth/screens/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:firebase/firebase.dart';
import 'Methods/google.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:device_preview/device_preview.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MyApp(),
    ),
  );
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
