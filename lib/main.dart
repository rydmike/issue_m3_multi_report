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
