import 'package:flutter_test/flutter_test.dart';
import 'package:spendly/core/utils/date_formatter.dart';
import 'package:spendly/models/expense.dart';

void main() {
  group('Expense Business Logic & Filter Unit Tests', () {
    final now = DateTime(2026, 9, 29);
    final prevMonth = DateTime(2026, 8, 15);

    final sampleExpenses = [
      Expense(
        id: '1',
        title: 'Team Lunch',
        amount: 850.0,
        category: 'Food',
        date: now,
        note: 'Lunch with colleagues',
        createdAt: now,
        updatedAt: now,
      ),
      Expense(
        id: '2',
        title: 'Bus Ticket',
        amount: 150.0,
        category: 'Transport',
        date: now,
        createdAt: now,
        updatedAt: now,
      ),
      Expense(
        id: '3',
        title: 'Groceries',
        amount: 2500.0,
        category: 'Food',
        date: prevMonth,
        createdAt: prevMonth,
        updatedAt: prevMonth,
      ),
    ];

    test('Total calculation for sample expenses', () {
      final total = sampleExpenses.fold(0.0, (sum, exp) => sum + exp.amount);
      expect(total, 3500.0);
    });

    test('Monthly filtering filters expenses for September 2026', () {
      final currentMonthExpenses = sampleExpenses
          .where((exp) => DateFormatter.isSameMonth(exp.date, now))
          .toList();

      expect(currentMonthExpenses.length, 2);
      expect(currentMonthExpenses.map((e) => e.id), containsAll(['1', '2']));
    });

    test('Category filtering filters Food expenses correctly', () {
      final foodExpenses = sampleExpenses
          .where((exp) => exp.category.toLowerCase() == 'food')
          .toList();

      expect(foodExpenses.length, 2);
      expect(foodExpenses.map((e) => e.id), containsAll(['1', '3']));
    });

    test('Search filtering finds items by title or note', () {
      final searchResults = sampleExpenses.where((exp) {
        final q = 'colleagues';
        return exp.title.toLowerCase().contains(q) ||
            (exp.note ?? '').toLowerCase().contains(q);
      }).toList();

      expect(searchResults.length, 1);
      expect(searchResults.first.title, 'Team Lunch');
    });

    test('Category spending totals breakdown calculation', () {
      final Map<String, double> categoryTotals = {};
      for (final exp in sampleExpenses) {
        categoryTotals[exp.category] =
            (categoryTotals[exp.category] ?? 0.0) + exp.amount;
      }

      expect(categoryTotals['Food'], 3350.0);
      expect(categoryTotals['Transport'], 150.0);
    });
  });
}
