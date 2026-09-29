import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_styles.dart';
import '../core/constants/categories.dart';
import '../core/utils/currency_formatter.dart';
import '../core/utils/date_formatter.dart';
import '../models/expense.dart';

/// Modern elevated card displaying an expense item with sleek fintech styling.
class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ExpenseCard({
    super.key,
    required this.expense,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final categoryObj = AppCategories.fromNameOrId(expense.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppStyles.borderRadiusLg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: isDark ? AppStyles.cardShadowDark : AppStyles.cardShadowLight,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? onEdit,
          borderRadius: AppStyles.borderRadiusLg,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            child: Row(
              children: [
                // Glowing Tinted Category Badge
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: categoryObj.color.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: categoryObj.color.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      categoryObj.icon,
                      color: categoryObj.color,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Title, Category Tag & Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          // Category Mini-Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: categoryObj.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              categoryObj.name,
                              style: TextStyle(
                                color: categoryObj.color,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            DateFormatter.formatShortDate(expense.date),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                              fontSize: 11.5,
                            ),
                          ),
                          if (expense.note != null && expense.note!.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Icon(
                              Icons.description_outlined,
                              size: 13,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Formatted Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '- ${CurrencyFormatter.format(expense.amount)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15.5,
                        color: AppColors.error,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),

                // Action Menu
                if (onEdit != null || onDelete != null)
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert_rounded,
                      size: 20,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    padding: EdgeInsets.zero,
                    splashRadius: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppStyles.borderRadiusMd,
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit?.call();
                      } else if (value == 'delete') {
                        onDelete?.call();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 18),
                            SizedBox(width: 10),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                            SizedBox(width: 10),
                            Text('Delete', style: TextStyle(color: AppColors.error)),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
