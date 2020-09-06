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
              final result = await beginSigning();
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
