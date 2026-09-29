import 'package:flutter/material.dart';
import '../core/constants/app_styles.dart';
import '../core/constants/categories.dart';
import '../models/category.dart';

/// Interactive Grid Category Selector with modern glowing pills.
class CategorySelector extends StatelessWidget {
  final String selectedCategoryName;
  final ValueChanged<Category> onCategorySelected;
  final bool isFilter;

  const CategorySelector({
    super.key,
    required this.selectedCategoryName,
    required this.onCategorySelected,
    this.isFilter = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = AppCategories.all;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isFilter) ...[
          Text(
            'Expense Category',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: AppStyles.sm),
        ],
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = selectedCategoryName.toLowerCase() == category.name.toLowerCase() ||
                selectedCategoryName.toLowerCase() == category.id.toLowerCase();

            return InkWell(
              onTap: () => onCategorySelected(category),
              borderRadius: AppStyles.borderRadiusMd,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  color: isSelected
                      ? category.color.withValues(alpha: 0.16)
                      : theme.cardTheme.color,
                  borderRadius: AppStyles.borderRadiusMd,
                  border: Border.all(
                    color: isSelected ? category.color : theme.dividerColor,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: category.color.withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          )
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category.icon,
                      size: 17,
                      color: isSelected ? category.color : theme.colorScheme.onSurface.withValues(alpha: 0.65),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        category.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isSelected ? category.color : theme.colorScheme.onSurface,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 12.5,
                        ),
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
