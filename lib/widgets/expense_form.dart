import 'package:flutter/material.dart';

import '../core/constants/app_styles.dart';
import '../core/constants/categories.dart';
import '../core/utils/date_formatter.dart';
import '../core/validators/validators.dart';
import '../models/category.dart';
import '../models/expense.dart';
import 'category_selector.dart';

/// Reusable Form Widget for creating or editing an expense.
class ExpenseForm extends StatefulWidget {
  final Expense? initialExpense;
  final bool isLoading;
  final Function({
    required String title,
    required double amount,
    required String category,
    required DateTime date,
    String? note,
  }) onSubmit;

  const ExpenseForm({
    super.key,
    this.initialExpense,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _noteController;

  late Category _selectedCategory;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final expense = widget.initialExpense;

    _titleController = TextEditingController(text: expense?.title ?? '');
    _amountController = TextEditingController(
      text: expense != null ? expense.amount.toStringAsFixed(2) : '',
    );
    _noteController = TextEditingController(text: expense?.note ?? '');

    _selectedCategory = expense != null
        ? AppCategories.fromNameOrId(expense.category)
        : AppCategories.food;

    _selectedDate = expense?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    final title = _titleController.text.trim();
    final amount = double.parse(_amountController.text.trim());
    final note = _noteController.text.trim();

    widget.onSubmit(
      title: title,
      amount: amount,
      category: _selectedCategory.name,
      date: _selectedDate,
      note: note.isEmpty ? null : note,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.initialExpense != null;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppStyles.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Expense Title Field
            TextFormField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Expense Title',
                hintText: 'e.g. Lunch with friends',
                prefixIcon: Icon(Icons.edit_note_rounded),
              ),
              validator: Validators.validateTitle,
            ),
            const SizedBox(height: AppStyles.md),

            // Amount Field
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Amount (Rs.)',
                hintText: '850.00',
                prefixIcon: Icon(Icons.payments_outlined),
              ),
              validator: Validators.validateAmount,
            ),
            const SizedBox(height: AppStyles.md),

            // Date Picker Field
            InkWell(
              onTap: _pickDate,
              borderRadius: AppStyles.borderRadiusMd,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Expense Date',
                  prefixIcon: Icon(Icons.calendar_today_rounded),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormatter.formatFullDate(_selectedDate),
                      style: theme.textTheme.bodyLarge,
                    ),
                    const Icon(Icons.arrow_drop_down_rounded),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppStyles.lg),

            // Category Selector Widget
            CategorySelector(
              selectedCategoryName: _selectedCategory.name,
              onCategorySelected: (cat) {
                setState(() {
                  _selectedCategory = cat;
                });
              },
            ),
            const SizedBox(height: AppStyles.lg),

            // Optional Note Field
            TextFormField(
              controller: _noteController,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Optional Note',
                hintText: 'Add extra details...',
                alignLabelWithHint: true,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Icon(Icons.notes_rounded),
                ),
              ),
              validator: Validators.validateNote,
            ),
            const SizedBox(height: AppStyles.xl),

            // Submit Button
            ElevatedButton(
              onPressed: widget.isLoading ? null : _submit,
              child: widget.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(isEditing ? 'Update Expense' : 'Save Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
