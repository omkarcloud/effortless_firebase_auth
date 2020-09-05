import 'package:allsirsa/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const UN_HANDLED = '-1';
typedef B Function1<A, B>(A a);

bool isNull(dynamic args) {
  if (args == null) {
    return true;
  }
  return false;
}

bool isNonNull(dynamic args) {
  return !isNull(args);
}

bool isFirebaseEx(e) {
  bool isFirebaseException;
  try {
    isFirebaseException = isNonNull(e.code) && isNonNull(e.message);
  } catch (e) {
    isFirebaseException = false;
  }
  return isFirebaseException;
}

void showSnackBar(String msg, BuildContext context) {
  final snackBar = SnackBar(
    content: Text(msg),
    duration: Duration(milliseconds: 6500),
  );
  Scaffold.of(context).showSnackBar(snackBar);
}

class Google extends BaseUI {
  @override
  String errMsg(e, String code, String msg) {
    // TODO: implement errMsg
    throw UnimplementedError();
  }

  @override
  Widget getLayout(bool isInSignIn) {
    // TODO: implement getLayout
    throw UnimplementedError();
  }

  @override
  Future sign(bool isInSignIn) {
    // TODO: implement sign
    throw UnimplementedError();
  }
}

abstract class Base {
  final Function1<User, dynamic> onSuccess;

  // Either in SignIn Flow or in SignOut Flow
  bool inSignIn;

  Base({@required this.onSuccess});
  // Handles error not handles by Providing Auth Service
  String baseerrMsg(dynamic e, String code, String msg) {
    final response = errMsg(e, code, msg);

    if (isNonNull(response)) return response;

    // TODO OWN ERRORS HANDLING

    return null;
  }

  String errMsg(dynamic e, String code, String msg);

  Future<String> baseSign() async {
    assert(isNonNull(inSignIn));

    try {
      return null;
    } catch (e) {
      if (isFirebaseEx(e)) {
        final response = baseerrMsg(e, e.code, e.message);
        // Don't know how to handle exception
        if (isNull(response)) {
          throw 'Unhandled Firebase Exception' + e;
        } else {
          return response;
        }
      } else {
        throw 'Throwed Non firebase Exception $e';
      }
    }
  }

  Future sign(bool isInSignIn);
}

abstract class BaseUI extends Base {
  Widget getSignInWidget() {
    assert(isNonNull(inSignIn));

    return Builder(
      builder: (context) {
        if (isProvidingFullLayout()) {
          return getLayout(inSignIn);
        } else {
          return GestureDetector(
            child: getLayout(inSignIn),
            onTap: () async {
              final result = await baseSign();
              // Null => Sucess
              // NonNull => Error
              if (isNonNull(result)) {
                showSnackBar(result, context);
              } else {
                onSuccess(FirebaseAuth.instance.currentUser);
                L.i('Succesfully Logged In');
              }
            },
          );
        }

        // return _getWidget(context);
      },
    );
  }

  bool isProvidingFullLayout() {
    return false;
  }

  // Will call sign
  Widget getLayout(bool isInSignIn);
}
