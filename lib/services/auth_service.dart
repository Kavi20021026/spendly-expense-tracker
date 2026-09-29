import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/errors/app_exception.dart';
import '../models/app_user.dart';

/// Firebase Authentication Service for Spendly.
class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Stream of Auth State Changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Gets current Firebase User
  User? get currentUser => _auth.currentUser;

  /// Registers a new user with email and password, updating display name and storing profile doc in Firestore.
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const AppException('Registration failed. User object not created.');
      }

      await user.updateDisplayName(name.trim());

      final appUser = AppUser(
        uid: user.uid,
        email: email.trim(),
        displayName: name.trim(),
        createdAt: DateTime.now(),
      );

      // Save user document in Firestore users/{userId}
      await _firestore.collection('users').doc(user.uid).set(appUser.toFirestore());

      return appUser;
    } on FirebaseAuthException catch (e) {
      throw AppException.fromFirebaseAuth(e.code, e.message ?? 'Registration failed.');
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException('An unexpected error occurred during registration: $e');
    }
  }

  /// Logs in an existing user with email and password.
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const AppException('Login failed. User session not found.');
      }

      // Fetch user profile from Firestore or construct fallback
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc.data() != null) {
        return AppUser.fromFirestore(userDoc.data()!, user.uid);
      } else {
        final fallbackUser = AppUser(
          uid: user.uid,
          email: user.email ?? email.trim(),
          displayName: user.displayName ?? 'User',
          createdAt: DateTime.now(),
        );
        // Ensure doc exists
        await _firestore.collection('users').doc(user.uid).set(fallbackUser.toFirestore());
        return fallbackUser;
      }
    } on FirebaseAuthException catch (e) {
      throw AppException.fromFirebaseAuth(e.code, e.message ?? 'Login failed.');
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException('An unexpected error occurred during login: $e');
    }
  }

  /// Fetches [AppUser] profile by User ID.
  Future<AppUser?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return AppUser.fromFirestore(doc.data()!, uid);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Signs out current user.
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AppException('Failed to log out: $e');
    }
  }
}
