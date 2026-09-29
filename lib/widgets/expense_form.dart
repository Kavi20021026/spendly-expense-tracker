import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_styles.dart';
import '../core/constants/categories.dart';
import '../core/utils/date_formatter.dart';
import '../core/validators/validators.dart';
import '../models/category.dart';
import '../models/expense.dart';
import 'category_selector.dart';

/// Reusable Form Widget for creating or editing an expense with Banking-style Hero Amount.
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
      text: expense != null ? expense.amount.toStringAsFixed(expense.amount % 1 == 0 ? 0 : 2) : '',
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

  void _addQuickAmount(double delta) {
    final current = double.tryParse(_amountController.text.trim()) ?? 0.0;
    final updated = current + delta;
    _amountController.text = updated.toStringAsFixed(updated % 1 == 0 ? 0 : 2);
    setState(() {});
  }

  Widget _buildQuickChip(String label, double amount) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () => _addQuickAmount(amount),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.primary.withValues(alpha: 0.15)
                : AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
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
    final isDark = theme.brightness == Brightness.dark;
    final isEditing = widget.initialExpense != null;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppStyles.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Amount Display & Quick Increment Chips
            Container(
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: AppStyles.borderRadiusXl,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1,
                ),
                boxShadow: isDark ? AppStyles.cardShadowDark : AppStyles.cardShadowLight,
              ),
              child: Column(
                children: [
                  Text(
                    'TRANSACTION AMOUNT',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Rs. ',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      IntrinsicWidth(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 90, maxWidth: 220),
                          child: TextFormField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                              color: theme.colorScheme.onSurface,
                            ),
                            decoration: InputDecoration(
                              hintText: '0',
                              hintStyle: TextStyle(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              filled: false,
                            ),
                            validator: Validators.validateAmount,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Quick Increment Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildQuickChip('+100', 100),
                        _buildQuickChip('+500', 500),
                        _buildQuickChip('+1,000', 1000),
                        _buildQuickChip('+5,000', 5000),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppStyles.lg),

            // Expense Title Field
            TextFormField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Expense Title',
                hintText: 'e.g. Lunch with colleagues',
                prefixIcon: Icon(Icons.edit_note_rounded),
              ),
              validator: Validators.validateTitle,
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
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
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
                hintText: 'Add extra details or payment method...',
                alignLabelWithHint: true,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Icon(Icons.notes_rounded),
                ),
              ),
              validator: Validators.validateNote,
            ),
            const SizedBox(height: AppStyles.xl),

            // Gradient Submit Button
            Container(
              decoration: BoxDecoration(
                borderRadius: AppStyles.borderRadiusMd,
                gradient: AppColors.fabGradient,
                boxShadow: AppStyles.glowGlacier,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppStyles.borderRadiusMd,
                  ),
                ),
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
                    : Text(
                        isEditing ? 'Update Expense' : 'Save Expense',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
