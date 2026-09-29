import 'package:flutter_test/flutter_test.dart';
import 'package:spendly/core/validators/validators.dart';

void main() {
  group('Validators Unit Tests', () {
    test('validateTitle returns error on empty or whitespace title', () {
      expect(Validators.validateTitle(''), 'Please enter an expense title.');
      expect(Validators.validateTitle('   '), 'Please enter an expense title.');
      expect(Validators.validateTitle(null), 'Please enter an expense title.');
    });

    test('validateTitle succeeds on valid title', () {
      expect(Validators.validateTitle('Lunch with friends'), null);
    });

    test('validateAmount returns error on invalid, zero, or negative numbers', () {
      expect(Validators.validateAmount(''), 'Please enter an amount.');
      expect(Validators.validateAmount('abc'), 'Please enter a valid numeric amount.');
      expect(Validators.validateAmount('0'), 'Amount must be greater than 0.');
      expect(Validators.validateAmount('-50'), 'Amount must be greater than 0.');
    });

    test('validateAmount succeeds on positive numbers including decimals', () {
      expect(Validators.validateAmount('850'), null);
      expect(Validators.validateAmount('850.50'), null);
    });

    test('validateEmail checks standard email syntax', () {
      expect(Validators.validateEmail('invalid-email'), 'Please enter a valid email address.');
      expect(Validators.validateEmail('user@domain.com'), null);
    });

    test('validatePassword checks minimum length', () {
      expect(Validators.validatePassword('12345'), 'Password must be at least 6 characters long.');
      expect(Validators.validatePassword('123456'), null);
    });

    test('validateConfirmPassword ensures password matching', () {
      expect(
        Validators.validateConfirmPassword('pass123', 'pass456'),
        'Passwords do not match.',
      );
      expect(
        Validators.validateConfirmPassword('pass123', 'pass123'),
        null,
      );
    });
  });
}
