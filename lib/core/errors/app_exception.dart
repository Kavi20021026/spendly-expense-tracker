/// Custom exception class to map technical errors into user-friendly messages.
class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => message;

  /// Translates Firebase Auth codes to friendly messages.
  factory AppException.fromFirebaseAuth(String code, String defaultMessage) {
    switch (code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return const AppException('Invalid email or password. Please check your credentials.');
      case 'email-already-in-use':
        return const AppException('An account already exists for this email address.');
      case 'invalid-email':
        return const AppException('The email address entered is invalid.');
      case 'weak-password':
        return const AppException('The password provided is too weak. Please use a stronger password.');
      case 'network-request-failed':
        return const AppException('Network error. Please check your internet connection.');
      case 'user-disabled':
        return const AppException('This user account has been disabled.');
      case 'too-many-requests':
        return const AppException('Too many failed attempts. Please try again later.');
      default:
        return AppException(defaultMessage, code: code);
    }
  }

  /// Translates Firestore error codes to friendly messages.
  factory AppException.fromFirestore(String code, String defaultMessage) {
    switch (code) {
      case 'permission-denied':
        return const AppException('Permission denied. You do not have access to this resource.');
      case 'unavailable':
        return const AppException('Service temporarily unavailable. Please check your network.');
      case 'not-found':
        return const AppException('The requested data could not be found.');
      default:
        return AppException(defaultMessage, code: code);
    }
  }
}
