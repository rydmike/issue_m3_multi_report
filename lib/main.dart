import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    debugPrint('#build MaterialApp');
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(elevation: 0),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(elevation: 1),
        ),
      ),
      home: Builder(
        builder: (BuildContext context) {
          debugPrint("#build Scaffold");
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
          );
        },
      ),
    );
  }
}
