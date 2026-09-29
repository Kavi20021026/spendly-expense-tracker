import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_user.dart';
import '../repositories/auth_repository.dart';

/// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

/// Auth State Changes Stream Provider
final authStateProvider = StreamProvider<User?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});

/// Current Authenticated AppUser Profile Provider
final currentUserProfileProvider = FutureProvider<AppUser?>((ref) async {
  final authState = ref.watch(authStateProvider);
  final user = authState.asData?.value;

  if (user == null) return null;

  final repository = ref.read(authRepositoryProvider);
  return await repository.getUserProfile(user.uid);
});

/// State representation for Auth Actions (Login / Register / Logout)
class AuthActionState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const AuthActionState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  AuthActionState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return AuthActionState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

/// Notifier handling Authentication actions
class AuthNotifier extends Notifier<AuthActionState> {
  @override
  AuthActionState build() => const AuthActionState();

  void clearState() {
    state = const AuthActionState();
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.login(email: email, password: password);
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.register(name: name, email: email, password: password);
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.logout();
      state = const AuthActionState();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthActionState>(AuthNotifier.new);
