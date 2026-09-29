import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../core/constants/categories.dart';
import '../../models/expense.dart';
import '../../providers/expense_provider.dart';
import '../../providers/filter_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/expense_card.dart';
import '../../widgets/loading_indicator.dart';
import 'add_expense_screen.dart';
import 'edit_expense_screen.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  void _showDateFilterModal(BuildContext context, WidgetRef ref) {
    final filter = ref.read(filterProvider);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppStyles.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter by Date Range',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppStyles.md),
            ListTile(
              title: const Text('All Time'),
              trailing: filter.dateFilter == DateFilterOption.all
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                ref.read(filterProvider.notifier).setDateFilter(DateFilterOption.all);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Current Month'),
              trailing: filter.dateFilter == DateFilterOption.currentMonth
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                ref.read(filterProvider.notifier).setDateFilter(DateFilterOption.currentMonth);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Last Month'),
              trailing: filter.dateFilter == DateFilterOption.lastMonth
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                ref.read(filterProvider.notifier).setDateFilter(DateFilterOption.lastMonth);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('This Year'),
              trailing: filter.dateFilter == DateFilterOption.thisYear
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                ref.read(filterProvider.notifier).setDateFilter(DateFilterOption.thisYear);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filterState = ref.watch(filterProvider);
    final expensesAsync = ref.watch(expensesStreamProvider);
    final filteredExpenses = ref.watch(filteredExpensesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense History'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list_rounded,
              color: filterState.dateFilter != DateFilterOption.all
                  ? AppColors.primary
                  : null,
            ),
            onPressed: () => _showDateFilterModal(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppStyles.md,
              vertical: AppStyles.sm,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                ref.read(filterProvider.notifier).setSearchQuery(val);
              },
              decoration: InputDecoration(
                hintText: 'Search title, note, or category...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(filterProvider.notifier).setSearchQuery('');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Category Chips Bar
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppStyles.md),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: AppStyles.xs),
                  child: ChoiceChip(
                    label: const Text('All'),
                    selected: filterState.selectedCategory == 'All',
                    onSelected: (_) {
                      ref.read(filterProvider.notifier).setCategory('All');
                    },
                  ),
                ),
                ...AppCategories.all.map((cat) {
                  final isSelected = filterState.selectedCategory.toLowerCase() ==
                      cat.name.toLowerCase();
                  return Padding(
                    padding: const EdgeInsets.only(right: AppStyles.xs),
                    child: ChoiceChip(
                      avatar: Icon(
                        cat.icon,
                        size: 16,
                        color: isSelected ? Colors.white : cat.color,
                      ),
                      label: Text(cat.name),
                      selected: isSelected,
                      selectedColor: cat.color,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                      ),
                      onSelected: (_) {
                        ref.read(filterProvider.notifier).setCategory(cat.name);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: AppStyles.sm),

          // Result Count Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppStyles.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredExpenses.length} ${filteredExpenses.length == 1 ? 'expense' : 'expenses'} found',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (filterState.selectedCategory != 'All' ||
                    filterState.searchQuery.isNotEmpty ||
                    filterState.dateFilter != DateFilterOption.all)
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(60, 24),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(filterProvider.notifier).resetFilters();
                    },
                    child: const Text('Reset Filters', style: TextStyle(fontSize: 12)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppStyles.xs),

          // Expense Items List
          Expanded(
            child: expensesAsync.when(
              data: (_) {
                if (filteredExpenses.isEmpty) {
                  return EmptyStateWidget(
                    title: filterState.searchQuery.isNotEmpty ||
                            filterState.selectedCategory != 'All'
                        ? 'No matching expenses'
                        : 'No expenses yet',
                    message: filterState.searchQuery.isNotEmpty ||
                            filterState.selectedCategory != 'All'
                        ? 'Try clearing search or filters to see more expenses.'
                        : 'Start tracking your spending by adding your first expense.',
                    buttonText: filterState.searchQuery.isEmpty &&
                            filterState.selectedCategory == 'All'
                        ? 'Add Expense'
                        : null,
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

                return ListView.builder(
                  padding: const EdgeInsets.all(AppStyles.md),
                  itemCount: filteredExpenses.length,
                  itemBuilder: (context, index) {
                    final expense = filteredExpenses[index];
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
                message: 'Loading expense history...',
              ),
              error: (error, stack) => ErrorStateWidget(
                errorMessage: 'Error loading expenses: $error',
                onRetry: () => ref.refresh(expensesStreamProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
