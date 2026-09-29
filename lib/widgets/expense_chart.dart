import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_styles.dart';
import '../core/constants/categories.dart';
import '../core/utils/currency_formatter.dart';

/// Modern Hollow Donut Chart with Center Metric Display & Category Progress Bars.
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
    final isDark = theme.brightness == Brightness.dark;

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
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppStyles.sm),
            Text(
              'No expense data available for chart',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    final sortedEntries = widget.categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Resolve what to show inside the donut center
    String centerLabel = 'TOTAL SPENT';
    String centerValue = CurrencyFormatter.format(widget.totalAmount);
    Color centerColor = theme.colorScheme.onSurface;

    if (touchedIndex >= 0 && touchedIndex < sortedEntries.length) {
      final touched = sortedEntries[touchedIndex];
      final cat = AppCategories.fromNameOrId(touched.key);
      centerLabel = cat.name.toUpperCase();
      centerValue = CurrencyFormatter.format(touched.value);
      centerColor = cat.color;
    }

    return Column(
      children: [
        // Hollow Donut with Interactive Center Metric
        SizedBox(
          height: 240,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
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
                  sectionsSpace: 4,
                  centerSpaceRadius: 64,
                  sections: List.generate(sortedEntries.length, (i) {
                    final isTouched = i == touchedIndex;
                    final entry = sortedEntries[i];
                    final category = AppCategories.fromNameOrId(entry.key);
                    final percentage = (entry.value / widget.totalAmount) * 100;
                    final radius = isTouched ? 42.0 : 34.0;

                    return PieChartSectionData(
                      color: category.color,
                      value: entry.value,
                      title: percentage >= 8 ? '${percentage.toStringAsFixed(0)}%' : '',
                      radius: radius,
                      titleStyle: TextStyle(
                        fontSize: isTouched ? 14 : 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    );
                  }),
                ),
              ),

              // Center Metric Widget
              GestureDetector(
                onTap: () {
                  setState(() {
                    touchedIndex = -1;
                  });
                },
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        centerLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                          color: centerColor.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            centerValue,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: centerColor,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppStyles.lg),

        // Category Breakdown Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Category Breakdown',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            Text(
              '${sortedEntries.length} Categories',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppStyles.sm),

        // Category Progress Bar Cards
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedEntries.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final entry = sortedEntries[index];
            final category = AppCategories.fromNameOrId(entry.key);
            final percentage = (entry.value / widget.totalAmount);
            final percentText = (percentage * 100).toStringAsFixed(1);
            final isTouched = index == touchedIndex;

            return InkWell(
              onTap: () {
                setState(() {
                  touchedIndex = touchedIndex == index ? -1 : index;
                });
              },
              borderRadius: AppStyles.borderRadiusMd,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: AppStyles.borderRadiusMd,
                  border: Border.all(
                    color: isTouched
                        ? category.color
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    width: isTouched ? 1.5 : 1,
                  ),
                  boxShadow: isTouched
                      ? [
                          BoxShadow(
                            color: category.color.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Category Icon
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: category.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(category.icon, size: 18, color: category.color),
                        ),
                        const SizedBox(width: 10),

                        // Name & Percentage
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.name,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '$percentText% of total',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Formatted Amount
                        Text(
                          CurrencyFormatter.format(entry.value),
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: theme.colorScheme.onSurface,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Linear Spending Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: percentage.clamp(0.0, 1.0),
                        minHeight: 6,
                        backgroundColor: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.05),
                        valueColor: AlwaysStoppedAnimation<Color>(category.color),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
