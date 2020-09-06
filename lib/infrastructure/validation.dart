import 'utils.dart';
import 'package:meta/meta.dart';

/** 
 * Return null in case the value passes the validation else return error message string
 *   
 * [properties] contains the values of the fields in the form. 
 * Note: [properties] may also next fields (fields coming after current field) but it might be the case that the field is outdated 
 * In case you need to access that field that comes next than place that field before the current field  
 * For example our purpose is to validate that to confirm the password in order to do that we will  
 *  TODO COMPLETE IT
 *   For pass ; 
 * 
 */

String emptyf(Map<String, String> properties, String currentValue, String key) {
  if (isNull(currentValue) || currentValue.trim().length == 0) {
    return '$key must not be empty';
  }
  return null;
}

String atleast8charsf(
    Map<String, String> properties, String currentValue, String key) {
  if (currentValue.length < 8) {
    return '$key must be atleast 8 chars long';
  }
  return null;
}

String confirmPasswordf(
    Map<String, String> properties, String currentValue, String key) {
  if (properties['password'] != currentValue) {
    return 'Both password must match';
  }
  return null;
}

typedef D Function3<A, B, C, D>(A a, B b, C c);

class ValidationMethod {
  final Function3<Map<String, String>, String, String, String> f;
  final String key;

  const ValidationMethod(this.f, this.key);
}

const notEmpty = ValidationMethod(emptyf, "notEmpty");
const atleast8chars = ValidationMethod(atleast8charsf, "atleast8chars");
const confirmPassword = ValidationMethod(confirmPasswordf, "confirmPassword");

class Validation {
  final List<ValidationMethod> validators;

  Validation({@required this.validators});

  void add(ValidationMethod m) {
    validators.add(m);
  }

  void remove(String key) {
    validators.removeWhere((element) => element.key == key);
  }

  /**
   * [key] is the key of the field
   */
  String beginValidation(
      Map<String, String> properties, String currentValue, String key) {
    if (validators.length == 0) {
      return null;
    }

    // final result = validators.any((element) => false);

    final result = validators.firstWhere(
        (element) => isNonNull(element.f(properties, currentValue, key)),
        orElse: () => null);
    // Successfull
    if (isNull(result)) {
      return null;
    } else {
      return result.f(properties, currentValue, key);
    }
  }
}

// abstract class Validation extends Base {
//   Widget getSignInWidget() {
//     assert(isNonNull(inSignIn));

//     return Builder(
//       builder: (context) {
//         if (isProvidingFullLayout()) {
//           return getLayout(inSignIn);
//         } else {
//           return GestureDetector(
//             child: getLayout(inSignIn),
//             onTap: () async {
//               final result = await beginSigning();
//               // Null => Sucess
//               // NonNull => Error
//               if (isNonNull(result)) {
//                 showSnackBar(result, context);
//               } else {
//                 onSuccess(FirebaseAuth.instance.currentUser);
//                 L.i('Succesfully Logged In');
//               }
//             },
//           );
//         }

//         // return _getWidget(context);
//       },
//     );
//   }

//   bool isProvidingFullLayout() {
//     return false;
//   }

//   // Will call sign
//   Widget getLayout(bool isInSignIn);
// }
