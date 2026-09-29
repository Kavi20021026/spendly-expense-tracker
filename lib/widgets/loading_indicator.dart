import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_styles.dart';

/// Reusable loading indicator widget with optional message text.
class LoadingIndicator extends StatelessWidget {
  final String? message;

  const LoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppStyles.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            if (message != null) ...[
              const SizedBox(height: AppStyles.md),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
