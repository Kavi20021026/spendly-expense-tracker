import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendly/screens/onboarding/onboarding_screen.dart';

void main() {
  testWidgets('OnboardingScreen can swipe through all 3 slides and tap Get Started', (tester) async {
    bool getStartedCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingScreen(
          onGetStarted: () {
            getStartedCalled = true;
          },
        ),
      ),
    );

    expect(find.text('Track Every Rupee\nwith Precision'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    // Tap Next to go to Slide 2
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Understand Where\nYour Money Flows'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    // Tap Next to go to Slide 3
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Private, Secure &\nAlways In Sync'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    // Tap Get Started on Slide 3
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(getStartedCalled, isTrue);
  });
}
