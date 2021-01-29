import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:railwayflutterapp/login2.dart';

void main() {
  testWidgets('empty email and password', (WidgetTester tester) async
  {
    Login login = new Login();
    var app = new MediaQuery(data: new MediaQueryData(), child: new
    MaterialApp(home: login));
    await tester.pumpWidget(app);
  });

  testEmailAndPassword();
}

  testEmailAndPassword() {
    test('title', () {

    });
    test('empty email returns error string', () {
      var result = EmailFeildValidator.validate('');
      expect(result, 'Email cannot be empty');
    });
    test('non empty email returns null', () {
      var result = EmailFeildValidator.validate('email');
      expect(result, null);
    });
    test('empty password returns error string', () {
      var result = PasswordFeildValidator.validate('');
      expect(result, 'Password cannot be empty');
    });
    test('non empty password returns null', () {
      var result = PasswordFeildValidator.validate('password');
      expect(result, null);
    });
  }


