import 'package:cloud_firestore/cloud_firestore.dart';

/// Expense data model representing a single financial transaction.
class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor to parse Firestore document into [Expense].
  factory Expense.fromFirestore(Map<String, dynamic> data, String documentId) {
    DateTime parseDate(dynamic field) {
      if (field is Timestamp) {
        return field.toDate();
      } else if (field is String) {
        return DateTime.tryParse(field) ?? DateTime.now();
      }
      return DateTime.now();
    }

    double parseAmount(dynamic field) {
      if (field is num) {
        return field.toDouble();
      } else if (field is String) {
        return double.tryParse(field) ?? 0.0;
      }
      return 0.0;
    }

    return Expense(
      id: documentId,
      title: data['title'] as String? ?? 'Untitled Expense',
      amount: parseAmount(data['amount']),
      category: data['category'] as String? ?? 'Other',
      date: parseDate(data['date']),
      note: data['note'] as String?,
      createdAt: parseDate(data['createdAt']),
      updatedAt: parseDate(data['updatedAt']),
    );
  }

  /// Converts [Expense] to Firestore map document format.
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'date': Timestamp.fromDate(date),
      'note': note,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Expense &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
