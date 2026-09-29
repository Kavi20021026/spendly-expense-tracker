import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out of Spendly?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              minimumSize: const Size(100, 40),
            ),
            onPressed: () {
              Navigator.pop(context);
              ref.read(authNotifierProvider.notifier).logout();
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userProfileAsync = ref.watch(currentUserProfileProvider);
    final themeMode = ref.watch(themeNotifierProvider);

    final user = userProfileAsync.asData?.value;
    final name = user?.displayName ?? 'User';
    final email = user?.email ?? 'Loading email...';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppStyles.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppStyles.lg),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppStyles.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            email,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppStyles.xl),

            // Appearance Section
            Text(
              'Appearance',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppStyles.sm),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('System Default'),
                    leading: const Icon(Icons.settings_suggest_rounded),
                    trailing: themeMode == ThemeMode.system
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                        : null,
                    onTap: () {
                      ref.read(themeNotifierProvider.notifier).setThemeMode(ThemeMode.system);
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Light Theme'),
                    leading: const Icon(Icons.light_mode_rounded),
                    trailing: themeMode == ThemeMode.light
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                        : null,
                    onTap: () {
                      ref.read(themeNotifierProvider.notifier).setThemeMode(ThemeMode.light);
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Dark Theme'),
                    leading: const Icon(Icons.dark_mode_rounded),
                    trailing: themeMode == ThemeMode.dark
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                        : null,
                    onTap: () {
                      ref.read(themeNotifierProvider.notifier).setThemeMode(ThemeMode.dark);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppStyles.xl),

            // App Info & About
            Text(
              'About Spendly',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppStyles.sm),
            Card(
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.info_outline_rounded),
                    title: Text('Application Version'),
                    trailing: Text('1.0.0 (Production)'),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.security_rounded),
                    title: Text('Data Privacy'),
                    subtitle: Text('Isolated Firestore rules per user'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppStyles.xl),

            // Logout Button
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
              ),
              onPressed: () => _showLogoutDialog(context, ref),
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
