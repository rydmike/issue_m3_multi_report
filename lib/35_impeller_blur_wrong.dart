import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Impeller Blur Issue',
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
            appBar: AppBar(
              title: const Text('Impeller Blur Issue'),
            ),
            body: const Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.hardEdge,
              // overflow: Overflow.clip,
              children: <Widget>[
                _FrostedGlass(),
                _AnimatedBackground(),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Put a "frosted glass" effect over half of the sun and the upside down house
// to make them look like they are reflected in water
class _FrostedGlass extends StatelessWidget {
  const _FrostedGlass();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6.5, sigmaY: 6.5),
          child: Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedBackground extends StatelessWidget {
  const _AnimatedBackground();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
          padding: const EdgeInsets.only(bottom: 185.6),
          child: CircularProgressIndicator(
            color: Colors.red[800],
          )),
    );
  }
}
