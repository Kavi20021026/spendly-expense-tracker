import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';

/// Repository interface for authentication operations.
abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<AppUser> login({required String email, required String password});
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  });
  Future<AppUser?> getUserProfile(String uid);
  Future<void> logout();
}

/// Concrete implementation of [AuthRepository] delegating to [AuthService].
class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl({AuthService? authService})
      : _authService = authService ?? AuthService();

  @override
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  @override
  User? get currentUser => _authService.currentUser;

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) =>
      _authService.login(email: email, password: password);

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) =>
      _authService.register(name: name, email: email, password: password);

  @override
  Future<AppUser?> getUserProfile(String uid) =>
      _authService.getUserProfile(uid);

  @override
  Future<void> logout() => _authService.logout();
}
