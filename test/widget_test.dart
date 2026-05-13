// This is a basic Flutter widget test.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soal4_gabungan/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
