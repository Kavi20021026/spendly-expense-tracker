import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _onboardingPrefKey = 'spendly_has_completed_onboarding';

/// Manages whether the user has seen and completed the initial onboarding walkthrough.
class OnboardingNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_onboardingPrefKey) ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Marks onboarding as completed and persists to SharedPreferences.
  Future<void> completeOnboarding() async {
    state = const AsyncValue.data(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingPrefKey, true);
    } catch (_) {}
  }

  /// Resets onboarding status (useful for 'Replay Tour' in settings or testing).
  Future<void> resetOnboarding() async {
    state = const AsyncValue.data(false);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingPrefKey, false);
    } catch (_) {}
  }
}

final onboardingNotifierProvider =
    AsyncNotifierProvider<OnboardingNotifier, bool>(OnboardingNotifier.new);
