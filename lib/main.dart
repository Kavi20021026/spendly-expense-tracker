import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_shell.dart';

import 'providers/onboarding_provider.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization warning: $e');
  }

  runApp(
    const ProviderScope(
      child: SpendlyApp(),
    ),
  );
}

class SpendlyApp extends ConsumerWidget {
  const SpendlyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp(
      title: 'Spendly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const AuthGate(),
    );
  }
}

/// Orchestrates smooth startup transitions:
/// Native Splash -> Animated Brand Splash -> (Onboarding on 1st launch) -> Login / Main Dashboard.
class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  bool _splashFinished = false;

  @override
  Widget build(BuildContext context) {
    final authStateAsync = ref.watch(authStateProvider);
    final onboardingAsync = ref.watch(onboardingNotifierProvider);

    Widget activeScreen;

    if (!_splashFinished) {
      activeScreen = SplashScreen(
        key: const ValueKey('splash_screen'),
        onFinish: () {
          if (mounted) {
            setState(() => _splashFinished = true);
          }
        },
      );
    } else {
      activeScreen = authStateAsync.when(
        data: (user) {
          final hasCompletedOnboarding = onboardingAsync.value ?? false;
          if (!hasCompletedOnboarding) {
            return OnboardingScreen(
              key: const ValueKey('onboarding_screen'),
              onGetStarted: () {
                ref.read(onboardingNotifierProvider.notifier).completeOnboarding();
              },
            );
          }

          if (user != null) {
            return const MainShell(key: ValueKey('main_shell'));
          }

          return const LoginScreen(key: ValueKey('login_screen'));
        },
        loading: () => SplashScreen(
          key: const ValueKey('splash_screen_waiting'),
          onFinish: () {},
        ),
        error: (error, stack) => const LoginScreen(key: ValueKey('login_error')),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: activeScreen,
    );
  }
}

