import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../providers/expense_provider.dart';
import '../../providers/filter_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/expense_chart.dart';
import '../../widgets/loading_indicator.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final filter = ref.watch(filterProvider);
    final expensesAsync = ref.watch(expensesStreamProvider);
    final monthExpenses = ref.watch(selectedMonthExpensesProvider);
    final totalSpent = ref.watch(selectedMonthTotalProvider);
    final categoryTotals = ref.watch(categoryTotalsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics & Spending'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_rounded),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: filter.selectedMonth,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                initialDatePickerMode: DatePickerMode.year,
              );
              if (picked != null) {
                ref.read(filterProvider.notifier).setSelectedMonth(picked);
              }
            },
          ),
        ],
      ),
      body: expensesAsync.when(
        data: (_) {
          if (monthExpenses.isEmpty) {
            return EmptyStateWidget(
              title: 'No analytics for ${DateFormatter.formatMonthYear(filter.selectedMonth)}',
              message: 'There are no expenses logged for this month.',
              icon: Icons.pie_chart_outline_rounded,
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppStyles.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppStyles.lg),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormatter.formatMonthYear(filter.selectedMonth),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              CurrencyFormatter.format(totalSpent),
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppStyles.md,
                            vertical: AppStyles.sm,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: AppStyles.borderRadiusLg,
                          ),
                          child: Text(
                            '${monthExpenses.length} Items',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppStyles.xl),

                // Spending Breakdown Title
                Text(
                  'Category Breakdown',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppStyles.md),

                // Interactive fl_chart Doughnut Chart Widget
                ExpensePieChart(
                  categoryTotals: categoryTotals,
                  totalAmount: totalSpent,
                ),
              ],
            ),
          );
        },
        loading: () => const LoadingIndicator(
          message: 'Analyzing spending data...',
        ),
        error: (error, stack) => ErrorStateWidget(
          errorMessage: 'Failed to load analytics: $error',
          onRetry: () => ref.refresh(expensesStreamProvider),
        ),
      ),
    );
  }
}
