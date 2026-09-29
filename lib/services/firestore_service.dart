import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/errors/app_exception.dart';
import '../models/expense.dart';

/// Firestore Service handling direct Firestore database calls for user expenses.
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Reference to user's expenses collection: `users/{userId}/expenses`
  CollectionReference<Map<String, dynamic>> _userExpensesRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('expenses');
  }

  /// Streams all expenses for a specific user, sorted by date descending.
  Stream<List<Expense>> streamExpenses(String userId) {
    return _userExpensesRef(userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Expense.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  /// Adds a new expense to `users/{userId}/expenses`
  Future<String> addExpense(String userId, Expense expense) async {
    try {
      final docRef = await _userExpensesRef(userId).add(expense.toFirestore());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw AppException.fromFirestore(e.code, e.message ?? 'Failed to add expense.');
    } catch (e) {
      throw AppException('An unexpected error occurred while saving the expense: $e');
    }
  }

  /// Updates an existing expense in `users/{userId}/expenses/{expenseId}`
  Future<void> updateExpense(String userId, Expense expense) async {
    try {
      final updatedData = expense.toFirestore();
      updatedData['updatedAt'] = Timestamp.fromDate(DateTime.now());
      await _userExpensesRef(userId).doc(expense.id).update(updatedData);
    } on FirebaseException catch (e) {
      throw AppException.fromFirestore(e.code, e.message ?? 'Failed to update expense.');
    } catch (e) {
      throw AppException('An unexpected error occurred while updating the expense: $e');
    }
  }

  /// Deletes an expense from `users/{userId}/expenses/{expenseId}`
  Future<void> deleteExpense(String userId, String expenseId) async {
    try {
      await _userExpensesRef(userId).doc(expenseId).delete();
    } on FirebaseException catch (e) {
      throw AppException.fromFirestore(e.code, e.message ?? 'Failed to delete expense.');
    } catch (e) {
      throw AppException('An unexpected error occurred while deleting the expense: $e');
    }
  }
}
