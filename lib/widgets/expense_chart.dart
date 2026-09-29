import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../core/constants/app_styles.dart';
import '../core/constants/categories.dart';
import '../core/utils/currency_formatter.dart';

/// Interactive Pie/Donut Chart visualizing category spending distribution using fl_chart.
class ExpensePieChart extends StatefulWidget {
  final Map<String, double> categoryTotals;
  final double totalAmount;

  const ExpensePieChart({
    super.key,
    required this.categoryTotals,
    required this.totalAmount,
  });

  @override
  State<ExpensePieChart> createState() => _ExpensePieChartState();
}

class _ExpensePieChartState extends State<ExpensePieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.categoryTotals.isEmpty || widget.totalAmount <= 0) {
      return Container(
        height: 220,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart_outline_rounded,
              size: 48,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: AppStyles.sm),
            Text(
              'No expense data available for chart',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    final sortedEntries = widget.categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = pieTouchResponse
                        .touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 3,
              centerSpaceRadius: 46,
              sections: List.generate(sortedEntries.length, (i) {
                final isTouched = i == touchedIndex;
                final entry = sortedEntries[i];
                final category = AppCategories.fromNameOrId(entry.key);
                final percentage = (entry.value / widget.totalAmount) * 100;
                final radius = isTouched ? 45.0 : 38.0;

                return PieChartSectionData(
                  color: category.color,
                  value: entry.value,
                  title: percentage >= 5 ? '${percentage.toStringAsFixed(0)}%' : '',
                  radius: radius,
                  titleStyle: TextStyle(
                    fontSize: isTouched ? 14 : 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: AppStyles.md),

        // Category Legend List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedEntries.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppStyles.xs),
          itemBuilder: (context, index) {
            final entry = sortedEntries[index];
            final category = AppCategories.fromNameOrId(entry.key);
            final percentage = (entry.value / widget.totalAmount) * 100;

            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppStyles.sm,
                vertical: AppStyles.xs,
              ),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: AppStyles.borderRadiusSm,
              ),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: category.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppStyles.sm),
                  Icon(category.icon, size: 16, color: category.color),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      category.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(width: AppStyles.md),
                  Text(
                    CurrencyFormatter.format(entry.value),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
