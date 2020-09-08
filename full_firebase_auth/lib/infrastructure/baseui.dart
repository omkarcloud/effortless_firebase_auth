import 'package:easy_firebase_auth/Methods/email.dart';
import 'package:easy_firebase_auth/infrastructure/uiutils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:global_wings/store.dart';

import '../home.dart';
import 'base.dart';
import 'utils.dart';

const SingleSignOn = 'SingleSignOn';

abstract class AuthMethod extends Base {
  Color themeColor;

  String getName() {
    return 'SingleSignOn';
  }

  Widget getSignInWidget() {
    assert(isNonNull(inSignIn));

    return Builder(
      builder: (context) {
        return getLayout(inSignIn, context);

        if (isProvidingFullLayout()) {
          return getLayout(inSignIn, context);
        } else {
          return GestureDetector(
            child: getLayout(inSignIn, context),
            onTap: () async {
              await startSigning(context);
            },
          );
        }

        // return _getWidget(context);
      },
    );
  }

  Future startSigning(BuildContext context) async {
    final result = await beginSigning();
    // Null => Sucess
    // NonNull => Error
    if (isNonNull(result)) {
      showSnackBar(result, context);
    } else {
      if (isNull(onSuccessCallbackBeInvokedByChild(
          currUser(), context, serveStore()))) {
        onSuccess(currUser(), context, serveStore());
      } else {
        final f = onSuccessCallbackBeInvokedByChild(
            currUser(), context, serveStore());
        f();
      }
    }
  }

  Function0<void> onSuccessCallbackBeInvokedByChild(
      User user, BuildContext context, Map<String, dynamic> data) {
    return null;
  }

  bool isProvidingFullLayout() {
    return false;
  }

  // Will call sign
  Widget getLayout(bool isInSignIn, BuildContext context);
}
