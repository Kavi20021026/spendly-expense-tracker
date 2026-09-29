import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_styles.dart';
import '../core/constants/categories.dart';
import '../core/utils/currency_formatter.dart';
import '../core/utils/date_formatter.dart';
import '../models/expense.dart';

/// Reusable Card displaying a single Expense item with action options.
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
    final categoryObj = AppCategories.fromNameOrId(expense.category);

    return Card(
      margin: const EdgeInsets.only(bottom: AppStyles.sm),
      child: InkWell(
        onTap: onTap ?? onEdit,
        borderRadius: AppStyles.borderRadiusLg,
        child: Padding(
          padding: const EdgeInsets.all(AppStyles.md),
          child: Row(
            children: [
              // Category Icon Badge
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: categoryObj.color.withOpacity(0.12),
                  borderRadius: AppStyles.borderRadiusMd,
                ),
                child: Icon(
                  categoryObj.icon,
                  color: categoryObj.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppStyles.md),

              // Title, Category & Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          categoryObj.name,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: categoryObj.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          ' • ${DateFormatter.formatShortDate(expense.date)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        if (expense.note != null && expense.note!.isNotEmpty) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.notes_rounded,
                            size: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppStyles.sm),

              // Formatted Amount & Popup Action Menu
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyFormatter.format(expense.amount),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),

              if (onEdit != null || onDelete != null)
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    size: 20,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
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
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                          SizedBox(width: 8),
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
    );
  }
}
