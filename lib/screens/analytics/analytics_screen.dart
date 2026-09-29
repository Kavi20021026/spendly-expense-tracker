import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../core/constants/categories.dart';
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
    final isDark = theme.brightness == Brightness.dark;
    final filter = ref.watch(filterProvider);
    final expensesAsync = ref.watch(expensesStreamProvider);
    final monthExpenses = ref.watch(selectedMonthExpensesProvider);
    final totalSpent = ref.watch(selectedMonthTotalProvider);
    final categoryTotals = ref.watch(categoryTotalsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics & Insights'),
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

          // Compute Top Spending Category
          String? topCategoryName;
          double topCategoryAmount = 0.0;
          for (final entry in categoryTotals.entries) {
            if (entry.value > topCategoryAmount) {
              topCategoryAmount = entry.value;
              topCategoryName = entry.key;
            }
          }
          final topCategoryObj = topCategoryName != null
              ? AppCategories.fromNameOrId(topCategoryName)
              : null;
          final topCategoryPercent = totalSpent > 0
              ? (topCategoryAmount / totalSpent * 100).toStringAsFixed(0)
              : '0';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppStyles.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Highlight Card: Monthly Overview
                Container(
                  padding: const EdgeInsets.all(AppStyles.lg),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: AppStyles.borderRadiusLg,
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                    boxShadow: isDark ? AppStyles.cardShadowDark : AppStyles.cardShadowLight,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormatter.formatMonthYear(filter.selectedMonth).toUpperCase(),
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            CurrencyFormatter.format(totalSpent),
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${monthExpenses.length} Transactions',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppStyles.md),

                // Top Spending Category Feature Card
                if (topCategoryObj != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: topCategoryObj.color.withValues(alpha: 0.1),
                      borderRadius: AppStyles.borderRadiusLg,
                      border: Border.all(
                        color: topCategoryObj.color.withValues(alpha: 0.25),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: topCategoryObj.color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            topCategoryObj.icon,
                            color: topCategoryObj.color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TOP SPENDING CATEGORY',
                                style: TextStyle(
                                  color: topCategoryObj.color,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                topCategoryObj.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              CurrencyFormatter.format(topCategoryAmount),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: topCategoryObj.color,
                              ),
                            ),
                            Text(
                              '$topCategoryPercent% of month',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppStyles.lg),
                ],

                // Interactive Donut Chart & Category Progress Bars
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
