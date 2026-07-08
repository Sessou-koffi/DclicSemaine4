// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:activite1/main.dart';
import 'package:activite1/services/database_factory.dart';

void main() {
  testWidgets('L application principale se charge', (WidgetTester tester) async {
    WidgetsFlutterBinding.ensureInitialized();
    configureDatabaseFactory();

    await tester.pumpWidget(const MonApplication());

    expect(find.text('Gestion des Rédacteurs'), findsOneWidget);
    expect(find.text('Ajouter un rédacteur'), findsOneWidget);
  });
}
