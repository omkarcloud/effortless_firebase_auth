import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'utils.dart';

class Field {
  FormFieldValidator<String> validate;
  String attribute;
  bool obscureText = false;
  String labelText;
  TextInputType keyboardType;
}

bool isFirstTimeSubmittedSignUp = false;
// (value) {
//         if (isFirstTimeSubmitted) {
//           key.currentState.saveAndValidate();
//         }
//       },
bool isFirstTimeSubmittedForgotPassword = false;
bool isFirstTimeSubmittedSignIn = false;

Widget fieldToFormField(
    Field args, GlobalKey<FormBuilderState> key, ValueChanged onChanged) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
    child: FormBuilderTextField(
      attribute: args.attribute,
      onChanged: onChanged,
      keyboardType: args.keyboardType,
      obscureText: args.obscureText,
      decoration: new InputDecoration(
        labelText: args.labelText,
        contentPadding: EdgeInsets.fromLTRB(4, 0, 4, 0),
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(10.0),
          borderSide: new BorderSide(),
        ),
        //fillColor: Colors.green
      ),
      validators: [args.validate],
    ),
  );
}

Field get emailFeild => (Field()
  ..attribute = 'email'
  ..labelText = 'Email'
  ..keyboardType = TextInputType.emailAddress
  ..validate = emailValidator);

Field get passwordFeild => (Field()
  ..attribute = 'password'
  ..labelText = 'Password'
  ..obscureText = true
  ..validate = passwordValidator);

Field get nameField => (Field()
  ..attribute = 'name'
  ..labelText = 'Name'
  ..keyboardType = null
  ..validate = RequiredValidator(errorText: 'name is required'));

MultiValidator get passwordValidator => MultiValidator([
      RequiredValidator(errorText: 'password is required'),
      MinLengthValidator(8,
          errorText: 'password must be at least 8 digits long'),
      // PatternValidator(r'(?=.*?[#?!@$%^&*-])',
      //     errorText: 'passwords must have at least one special character')
    ]);

MultiValidator get emailValidator => MultiValidator([
      RequiredValidator(errorText: 'email is required'),
      PatternValidator(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
          errorText: 'enter a valid email address')

      // EmailValidator(errorText: 'enter a valid email address')
    ]);

class DateValidatation extends TextFieldValidator {
  // pass the error text to the super constructor
  DateValidatation(
      {String errorText =
          'Enter a valid date of format d/M/yyyy example: 23/4/1999'})
      : super(errorText);

  // return false if you want the validator to return error
  // message when the value is empty.
  @override
  bool get ignoreEmptyValues => true;

  @override
  bool isValid(String value) {
    return validateDate(value);
  }
}

final dateValidator = DateValidatation();

final nameValidator = RequiredValidator(errorText: 'name is required');
