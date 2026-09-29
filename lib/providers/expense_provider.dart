import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/date_formatter.dart';
import '../models/expense.dart';
import '../repositories/expense_repository.dart';
import 'auth_provider.dart';
import 'filter_provider.dart';

/// Expense Repository Provider
final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepositoryImpl();
});

/// Raw Stream Provider of all user expenses from Firestore
final expensesStreamProvider = StreamProvider<List<Expense>>((ref) {
  final authState = ref.watch(authStateProvider);
  final user = authState.asData?.value;

  if (user == null) {
    return Stream.value([]);
  }

  final repository = ref.watch(expenseRepositoryProvider);
  return repository.getExpensesStream(user.uid);
});

/// Filtered Expenses Provider based on search, category, and date filters
final filteredExpensesProvider = Provider<List<Expense>>((ref) {
  final expensesAsync = ref.watch(expensesStreamProvider);
  final expenses = expensesAsync.asData?.value ?? [];
  final filter = ref.watch(filterProvider);

  return expenses.where((expense) {
    // 1. Search Query Filter (Title, Note, Category)
    if (filter.searchQuery.isNotEmpty) {
      final query = filter.searchQuery.trim().toLowerCase();
      final matchTitle = expense.title.toLowerCase().contains(query);
      final matchNote = (expense.note ?? '').toLowerCase().contains(query);
      final matchCategory = expense.category.toLowerCase().contains(query);
      if (!matchTitle && !matchNote && !matchCategory) {
        return false;
      }
    }

    // 2. Category Filter
    if (filter.selectedCategory != 'All' && filter.selectedCategory.isNotEmpty) {
      if (expense.category.toLowerCase() != filter.selectedCategory.toLowerCase()) {
        return false;
      }
    }

    // 3. Date Filter
    final now = DateTime.now();
    switch (filter.dateFilter) {
      case DateFilterOption.currentMonth:
        if (!DateFormatter.isSameMonth(expense.date, now)) return false;
        break;
      case DateFilterOption.lastMonth:
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        if (!DateFormatter.isSameMonth(expense.date, lastMonth)) return false;
        break;
      case DateFilterOption.thisYear:
        if (expense.date.year != now.year) return false;
        break;
      case DateFilterOption.customRange:
        if (filter.customStartDate != null && expense.date.isBefore(filter.customStartDate!)) {
          return false;
        }
        if (filter.customEndDate != null &&
            expense.date.isAfter(filter.customEndDate!.add(const Duration(days: 1)))) {
          return false;
        }
        break;
      case DateFilterOption.all:
        break;
    }

    return true;
  }).toList();
});

/// Expenses filtered for the user's selected dashboard month
final selectedMonthExpensesProvider = Provider<List<Expense>>((ref) {
  final expensesAsync = ref.watch(expensesStreamProvider);
  final expenses = expensesAsync.asData?.value ?? [];
  final selectedMonth = ref.watch(filterProvider).selectedMonth;

  return expenses.where((expense) {
    return DateFormatter.isSameMonth(expense.date, selectedMonth);
  }).toList();
});

/// Total amount spent in the selected month
final selectedMonthTotalProvider = Provider<double>((ref) {
  final monthExpenses = ref.watch(selectedMonthExpensesProvider);
  return monthExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
});

/// Average transaction amount in the selected month
final selectedMonthAverageProvider = Provider<double>((ref) {
  final monthExpenses = ref.watch(selectedMonthExpensesProvider);
  if (monthExpenses.isEmpty) return 0.0;
  final total = ref.watch(selectedMonthTotalProvider);
  return total / monthExpenses.length;
});

/// Map of category spending totals for the selected month or filtered set
final categoryTotalsProvider = Provider<Map<String, double>>((ref) {
  final expenses = ref.watch(selectedMonthExpensesProvider);
  final Map<String, double> categoryMap = {};

  for (final expense in expenses) {
    final current = categoryMap[expense.category] ?? 0.0;
    categoryMap[expense.category] = current + expense.amount;
  }

  return categoryMap;
});

/// State representation for expense CRUD operations
class ExpenseActionState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const ExpenseActionState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  ExpenseActionState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return ExpenseActionState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

/// Notifier handling Add, Edit, and Delete Expense actions
class ExpenseActionNotifier extends Notifier<ExpenseActionState> {
  @override
  ExpenseActionState build() => const ExpenseActionState();

  void clearState() {
    state = const ExpenseActionState();
  }

  String? _getUserId() {
    final authState = ref.read(authStateProvider);
    return authState.asData?.value?.uid;
  }

  Future<bool> addExpense({
    required String title,
    required double amount,
    required String category,
    required DateTime date,
    String? note,
  }) async {
    final uid = _getUserId();
    if (uid == null) {
      state = state.copyWith(errorMessage: 'User not authenticated.');
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      final now = DateTime.now();
      final newExpense = Expense(
        id: '',
        title: title,
        amount: amount,
        category: category,
        date: date,
        note: note,
        createdAt: now,
        updatedAt: now,
      );

      final repository = ref.read(expenseRepositoryProvider);
      await repository.addExpense(uid, newExpense);
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> updateExpense(Expense expense) async {
    final uid = _getUserId();
    if (uid == null) {
      state = state.copyWith(errorMessage: 'User not authenticated.');
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      final repository = ref.read(expenseRepositoryProvider);
      await repository.updateExpense(uid, expense);
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deleteExpense(String expenseId) async {
    final uid = _getUserId();
    if (uid == null) {
      state = state.copyWith(errorMessage: 'User not authenticated.');
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      final repository = ref.read(expenseRepositoryProvider);
      await repository.deleteExpense(uid, expenseId);
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}

final expenseActionNotifierProvider =
    NotifierProvider<ExpenseActionNotifier, ExpenseActionState>(ExpenseActionNotifier.new);
