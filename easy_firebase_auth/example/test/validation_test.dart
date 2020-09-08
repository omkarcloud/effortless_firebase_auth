// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:allsirsa/infrastructure/utils.dart';
import 'package:allsirsa/infrastructure/validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Validation test', () {
    print(validateDate(''));
    print(validateDate(null));

    print(validateDate('4556'));
    var dmyString = '23/4/1999';

    print(validateDate(dmyString));

    Validation v = Validation(validators: [notEmpty, atleast8chars]);
    var r = v.beginValidation({}, '', 'email');
    expect(r, equals('email must not be empty'));

    r = v.beginValidation({}, '123', 'password');
    expect(r, equals('password must be atleast 8 chars long'));

    r = v.beginValidation({}, '12345678', 'password');
    expect(r, equals(null));
  });
}
