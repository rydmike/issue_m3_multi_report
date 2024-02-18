import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThemeData equality checks', () {
    test('Same ThemeData is equal', () {
      final ThemeData td1 = ThemeData();
      final ThemeData td2 = ThemeData();
      expect(td1, equals(td2));
    });
    test('Same ThemeData with AppBar elevation theme is equal', () {
      final ThemeData td1 = ThemeData(
        appBarTheme: AppBarTheme(elevation: 0),
      );
      final ThemeData td2 = ThemeData(
        appBarTheme: AppBarTheme(elevation: 0),
      );
      expect(td1, equals(td2));
    });
    test('Same ThemeData with TextButtonThemeData styleFrom theme is equal',
        () {
      final ThemeData td1 = ThemeData(
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(elevation: 1),
        ),
      );
      final ThemeData td2 = ThemeData(
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(elevation: 1),
        ),
      );
      expect(td1, equals(td2));
    });
  });
}
