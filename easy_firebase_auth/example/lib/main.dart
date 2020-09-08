import 'package:flutter/material.dart';
import 'package:easy_firebase_auth/easy_firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase/firebase.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp()
      // DevicePreview(
      //   enabled: true,
      //   builder: (context) => MyApp(),
      // ),
      );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.signOut();
    // .signInWithEmailAndPassword(
    //     email: 'chetansirsa@gmail.com', password: '12345678')
    // .then((value) => print(value));
    // logStore();

    return MaterialApp(
        title: 'Easy Auth',
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Aaa()));
  }
}

class Aaa extends StatefulWidget {
  const Aaa({
    Key key,
    // @required this.protect2,
  }) : super(key: key);

  @override
  _AaaState createState() => _AaaState();
}

class _AaaState extends State<Aaa> {
  @override
  Widget build(BuildContext context) {
    // final protect2 = ;
    // print((protect2.onAuthenticated as Scaffold).appBar);
    print('object');
    return Center(
        child: Container(
            child: Protection(
                auth: FirebaseAuth.instance,
                // key: UniqueKey(),
                onAuthenticated: Scaffold(
                    appBar: AppBar(
                  title: Text('Assssdd!!!'),
                )))));
  }
}

// /**
//  * Makes sure that onUnAutheticated access see the Widget
//  *  [onAuthenticated] Widget to be protected
//  */
//(
//     {@required Function0<Widget> onAuthenticated,
//     Function0<Widget> onUnAutheticated,
//     FirebaseAuth auth}) {
//   auth ??= FirebaseAuth.instance;
//   onUnAutheticated ??= () {
//     return SignIn(
//       themeColor: Colors.deepPurple,
//       methods: [Email(config: EmailConfig(emailVerificationRequired: false))],
//       auth: FirebaseAuth.instance,
//       onSuccess: (user, context, fields) {
//         protect(
//           onAuthenticated: onAuthenticated,
//           auth: auth,
//         );
//       },
//     );
//   };

//   if (isNull(auth.currentUser)) {
//     return onUnAutheticated();
//   } else {
//     return onAuthenticated();
//   }
// }
