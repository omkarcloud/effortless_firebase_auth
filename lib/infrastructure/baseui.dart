import 'package:allsirsa/infrastructure/uiutils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home.dart';
import 'base.dart';
import 'utils.dart';

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
              await beginTheFlow(context);
            },
          );
        }

        // return _getWidget(context);
      },
    );
  }

  Future beginTheFlow(BuildContext context) async {
    final result = await beginSigning();
    // Null => Sucess
    // NonNull => Error
    if (isNonNull(result)) {
      showSnackBar(result, context);
    } else {
      onSuccess(FirebaseAuth.instance.currentUser);
      L.i('Succesfully Logged In');
    }
  }

  bool isProvidingFullLayout() {
    return false;
  }

  // Will call sign
  Widget getLayout(bool isInSignIn);
}
