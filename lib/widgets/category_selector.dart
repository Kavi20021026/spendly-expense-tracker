import 'package:flutter/material.dart';
import '../core/constants/app_styles.dart';
import '../core/constants/categories.dart';
import '../models/category.dart';

/// Interactive Grid / List Category Selector for forms and filters.
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
            'Select Category',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppStyles.sm),
        ],
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.2,
            crossAxisSpacing: AppStyles.sm,
            mainAxisSpacing: AppStyles.sm,
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
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? category.color.withOpacity(0.15)
                      : theme.cardTheme.color,
                  borderRadius: AppStyles.borderRadiusMd,
                  border: Border.all(
                    color: isSelected ? category.color : theme.dividerColor,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category.icon,
                      size: 18,
                      color: isSelected ? category.color : theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        category.name,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isSelected ? category.color : theme.colorScheme.onSurface,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
