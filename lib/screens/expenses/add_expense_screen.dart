import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/expense_provider.dart';
import '../../widgets/expense_form.dart';

class AddExpenseScreen extends ConsumerWidget {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionState = ref.watch(expenseActionNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: ExpenseForm(
        isLoading: actionState.isLoading,
        onSubmit: ({
          required String title,
          required double amount,
          required String category,
          required DateTime date,
          String? note,
        }) async {
          final success = await ref
              .read(expenseActionNotifierProvider.notifier)
              .addExpense(
                title: title,
                amount: amount,
                category: category,
                date: date,
                note: note,
              );

          if (!context.mounted) return;

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Expense saved successfully!'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          } else {
            final error = ref.read(expenseActionNotifierProvider).errorMessage ??
                'Failed to save expense.';
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
