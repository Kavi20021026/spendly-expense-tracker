import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../models/expense.dart';
import '../../providers/auth_provider.dart';
import '../../providers/expense_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/expense_card.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/monthly_summary.dart';
import '../expenses/add_expense_screen.dart';
import '../expenses/edit_expense_screen.dart';

class HomeScreen extends ConsumerWidget {
  final VoidCallback onNavigateToExpenses;

  const HomeScreen({
    super.key,
    required this.onNavigateToExpenses,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  void _showDeleteConfirmation(
      BuildContext context, WidgetRef ref, Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense?'),
        content: Text('Are you sure you want to delete "${expense.title}"?'),
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
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref
                  .read(expenseActionNotifierProvider.notifier)
                  .deleteExpense(expense.id);

              if (context.mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Expense deleted successfully.'),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to delete expense.'),
                      backgroundColor: AppColors.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userProfileAsync = ref.watch(currentUserProfileProvider);
    final expensesAsync = ref.watch(expensesStreamProvider);

    final userName = userProfileAsync.asData?.value?.displayName ?? 'User';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppStyles.md, vertical: AppStyles.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.glacierMint,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _getGreeting(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        userName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ],
                  ),

                  // Avatar Badge with subtle gradient ring
                  Container(
                    width: 46,
                    height: 46,
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.fabGradient,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.cardTheme.color,
                      ),
                      child: Center(
                        child: Text(
                          userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppStyles.md),

              // Luxury Fintech Hero Wallet Card
              const MonthlySummaryCard(),
              const SizedBox(height: AppStyles.md),

              // Quick Action Bar
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddExpenseScreen(),
                          ),
                        );
                      },
                      borderRadius: AppStyles.borderRadiusMd,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: AppStyles.borderRadiusMd,
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.25),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_circle_outline_rounded, size: 18, color: AppColors.primary),
                            SizedBox(width: 8),
                            Text(
                              'Add Expense',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppStyles.sm),
                  Expanded(
                    child: InkWell(
                      onTap: onNavigateToExpenses,
                      borderRadius: AppStyles.borderRadiusMd,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                          borderRadius: AppStyles.borderRadiusMd,
                          border: Border.all(
                            color: theme.dividerColor,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history_rounded,
                              size: 18,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'All Expenses',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                                fontSize: 13.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppStyles.lg),

              // Recent Expenses Header & See All
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Expenses',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      letterSpacing: -0.2,
                    ),
                  ),
                  TextButton(
                    onPressed: onNavigateToExpenses,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('See All', style: TextStyle(fontWeight: FontWeight.w700)),
                        Icon(Icons.arrow_forward_rounded, size: 14),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Recent Expenses List
              expensesAsync.when(
                data: (expenses) {
                  if (expenses.isEmpty) {
                    return EmptyStateWidget(
                      title: 'No expenses yet',
                      message: 'Start tracking your spending by adding your first expense.',
                      buttonText: 'Add Expense',
                      onButtonPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddExpenseScreen(),
                          ),
                        );
                      },
                    );
                  }

                  final recentExpenses = expenses.take(5).toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = recentExpenses[index];
                      return ExpenseCard(
                        expense: expense,
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditExpenseScreen(expense: expense),
                            ),
                          );
                        },
                        onDelete: () =>
                            _showDeleteConfirmation(context, ref, expense),
                      );
                    },
                  );
                },
                loading: () => const LoadingIndicator(
                  message: 'Loading recent expenses...',
                ),
                error: (error, stack) => ErrorStateWidget(
                  errorMessage: 'Failed to load expenses: $error',
                  onRetry: () => ref.refresh(expensesStreamProvider),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
