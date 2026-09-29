import '../models/expense.dart';
import '../services/firestore_service.dart';

/// Repository interface for Expense CRUD operations.
abstract class ExpenseRepository {
  Stream<List<Expense>> getExpensesStream(String userId);
  Future<String> addExpense(String userId, Expense expense);
  Future<void> updateExpense(String userId, Expense expense);
  Future<void> deleteExpense(String userId, String expenseId);
}

/// Concrete implementation of [ExpenseRepository] delegating to [FirestoreService].
class ExpenseRepositoryImpl implements ExpenseRepository {
  final FirestoreService _firestoreService;

  ExpenseRepositoryImpl({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  @override
  Stream<List<Expense>> getExpensesStream(String userId) {
    return _firestoreService.streamExpenses(userId);
  }

  @override
  Future<String> addExpense(String userId, Expense expense) {
    return _firestoreService.addExpense(userId, expense);
  }

  @override
  Future<void> updateExpense(String userId, Expense expense) {
    return _firestoreService.updateExpense(userId, expense);
  }

  @override
  Future<void> deleteExpense(String userId, String expenseId) {
    return _firestoreService.deleteExpense(userId, expenseId);
  }
}
