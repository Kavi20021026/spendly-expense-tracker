import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../models/expense.dart';
import '../../providers/expense_provider.dart';
import '../../widgets/expense_form.dart';

class EditExpenseScreen extends ConsumerWidget {
  final Expense expense;

  const EditExpenseScreen({super.key, required this.expense});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionState = ref.watch(expenseActionNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Expense'),
      ),
      body: ExpenseForm(
        initialExpense: expense,
        isLoading: actionState.isLoading,
        onSubmit: ({
          required String title,
          required double amount,
          required String category,
          required DateTime date,
          String? note,
        }) async {
          final updatedExpense = expense.copyWith(
            title: title,
            amount: amount,
            category: category,
            date: date,
            note: note,
            updatedAt: DateTime.now(),
          );

          final success = await ref
              .read(expenseActionNotifierProvider.notifier)
              .updateExpense(updatedExpense);

          if (!context.mounted) return;

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Expense updated successfully!'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          } else {
            final error = ref.read(expenseActionNotifierProvider).errorMessage ??
                'Failed to update expense.';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }
}
