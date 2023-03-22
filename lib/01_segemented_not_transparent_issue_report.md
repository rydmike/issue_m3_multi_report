## SegmentedButton segments background cannot be made transparent

The Material 3 specification depicts `SegmentedButton` unselected button segments as having transparent color, used to show background color of surface it is placed upon. This is needed for it to work well on elevation tinted surfaces in Material 3 design.

Its default style also returns null as background color, shown below and in link:

https://github.com/flutter/flutter/blob/2cdf078f0fd922f074c563470d439b1e0a054e85/packages/flutter/lib/src/material/segmented_button.dart#L737

```dart
class _SegmentedButtonDefaultsM3 extends SegmentedButtonThemeData {
  _SegmentedButtonDefaultsM3(this.context);
  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  @override ButtonStyle? get style {
    return ButtonStyle(
      textStyle: MaterialStatePropertyAll<TextStyle?>(Theme.of(context).textTheme.labelLarge),
      backgroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return _colors.secondaryContainer;
        }
        return null;  // <<-- Should become transparent
      }),
```
This implies that an attempt to make it transparent has been made , however it does not work.

## Expected results

Expect unselected `SegmentedButton` to have transparent background as depicted in M3 spec. Only selected container is also listed as having color in the spec, unselected has no color. Which the "null" choice above correctly implements.

https://m3.material.io/components/segmented-buttons/specs

