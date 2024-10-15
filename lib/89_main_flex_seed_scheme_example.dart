// MIT License
//
// Copyright (c) 2023 Mike Rydstrom
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';

import 'color_scheme_view.dart';

// A "brand" color for the M3 ColorScheme, you can have different
// colors for each palette, in this demo we use the same color for all.
const Color brandColor = Color(0xFF1F36BD);

// You can override tones of any built-in FlexTones tone mapping.
FlexTones appTones(Brightness brightness) {
  final bool isLight = brightness == Brightness.light;
  return FlexTones.vivid(brightness)
      // If you want to override a tone mapping of any built-in
      // FlexTones, you can do it with a copy with. Here we make
      // contrast color for primaryContainer use tone 100 in light mode,
      // which always white in HCT (Hue Chroma Tone) color space and
      // tone 0 in dark mode, which is always black.
      .copyWith(
        onPrimaryContainerTone: isLight ? 100 : 0,
      )
      // Demo: This modifier will make all surface colors monochrome
      // shaded without any color tint, but only when isLight is true.
      .monochromeSurfaces(isLight)
      // There are many more tone modifiers available,
      // see the FlexTones class. Set flag in them below to true to
      // try them. Basically the tone modifiers below are
      // only convenience copyWith, with many props used, like the one
      // demoed above.
      .onMainsUseBW(false)
      .onSurfacesUseBW(false)
      .expressiveOnContainer(false)
      .higherContrastFixed(false)
      .surfacesUseBW(false);
}

// Example App theme
ThemeData appTheme(Brightness brightness, bool useMaterial3) {
  final bool isLight = brightness == Brightness.light;
  final ColorScheme colorScheme = SeedColorScheme.fromSeeds(
    brightness: brightness,
    // You can if you want use the brand color as key for
    // all main palettes for single hue ColorScheme with
    // various shades and tones of only the brand color used.
    primaryKey: brandColor,
    secondaryKey: brandColor,
    tertiaryKey: brandColor,
    // Pin the brand color to the primary color in light and to
    // primaryContainer in dark mode, this usually works well if
    // the brand color has brightness that is dark and prefers a
    // light on color. If it is the reverse then pin them the
    // other way around.
    primary: isLight ? brandColor : null,
    primaryContainer: isLight ? null : brandColor,
  );

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: useMaterial3,
    visualDensity: VisualDensity.standard,
    splashFactory: NoSplash.splashFactory,
  );
}

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  bool useMaterial3 = true;
  ThemeMode themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: appTheme(Brightness.light, useMaterial3),
      darkTheme: appTheme(Brightness.dark, useMaterial3),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SeedColorScheme.fromSeeds Demo'),
          actions: [
            IconButton(
              icon: useMaterial3
                  ? const Icon(Icons.filter_3)
                  : const Icon(Icons.filter_2),
              onPressed: () {
                setState(() {
                  useMaterial3 = !useMaterial3;
                });
              },
              tooltip: "Switch to Material ${useMaterial3 ? 2 : 3}",
            ),
            IconButton(
              icon: themeMode == ThemeMode.dark
                  ? const Icon(Icons.wb_sunny_outlined)
                  : const Icon(Icons.wb_sunny),
              onPressed: () {
                setState(() {
                  if (themeMode == ThemeMode.light) {
                    themeMode = ThemeMode.dark;
                  } else {
                    themeMode = ThemeMode.light;
                  }
                });
              },
              tooltip: "Toggle brightness",
            ),
          ],
        ),
        body: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 8),
        Text(
          'Demo of SeedColorScheme.fromSeeds',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        const Text(
          'Toggle light/dark and M2/M3 on AppBar.',
        ),
        const SizedBox(height: 16),
        ColorSchemeView(
          showColorValue: true,
          tones: appTones(Theme.of(context).brightness),
        ),
      ],
    );
  }
}
