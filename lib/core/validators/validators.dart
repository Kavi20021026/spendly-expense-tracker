/// Input validation logic for Spendly forms.
abstract class Validators {
  /// Validates expense title
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an expense title.';
    }
    if (value.trim().length > 50) {
      return 'Title cannot exceed 50 characters.';
    }
    return null;
  }

  /// Validates expense amount
  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an amount.';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null) {
      return 'Please enter a valid numeric amount.';
    }
    if (parsed <= 0) {
      return 'Amount must be greater than 0.';
    }
    if (parsed > 100000000) {
      return 'Amount is unreasonably large.';
    }
    return null;
  }

  /// Validates category selection
  static String? validateCategory(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a category.';
    }
    return null;
  }

  /// Validates optional note field
  static String? validateNote(String? value) {
    if (value != null && value.trim().length > 200) {
      return 'Note cannot exceed 200 characters.';
    }
    return null;
  }

  /// Validates user email address
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address.';
    }
    final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  /// Validates password strength
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
    return null;
  }

  /// Validates password confirmation
  static String? validateConfirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }
    if (value != originalPassword) {
      return 'Passwords do not match.';
    }
    return null;
  }

  /// Validates user name for registration
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name.';
    }
    if (value.trim().length > 50) {
      return 'Name cannot exceed 50 characters.';
    }
    return null;
  }
}