![Screenshot 2023-03-23 at 0 10 51](https://user-images.githubusercontent.com/39990307/227049907-8468a5b8-0984-47e1-843e-04e85b98f75e.png)

## Actual results

Despite above intention to keep the unselected button transparent, **it is not**.

When used on elevated surfaces with tint, or on otherwise different surface color, it does not match background unless the same color is given to its background. This can be challenging to apply manually, sometimes even impossible if elevation is not known when it is used on elevation tinted surfaces. Coloring it manually with matching color requires knowing the `elevation` and un-elevated `color`, of the surface it is placed on. It is not always possible to know this if the entire construct is not owned.

The issue applies both if we try to style the unselected buttons on widget level or via theme. The below sample show widget placed on a tint elevated Card, getting a background with different color than un-elevated surface. In the example it is attempted to both via theme, using actual `Colors.transparent` on unselected segment background, and also via widget styling, on the 2nd control to make the background of unselected segments transparent.

**ISSUE:** The unselected segments remain opaque and we cannot match it to background color it is placed on, unless we know elevation and original color of the background.



| Light | Dark |
|-------|------|
| ![Screenshot 2023-03-22 at 23 16 31](https://user-images.githubusercontent.com/39990307/227049996-f1c06f65-d020-493e-8c50-4fe0f7612ea3.png)      |  ![Screenshot 2023-03-22 at 23 16 45](https://user-images.githubusercontent.com/39990307/227050093-2a1b153a-8198-4cbc-84d8-430946e6ae05.png)|


## Proposal

The issue and styling limitation is caused by using opaque `Material` as background for the `SegmentedButton` parent, seen in code here:

https://github.com/flutter/flutter/blob/2cdf078f0fd922f074c563470d439b1e0a054e85/packages/flutter/lib/src/material/segmented_button.dart#L356

By adding `type: MaterialType.transparency` to the used `Material` the issue is solved.

```dart
    return Material(
      type: MaterialType.transparency,
      shape: enabledBorder.copyWith(side: BorderSide.none),
      elevation: resolve<double?>((ButtonStyle? style) => style?.elevation)!,
      shadowColor: resolve<Color?>((ButtonStyle? style) => style?.shadowColor),
      surfaceTintColor: resolve<Color?>((ButtonStyle? style) => style?.surfaceTintColor),
      child: 
```

With this fix in place we get:


| Light | Dark |
|-------|------|
| ![Screenshot 2023-03-22 at 23 17 25](https://user-images.githubusercontent.com/39990307/227050358-722c340a-fb8f-4188-9d10-78bc4b6be30d.png)     |  ![Screenshot 2023-03-22 at 23 17 39](https://user-images.githubusercontent.com/39990307/227050373-1175052f-e7d8-4ac6-aa92-6e7db031860d.png)|


**Action:** Submitting PR.


## Issue sample code

<details>
<summary>Code sample</summary>


```dart
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
import 'package:flutter/material.dart';

// A seed color for the M3 ColorScheme.
const Color seedColor = Color(0xFF6750A4);

// Make M3 ColorSchemes from a seed color.
final ColorScheme schemeLight = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: seedColor,
);
final ColorScheme schemeDark = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: seedColor,
);

// Example theme
ThemeData demoTheme(Brightness mode, bool useMaterial3) {
  ColorScheme scheme = mode == Brightness.light ? schemeLight : schemeDark;
  return ThemeData(
    colorScheme: mode == Brightness.light ? schemeLight : schemeDark,
    useMaterial3: useMaterial3,
    visualDensity: VisualDensity.standard,
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        // minimumSize: MaterialStatePropertyAll<Size?>(Size.fromHeight(80.0)),
        backgroundColor:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return scheme.secondaryContainer;
          }
          // Default theme returns null here and should give us
          // transparent background already. Even if we return
          // transparent color, we do not get it since widget is
          // drawn using opaque Material
          // --> Default does this return null;
          return Colors.transparent;
        }),
      ),
    ),
  );
}

void main() {
  runApp(const IssueDemoApp());
}

class IssueDemoApp extends StatefulWidget {
  const IssueDemoApp({super.key});

  @override
  State<IssueDemoApp> createState() => _IssueDemoAppState();
}

class _IssueDemoAppState extends State<IssueDemoApp> {
  bool useMaterial3 = true;
  ThemeMode themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: demoTheme(Brightness.light, useMaterial3),
      darkTheme: demoTheme(Brightness.dark, useMaterial3),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SegmentedButton M3 Spec Issue'),
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
          'SegmentedButton uses opaque Material',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        const Text(
          'ISSUE: SegmentedButton cannot be made transparent.'
          '\n\n'
          'EXPECT: Transparency to work on SegmentedButton.',
        ),
        const SizedBox(height: 16),
        const Card(
            elevation: 3,
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: SegmentedButtonShowcase(),
            )),
        const SizedBox(height: 16),
        const ShowColorSchemeColors(),
      ],
    );
  }
}

class SegmentedButtonShowcase extends StatefulWidget {
  const SegmentedButtonShowcase({this.showOutlinedButton, super.key});
  final bool? showOutlinedButton;

  @override
  State<SegmentedButtonShowcase> createState() =>
      _SegmentedButtonShowcaseState();
}

enum Calendar { day, week, month, year }

class _SegmentedButtonShowcaseState extends State<SegmentedButtonShowcase> {
  List<bool> selected = <bool>[true, false, false];
  Calendar _selected = Calendar.day;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        SegmentedButton<Calendar>(
          showSelectedIcon: false,
          segments: const <ButtonSegment<Calendar>>[
            ButtonSegment<Calendar>(
              value: Calendar.day,
              label: Text('Day'),
            ),
            ButtonSegment<Calendar>(
              value: Calendar.week,
              label: Text('Week'),
            ),
            ButtonSegment<Calendar>(
              value: Calendar.month,
              label: Text('Month'),
            ),
            ButtonSegment<Calendar>(
              value: Calendar.year,
              label: Text('Year'),
            ),
          ],
          selected: <Calendar>{_selected},
          onSelectionChanged: (Set<Calendar> selected) {
            setState(() {
              _selected = selected.first;
            });
          },
        ),
        SegmentedButton<Calendar>(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.resolveWith((Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return null;
              }
              if (states.contains(MaterialState.selected)) {
                return theme.colorScheme.secondaryContainer;
              }
              // Default theme returns null here and should give us
              // transparent background already, even if we return
              // transparent color, we do not get it since widget is
              // drawn using opaque Material
              // --> Default does this return null;
              return Colors.transparent;
            }),
          ),
          segments: const <ButtonSegment<Calendar>>[
            ButtonSegment<Calendar>(
              value: Calendar.day,
              label: Text('Day'),
              icon: Icon(Icons.calendar_view_day),
            ),
            ButtonSegment<Calendar>(
              value: Calendar.week,
              icon: Icon(Icons.calendar_view_week),
              label: Text('Week'),
            ),
            ButtonSegment<Calendar>(
              value: Calendar.month,
              icon: Icon(Icons.calendar_view_month),
              label: Text('Month'),
            ),
            ButtonSegment<Calendar>(
              value: Calendar.year,
              icon: Icon(Icons.calendar_today),
              label: Text('Year'),
            ),
          ],
          selected: <Calendar>{_selected},
          onSelectionChanged: (Set<Calendar> selected) {
            setState(() {
              _selected = selected.first;
            });
          },
        ),
        SegmentedButton<Calendar>(
          segments: const <ButtonSegment<Calendar>>[
            ButtonSegment<Calendar>(
              value: Calendar.day,
              label: Text('Day'),
              icon: Icon(Icons.calendar_view_day),
              enabled: false,
            ),
            ButtonSegment<Calendar>(
              value: Calendar.week,
              icon: Icon(Icons.calendar_view_week),
              label: Text('Week'),
            ),
            ButtonSegment<Calendar>(
              value: Calendar.month,
              icon: Icon(Icons.calendar_view_month),
              label: Text('Month'),
              enabled: false,
            ),
            ButtonSegment<Calendar>(
              value: Calendar.year,
              icon: Icon(Icons.calendar_today),
              label: Text('Year'),
            ),
          ],
          selected: <Calendar>{_selected},
          onSelectionChanged: (Set<Calendar> selected) {
            setState(() {
              _selected = selected.first;
            });
          },
        ),
      ],
    );
  }
}

/// Draw a number of boxes showing the colors of key theme color properties
/// in the ColorScheme of the inherited ThemeData and its color properties.
class ShowColorSchemeColors extends StatelessWidget {
  const ShowColorSchemeColors({super.key, this.onBackgroundColor});

  /// The color of the background the color widget are being drawn on.
  ///
  /// Some of the theme colors may have semi transparent fill color. To compute
  /// a legible text color for the sum when it shown on a background color, we
  /// need to alpha merge it with background and we need the exact background
  /// color it is drawn on for that. If not passed in from parent, it is
  /// assumed to be drawn on card color, which usually is close enough.
  final Color? onBackgroundColor;

  // Return true if the color is light, meaning it needs dark text for contrast.
  static bool _isLight(final Color color) =>
      ThemeData.estimateBrightnessForColor(color) == Brightness.light;

  // On color used when a theme color property does not have a theme onColor.
  static Color _onColor(final Color color, final Color bg) =>
      _isLight(Color.alphaBlend(color, bg)) ? Colors.black : Colors.white;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool useMaterial3 = theme.useMaterial3;
    const double spacing = 4;

    // Grab the card border from the theme card shape
    ShapeBorder? border = theme.cardTheme.shape;
    // If we had one, copy in a border side to it.
    if (border is RoundedRectangleBorder) {
      border = border.copyWith(
        side: BorderSide(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      );
      // If
    } else {
      // If border was null, make one matching Card default, but with border
      // side, if it was not null, we leave it as it was.
      border ??= RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(useMaterial3 ? 12 : 4)),
        side: BorderSide(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      );
    }

    // Get effective background color.
    final Color background =
        onBackgroundColor ?? theme.cardTheme.color ?? theme.cardColor;

    // Wrap this widget branch in a custom theme where card has a border outline
    // if it did not have one, but retains its ambient themed border radius.
    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: CardTheme.of(context).copyWith(
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          shape: border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'ColorScheme Colors',
              style: theme.textTheme.titleMedium,
            ),
          ),
          Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: spacing,
            runSpacing: spacing,
            children: <Widget>[
              ColorCard(
                label: 'Primary',
                color: colorScheme.primary,
                textColor: colorScheme.onPrimary,
              ),
              ColorCard(
                label: 'on\nPrimary',
                color: colorScheme.onPrimary,
                textColor: colorScheme.primary,
              ),
              ColorCard(
                label: 'Primary\nContainer',
                color: colorScheme.primaryContainer,
                textColor: colorScheme.onPrimaryContainer,
              ),
              ColorCard(
                label: 'onPrimary\nContainer',
                color: colorScheme.onPrimaryContainer,
                textColor: colorScheme.primaryContainer,
              ),
              ColorCard(
                label: 'Secondary',
                color: colorScheme.secondary,
                textColor: colorScheme.onSecondary,
              ),
              ColorCard(
                label: 'on\nSecondary',
                color: colorScheme.onSecondary,
                textColor: colorScheme.secondary,
              ),
              ColorCard(
                label: 'Secondary\nContainer',
                color: colorScheme.secondaryContainer,
                textColor: colorScheme.onSecondaryContainer,
              ),
              ColorCard(
                label: 'on\nSecondary\nContainer',
                color: colorScheme.onSecondaryContainer,
                textColor: colorScheme.secondaryContainer,
              ),
              ColorCard(
                label: 'Tertiary',
                color: colorScheme.tertiary,
                textColor: colorScheme.onTertiary,
              ),
              ColorCard(
                label: 'on\nTertiary',
                color: colorScheme.onTertiary,
                textColor: colorScheme.tertiary,
              ),
              ColorCard(
                label: 'Tertiary\nContainer',
                color: colorScheme.tertiaryContainer,
                textColor: colorScheme.onTertiaryContainer,
              ),
              ColorCard(
                label: 'on\nTertiary\nContainer',
                color: colorScheme.onTertiaryContainer,
                textColor: colorScheme.tertiaryContainer,
              ),
              ColorCard(
                label: 'Error',
                color: colorScheme.error,
                textColor: colorScheme.onError,
              ),
              ColorCard(
                label: 'on\nError',
                color: colorScheme.onError,
                textColor: colorScheme.error,
              ),
              ColorCard(
                label: 'Error\nContainer',
                color: colorScheme.errorContainer,
                textColor: colorScheme.onErrorContainer,
              ),
              ColorCard(
                label: 'onError\nContainer',
                color: colorScheme.onErrorContainer,
                textColor: colorScheme.errorContainer,
              ),
              ColorCard(
                label: 'Background',
                color: colorScheme.background,
                textColor: colorScheme.onBackground,
              ),
              ColorCard(
                label: 'on\nBackground',
                color: colorScheme.onBackground,
                textColor: colorScheme.background,
              ),
              ColorCard(
                label: 'Surface',
                color: colorScheme.surface,
                textColor: colorScheme.onSurface,
              ),
              ColorCard(
                label: 'on\nSurface',
                color: colorScheme.onSurface,
                textColor: colorScheme.surface,
              ),
              ColorCard(
                label: 'Surface\nVariant',
                color: colorScheme.surfaceVariant,
                textColor: colorScheme.onSurfaceVariant,
              ),
              ColorCard(
                label: 'onSurface\nVariant',
                color: colorScheme.onSurfaceVariant,
                textColor: colorScheme.surfaceVariant,
              ),
              ColorCard(
                label: 'Outline',
                color: colorScheme.outline,
                textColor: colorScheme.background,
              ),
              ColorCard(
                label: 'Outline\nVariant',
                color: colorScheme.outlineVariant,
                textColor: colorScheme.onBackground,
              ),
              ColorCard(
                label: 'Shadow',
                color: colorScheme.shadow,
                textColor: _onColor(colorScheme.shadow, background),
              ),
              ColorCard(
                label: 'Scrim',
                color: colorScheme.scrim,
                textColor: _onColor(colorScheme.scrim, background),
              ),
              ColorCard(
                label: 'Inverse\nSurface',
                color: colorScheme.inverseSurface,
                textColor: colorScheme.onInverseSurface,
              ),
              ColorCard(
                label: 'onInverse\nSurface',
                color: colorScheme.onInverseSurface,
                textColor: colorScheme.inverseSurface,
              ),
              ColorCard(
                label: 'Inverse\nPrimary',
                color: colorScheme.inversePrimary,
                textColor: colorScheme.inverseSurface,
              ),
              ColorCard(
                label: 'Surface\nTint',
                color: colorScheme.surfaceTint,
                textColor: colorScheme.onPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A [SizedBox] with a [Card] and string text in it. Used in this demo to
/// display theme color boxes.
///
/// Can specify label text color and background color.
class ColorCard extends StatelessWidget {
  const ColorCard({
    super.key,
    required this.label,
    required this.color,
    required this.textColor,
    this.size,
  });

  final String label;
  final Color color;
  final Color textColor;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    const double fontSize = 11;
    const Size effectiveSize = Size(86, 58);

    return SizedBox(
      width: effectiveSize.width,
      height: effectiveSize.height,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        color: color,
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: textColor, fontSize: fontSize),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

```


</details>

## Used Flutter Version

Channel master, 3.7.0-15.0.pre.16

<details>
  <summary>Flutter doctor</summary>

```

flutter doctor -v
[✓] Flutter (Channel master, 3.9.0-15.0.pre.7, on macOS 13.2.1 22D68 darwin-arm64, locale en-US)
    • Flutter version 3.9.0-15.0.pre.7 on channel master at /Users/rydmike/fvm/versions/master
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision b42e8db6cf (4 hours ago), 2023-03-22 13:12:55 -0400
    • Engine revision 5775c6b05f
    • Dart version 3.0.0 (build 3.0.0-348.0.dev)
    • DevTools version 2.22.2
    • If those were intentional, you can disregard the above warnings; however it is recommended to use "git" directly to perform
      update checks and upgrades.

[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.0)
    • Android SDK at /Users/rydmike/Library/Android/sdk
    • Platform android-33, build-tools 33.0.0
    • Java binary at: /Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build 11.0.15+0-b2043.56-8887301)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 14.2)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Build 14C18
    • CocoaPods version 1.11.3

[✓] Chrome - develop for the web
    • Chrome at /Applications/Google Chrome.app/Contents/MacOS/Google Chrome

[✓] Android Studio (version 2022.1)
    • Android Studio at /Applications/Android Studio.app/Contents
    • Flutter plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/6351-dart
    • Java version OpenJDK Runtime Environment (build 11.0.15+0-b2043.56-8887301)

[✓] IntelliJ IDEA Community Edition (version 2022.3.3)
    • IntelliJ at /Applications/IntelliJ IDEA CE.app
    • Flutter plugin version 72.1.4
    • Dart plugin version 223.8888

[✓] VS Code (version 1.76.2)
    • VS Code at /Applications/Visual Studio Code.app/Contents
    • Flutter extension version 3.60.0

[✓] Connected device (2 available)
    • macOS (desktop) • macos  • darwin-arm64   • macOS 13.2.1 22D68 darwin-arm64
    • Chrome (web)    • chrome • web-javascript • Google Chrome 111.0.5563.110

[✓] Network resources
    • All expected network resources are available.


```

</details>
