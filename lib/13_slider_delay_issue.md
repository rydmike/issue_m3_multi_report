## Yet another analysis of the issue

Since I am well aware of this issue and have seen it a lot, here is my analysis of its causes. As far as I can see, there are potentially two issues at play in this report.

1) Stutter when using a continuous Slider based on `int` value
2) Delay on discrete Slider with both `int` and `double` based values.

Let's tackle them both.

## 1) Stutter when using continuous Slider based on `int` value

This case is pretty logical. If your source value is based on an `int` value, and the Slider is continuous, you get a double value back and Slider has moved/operated a bit, this is reflected in the returned value. When you convert this value to an `int` and assign it back to the Slider's value, it will "stutter" when it reverts back to the integer value. This will happen until returned new double value reaches the next integer value, and it snaps to new integer value.

Using integer as source value for a Slider is fine, but it is only "visually" compatible with using a discrete Slider where its discrete steps are also integer values.

The conversion between `int` and `double` is negligible and not behind the stutter or any visually observed delay.

We can demonstrate this. Sliders below share values, so that we can observe their behavior differences.

Moving the continuous INT Slider, it sets `int` value and uses an `int` value back from returned new value via `double` conversion. Moving it slowly, we can se it tries to move, but it is forced back to int the value, causing the stutter.

We can even see the same effect on the Continuous INT Slider when we operate the Continuous DOUBLE Slider, since they share double control value.

https://user-images.githubusercontent.com/39990307/233476108-2a8172ee-9f66-4f43-a02d-6520ab21029e.mov

**Conclusion**: To avoid the stutter, only use `int` input control values with discrete Sliders, that can match its selectable and returned discrete Slider double values. Some documentation to explain this might be helpful.

## 2) Delay on discrete Slider with both `int` and `double` based values

Regarding the delay when operating **Sliders**, we can see and observe that the thumb **LAGS** considerably behind when operating **discrete** Sliders, this does not happen with **continuous** Sliders. The delay does not depend at all on if source value is `double` or `int` based (other than the unrelated and logical int stutter above for continuous Slider).

We can see this below, where when operating the discrete Sliders, the Slider thumb lags a lot behind the mouse (or finger touch), when it is moved rapidly:

https://user-images.githubusercontent.com/39990307/233477263-2ee3d7a3-271f-4ee9-9ab3-8ae96d45614c.mov

Concerning the cause of this delay, @VadimMalykhin has the right idea, the lag is caused by a hard coded animation delay. The referenced value is, however, incorrect:

https://github.com/flutter/flutter/blob/55825f166e4e4d5e397633a1e61dae42992effd5/packages/flutter/lib/src/material/slider.dart#L532

Alternatively, the Slider has since he made his observation (it was a while ago) been changed. Changing the suggested constant to **zero**, does not remove the observed delay.

The actual delay is deeper, it is in the `_RenderSlider` that extends `RenderBox` here:

https://github.com/flutter/flutter/blob/55825f166e4e4d5e397633a1e61dae42992effd5/packages/flutter/lib/src/material/slider.dart#L1076

If we set this constant duration to zero, we can get a much nicer discrete **Sliders** that tracks rapid mouse or finger operations much better. As shown below where the above constant was set to **zero**:

https://user-images.githubusercontent.com/39990307/233479112-0cc820ef-44af-43b4-8b8c-75e670bf87cc.mov

I don't know what the rationale behind this delay is. **My guess is**, if you have a discrete Slider with only a few discrete values, the animation makes sense. It allows the thumb to nicely slide animate to the next value. However, if your discrete Slider has a large number of discrete values, this animation no longer makes any sense. Just jumping to the next value would then be better, since it is getting closer to the continuous use case.

I agree that this constant should be exposed so users can modify it to fit their use case.

