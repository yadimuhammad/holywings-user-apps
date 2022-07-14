import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/screens/home/onboarding.dart';
import 'package:holywings_user_apps/screens/home/onboarding_card.dart';

main() {
  group('Getting started', () {
    testWidgets('layouts', (WidgetTester tester) async {
      await tester.pumpWidget(GetMaterialApp(home: Onboarding()));
      await tester.pump(Duration(milliseconds: 200));

      Finder _btnGetStarted = find.text('Get Started');
      expect(_btnGetStarted, findsOneWidget);
    });

    testWidgets('action', (WidgetTester tester) async {
      await tester.pumpWidget(GetMaterialApp(home: Onboarding()));
      await tester.pump(Duration(seconds: 3));

      Finder _btnGetStarted = find.text('Get Started');

      // Scroll ke bawah
      await _scrollToBot(tester: tester, toFinder: _btnGetStarted);
      await tester.tap(_btnGetStarted);
      await tester.pumpAndSettle();
      await _delay(tester: tester, seconds: 3);

      expect(find.byType(OnboardingCard), findsOneWidget);
    });
  });

  group('Onboarding', () {
    testWidgets('flow to login', (WidgetTester tester) async {
      await tester.pumpWidget(GetMaterialApp(home: OnboardingCard()));
      await _delay(tester: tester, seconds: 3);

      Finder _btnNext = find.text('Next');
      Finder _btnContinue = find.text('Continue');
      
      expect(find.text('Online Reservation'), findsOneWidget);

      await _scrollToBot(tester: tester, toFinder: _btnNext);
      await tester.tap(_btnNext);
      await tester.pumpAndSettle();
      await _delay(tester: tester, seconds: 3);


      await _scrollToBot(tester: tester, toFinder: _btnNext);
      await tester.tap(_btnNext);
      await tester.pumpAndSettle();
      await _delay(tester: tester, seconds: 3);

      await tester.tap(_btnNext);
      await tester.pumpAndSettle();
      await _delay(tester: tester, seconds: 3);

      expect(_btnNext, findsNothing);
      expect(_btnContinue, findsOneWidget);
    });
  });
}

_scrollToBot({required WidgetTester tester, required Finder toFinder}) async {
  await tester.dragUntilVisible(toFinder, find.byType(SingleChildScrollView), const Offset(0.0, 100));
}

_delay({required WidgetTester tester, required int seconds}) async {
  await tester.pump(Duration(seconds: seconds));
}
