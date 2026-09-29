import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_styles.dart';
import '../core/utils/currency_formatter.dart';
import '../core/utils/date_formatter.dart';
import '../providers/expense_provider.dart';
import '../providers/filter_provider.dart';

/// Luxury Fintech "Hero Wallet" Card showing current/selected month's statistics.
class MonthlySummaryCard extends ConsumerWidget {
  const MonthlySummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);
    final totalSpent = ref.watch(selectedMonthTotalProvider);
    final monthExpenses = ref.watch(selectedMonthExpensesProvider);
    final averageExpense = ref.watch(selectedMonthAverageProvider);

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppStyles.borderRadiusXl,
        boxShadow: AppStyles.fintechCardShadow,
      ),
      child: ClipRRect(
        borderRadius: AppStyles.borderRadiusXl,
        child: Stack(
          children: [
            // Background Mesh Gradient
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.heroWalletGradient,
              ),
              padding: const EdgeInsets.all(AppStyles.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Month Badge & Calendar Action
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Frosted Month Pill
                      InkWell(
                        onTap: () async {
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
                        borderRadius: AppStyles.borderRadiusLg,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: AppStyles.borderRadiusLg,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                size: 14,
                                color: AppColors.mintHighlight,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                DateFormatter.formatMonthYear(filter.selectedMonth),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 16,
                                color: Colors.white70,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Holographic Card Watermark Badge
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                            child: const Icon(
                              Icons.contactless_rounded,
                              color: Colors.white70,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'SPENDLY',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppStyles.lg),

                  // Hero Spending Amount
                  Text(
                    'TOTAL EXPENSES',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          CurrencyFormatter.format(totalSpent),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1.0,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppStyles.lg),

                  // Frosted Micro-Stat Capsules
                  Row(
                    children: [
                      // Transactions Count Pill
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.15),
                            borderRadius: AppStyles.borderRadiusMd,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.glacier.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.receipt_long_rounded,
                                  color: AppColors.glacierLight,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Transactions',
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.65),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${monthExpenses.length}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppStyles.sm),

                      // Average Spent Pill
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.15),
                            borderRadius: AppStyles.borderRadiusMd,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.glacierMint.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.auto_graph_rounded,
                                  color: AppColors.mintHighlight,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Average',
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.65),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        CurrencyFormatter.format(averageExpense),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Decorative Translucent Orbs for Depth
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.glacier.withValues(alpha: 0.12),
                ),
              ),
            ),
            Positioned(
              left: 40,
              bottom: -40,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.mintHighlight.withValues(alpha: 0.08),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