## Example code

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
// FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// This issue reported here: https://github.com/flutter/flutter/issues/51715

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
ThemeData theme(ThemeMode mode, ThemeSettings settings) {
  final ColorScheme colorScheme =
  mode == ThemeMode.light ? schemeLight : schemeDark;

  return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: settings.useMaterial3,
      visualDensity: VisualDensity.standard,
      sliderTheme: const SliderThemeData(
        showValueIndicator: ShowValueIndicator.always,
      ));
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
  ThemeMode themeMode = ThemeMode.light;
  bool longLabel = false;
  TextDirection textDirection = TextDirection.ltr;
  ThemeSettings settings = const ThemeSettings(
    useMaterial3: true,
    useCustomTheme: false,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: theme(ThemeMode.light, settings),
      darkTheme: theme(ThemeMode.dark, settings),
      home: Directionality(
        textDirection: textDirection,
        child: Scaffold(
          appBar: AppBar(
            title: settings.useMaterial3
                ? const Text("INT Slider Issue (Material 3)")
                : const Text("INT Slider Issue (Material 2)"),
            actions: [
              IconButton(
                icon: settings.useMaterial3
                    ? const Icon(Icons.filter_3)
                    : const Icon(Icons.filter_2),
                onPressed: () {
                  setState(() {
                    settings =
                        settings.copyWith(useMaterial3: !settings.useMaterial3);
                  });
                },
                tooltip: "Switch to Material ${settings.useMaterial3 ? 2 : 3}",
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
          body: HomePage(
            settings: settings,
            onSettings: (ThemeSettings value) {
              setState(() {
                settings = value;
              });
            },
            longLabel: longLabel,
            onLongLabel: (bool value) {
              setState(() {
                longLabel = value;
              });
            },
            textDirection: textDirection,
            onTextDirection: (TextDirection value) {
              setState(() {
                textDirection = value;
              });
            },
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.settings,
    required this.onSettings,
    required this.longLabel,
    required this.onLongLabel,
    required this.textDirection,
    required this.onTextDirection,
  });
  final ThemeSettings settings;
  final ValueChanged<ThemeSettings> onSettings;
  final bool longLabel;
  final ValueChanged<bool> onLongLabel;
  final TextDirection textDirection;
  final ValueChanged<TextDirection> onTextDirection;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: const [
        SizedBox(height: 8),
        Text('Example of stutter and delay when using INT and discrete versus'
            'continuous Slider with comparison to using DOUBLE and '
            'discrete versus continuous Slider.'),
        SizedBox(height: 16),
        SliderShowCase(),
        SizedBox(height: 16),
        ShowColorSchemeColors(),
      ],
    );
  }
}

class SliderShowCase extends StatefulWidget {
  const SliderShowCase({super.key});

  @override
  State<SliderShowCase> createState() => _SliderShowCaseState();
}

class _SliderShowCaseState extends State<SliderShowCase> {
  int intHeight = 170;
  late double doubleHeight;

  @override
  void initState() {
    super.initState();
    doubleHeight = intHeight.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: const Text('Discrete INT slider'),
            subtitle: Slider(
              min: 150.0,
              max: 180.0,
              value: intHeight.toDouble(),
              label: doubleHeight.toStringAsFixed(3),
              divisions: 30,
              onChanged: (double newValue) {
                setState(() {
                  doubleHeight = newValue;
                  intHeight = newValue.toInt();
                });
              },
            ),
            trailing: Text(doubleHeight.toStringAsFixed(3)),
          ),
          ListTile(
            title: const Text('Continuous INT slider'),
            subtitle: Slider(
              min: 150.0,
              max: 180.0,
              value: intHeight.toDouble(),
              label: doubleHeight.toStringAsFixed(3),
              onChanged: (double newValue) {
                setState(() {
                  doubleHeight = newValue;
                  intHeight = newValue.toInt();
                });
              },
            ),
            trailing: Text(doubleHeight.toStringAsFixed(3)),
          ),
          ListTile(
            title: const Text('Discrete DOUBLE slider'),
            subtitle: Slider(
              min: 150.0,
              max: 180.0,
              value: doubleHeight,
              label: doubleHeight.toStringAsFixed(3),
              divisions: 30,
              onChanged: (double newValue) {
                setState(() {
                  doubleHeight = newValue;
                  intHeight = newValue.toInt();
                });
              },
            ),
            trailing: Text(doubleHeight.toStringAsFixed(3)),
          ),
          ListTile(
            title: const Text('Continuous DOUBLE slider'),
            subtitle: Slider(
              min: 150.0,
              max: 180.0,
              value: doubleHeight,
              label: doubleHeight.toStringAsFixed(3),
              onChanged: (double newValue) {
                setState(() {
                  doubleHeight = newValue;
                  intHeight = newValue.toInt();
                });
              },
            ),
            trailing: Text(doubleHeight.toStringAsFixed(3)),
          ),
        ],
      ),
    );
  }
}

/// A Theme Settings class to bundle properties we want to modify on our
/// theme interactively.
@immutable
class ThemeSettings with Diagnosticable {
  final bool useMaterial3;
  final bool useCustomTheme;

  const ThemeSettings({
    required this.useMaterial3,
    required this.useCustomTheme,
  });

  /// Flutter debug properties override, includes toString.
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('useMaterial3', useMaterial3));
    properties.add(DiagnosticsProperty<bool>('useCustomTheme', useCustomTheme));
  }

  /// Copy the object with one or more provided properties changed.
  ThemeSettings copyWith({
    bool? useMaterial3,
    bool? useCustomTheme,
    bool? useIndicatorWidth,
    bool? useTileHeight,
  }) {
    return ThemeSettings(
      useMaterial3: useMaterial3 ?? this.useMaterial3,
      useCustomTheme: useCustomTheme ?? this.useCustomTheme,
    );
  }

  /// Override the equality operator.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ThemeSettings &&
        other.useMaterial3 == useMaterial3 &&
        other.useCustomTheme == useCustomTheme;
  }

  /// Override for hashcode, dart.ui Jenkins based.
  @override
  int get hashCode => Object.hashAll(<Object?>[
    useMaterial3.hashCode,
    useCustomTheme.hashCode,
  ]);
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

