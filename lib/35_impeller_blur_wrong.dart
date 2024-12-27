import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
                _AppTitle(),
                _AnimatedBackground(),
                _FrostedGlass(),
                _BottomSegment(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AppTitle extends StatelessWidget {
  const _AppTitle();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isLight = theme.brightness == Brightness.light;
    final Color fontColor = theme.colorScheme.onSurfaceVariant;
    final Color backgroundColor = isLight ? Colors.white : Colors.black;

    return ColoredBox(
      color: backgroundColor,
      child: Align(
        child: Column(
          children: <Widget>[
            const Spacer(),
            // A Welcome to TALO text, laid out in a column
            Text(
              'Welcome to',
              textAlign: TextAlign.center,
              style: theme.textTheme.displaySmall,
            ),
            const SizedBox(height: 20),
            Text(
              'DEMO',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: fontColor,
                fontSize: 45,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(flex: 5),
          ],
        ),
        // ),
      ),
    );
  }
}

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
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.4),
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
          padding: const EdgeInsets.only(bottom: 120),
          child: ClipRect(
            clipBehavior: Clip.hardEdge,
            // Custom clipper used because ClipRect does not show correct
            // behavior when clipping rectangles with clipBehavior
            // Clip.hardEdge or even antialias.
            // See issue: https://github.com/flutter/flutter/issues/58547
            clipper: TightClipper(MediaQuery.of(context).devicePixelRatio,
                tightFactor: 2.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LinearProgressIndicator(
                  color: Colors.red[800],
                  backgroundColor: Colors.transparent,
                  minHeight: 20,
                ),
                const SizedBox(height: 20),
                ClipRect(
                  clipBehavior: Clip.hardEdge,
                  clipper: TightClipper(MediaQuery.of(context).devicePixelRatio,
                      tightFactor: 2.5),
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: CircularProgressIndicator(
                      color: Colors.red[800],
                      strokeWidth: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  color: Colors.red[800],
                  backgroundColor: Colors.transparent,
                  minHeight: 20,
                ),
              ],
            ),
          )),
    );
  }
}

class _BottomSegment extends StatelessWidget {
  const _BottomSegment();

  @override
  Widget build(BuildContext context) {
    final TextStyle bottomText =
        Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 22);

    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 100,
        child: Column(
          children: <Widget>[
            Text('Text on', textAlign: TextAlign.center, style: bottomText),
            const SizedBox(height: 10),
            Text('top of blur', textAlign: TextAlign.center, style: bottomText),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

/// A custom clipper used because ClipRect does not show correct behavior when
/// clipping rectangles with clipBehavior Clip.hardEdge or even antialias.
///
/// See issue: https://github.com/flutter/flutter/issues/58547
class TightClipper extends CustomClipper<Rect> {
  TightClipper(this.devicePixelRatio, {this.tightFactor = 1});

  @override
  Rect getClip(Size size) {
    final double padding = 1 / devicePixelRatio * tightFactor;
    return Rect.fromLTRB(
      padding,
      padding,
      size.width - padding,
      size.height - padding,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }

  final double devicePixelRatio;
  final double tightFactor;
}
