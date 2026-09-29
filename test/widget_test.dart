import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendly/main.dart';

void main() {
  testWidgets('SpendlyApp smoke test renders AuthGate / Login screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SpendlyApp(),
      ),
    );

    // Verify application title or login prompt appears
    expect(find.text('Spendly'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
