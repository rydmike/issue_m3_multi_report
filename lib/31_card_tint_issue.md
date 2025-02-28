## Issue https://github.com/flutter/flutter/issues/132199

### Card and surface elevation tinting

@HansMuller, it depends a bit on how technical we want to get with the documentation of the surface tinting as a function of the elevation.

Technically it as an alpha blend starting at opacity 0 (alpha 0x00 ) for elevation 0 and ending at opacity 0.14 (alpha 0x23) reached at elevation 12 or higher. At higher elevations there is no more of the `surfaceTintColor` alpha blended into to the background color.

The fact that the max opacity used for the alpha blend is 0.14, means that it will not be so visible when used on dark background colors.

In the above `blueAccent` background color example, using `Colors.red` as `surfaceTintColor`, the `blueAccent` background color is correctly shifted towards red, it is just subtle and not very visible on the fairly dark blue color.

Regarding the original sample, I cannot replicate it since the Dartpad code sample does not seem to work. **Dartpad** samples needs to have gist url links to work, this one does not have one.

I modified an old example to demonstrate what I see, and attached it below. You can also try it in DartPad here:

https://dartpad.dev/?id=fefe44d813fca88dd2893da1c3c7b389

The sample starts with the colors used in the above example, but you can vary the elevation to see the red "shift" tint effect.

You can also remove the custom background color and see the red tint better on the lighter surface color. Plus you can remove the tint with transparent tint color, and use or not use the custom shadow from above example. So it allows you to test a few option interactively and compare with a `Card` always at 0 elevation and none elevated `BoxDecoration`, to compare the active background colors.

The `Card` being modified is obviously in the middle:


https://github.com/flutter/flutter/assets/39990307/02b5b4b1-75e7-48ed-874a-165551a87101




The **DartPad** example is on **stable** channel, but I also tried on latest **master**, same results.

With this sample I cannot see any functional issues. As far as I can replicate and see, it all works as intended, but perhaps the intent of the `surfaceTint` could be explained with some more detail.


----

**EDIT:**

Ah, yes now I see, the docs says:

```dart
  /// The color used as an overlay on [color] to indicate elevation.
  ///
  /// If this is null, no overlay will be applied. Otherwise this color
  /// will be composited on top of [color] with an opacity related
  /// to [elevation] and used to paint the background of the card.
  ///
  /// The default is null.
  ///
  /// See [Material.surfaceTintColor] for more details on how this
  /// overlay is applied.
  final Color? surfaceTintColor;
```

The **doc comment is incorrect**, to get no tint you have to pass `Colors.transparent` (or theme it to that). If it is null and we are using Material3, it defaults to `Theme.of(context).colorScheme.surfaceTint`, which typically it the same as `Theme.of(context).colorScheme.primary`.

----

@TahaTesser, did you not recently add some doc update regarding surface tint, elevation and shadows?

---

@HansMuller, I just noticed when looking at the elevation tint code, that the `_surfaceTintOpacityForElevation` could consider a minor optimization, instead of `if (elevation < _surfaceTintElevationOpacities[0].elevation)` it could use `<=` and exit early also for zero elevation and not start the while loop then either. Minor, but elevation 0 is pretty common, might be worth it.

```dart
  // Calculates the opacity of the surface tint color from the elevation by
  // looking it up in the token generated table of opacities, interpolating
  // between values as needed. If the elevation is outside the range of values
  // in the table it will clamp to the smallest or largest opacity.
  static double _surfaceTintOpacityForElevation(double elevation) {
    if (elevation <= _surfaceTintElevationOpacities[0].elevation) {
      // Elevation less than the first entry, so just clamp it to the first one.
      return _surfaceTintElevationOpacities[0].opacity;
    }
   ...
```

Code link: https://github.com/flutter/flutter/blob/7c59dfebb957fd8fe3fc0246ee366c8d1da0c817/packages/flutter/lib/src/material/elevation_overlay.dart#L39


## Example Card tint code

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

// This issue reported here: https://github.com/flutter/flutter/issues/132199

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
                ? const Text("Card elevation (Material 3)")
                : const Text("Card elevation (Material 2)"),
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
  });
  final ThemeSettings settings;
  final ValueChanged<ThemeSettings> onSettings;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        Padding(
          padding: EdgeInsets.all(16.0),
          child:
          Text('Example of Card with Elevation, Opacity, Tint and Shadow.'),
        ),
        SizedBox(height: 16),
        CardShowCase(),
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: ShowColorSchemeColors(),
        ),
      ],
    );
  }
}

class CardShowCase extends StatefulWidget {
  const CardShowCase({super.key});

  @override
  State<CardShowCase> createState() => _CardShowCaseState();
}

class _CardShowCaseState extends State<CardShowCase> {
  double opacity = 1.0;
  double elevation = 9;
  bool isTinted = true;
  bool hasShadow = true;
  bool hasCustomBackground = true;
  bool hasCustomTint = true;
  bool hasCustomShadow = true;
  //
  Color cardColor = Colors.blueAccent;
  Color? shadowColor = Colors.cyan;
  Color? tintColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;

    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Opacity'),
          subtitle: Slider(
            min: 0.0,
            max: 1.0,
            divisions: 50,
            value: opacity,
            label: opacity.toStringAsFixed(2),
            onChanged: (double newValue) {
              setState(() {
                opacity = newValue;
              });
            },
          ),
          trailing: Text(opacity.toStringAsFixed(2)),
        ),
        ListTile(
          title: const Text('Elevation'),
          subtitle: Slider(
            min: 0.0,
            max: 20.0,
            divisions: 40,
            value: elevation,
            label: elevation.toStringAsFixed(1),
            onChanged: (double newValue) {
              setState(() {
                elevation = newValue;
              });
            },
          ),
          trailing: Text(elevation.toStringAsFixed(1)),
        ),
        SwitchListTile(
          title: const Text('Use custom blue accent background?'),
          subtitle: const Text('OFF=scheme.surface  ON=Colors.blueAccent'),
          value: hasCustomBackground,
          onChanged: (bool newValue) {
            setState(() {
              hasCustomBackground = newValue;
              if (hasCustomBackground) {
                cardColor = Colors.blueAccent;
              } else {
                cardColor = colors.surface;
              }
            });
          },
        ),
        SwitchListTile(
          title: const Text('Is tinted?'),
          subtitle: const Text('OFF=transparent  ON=setting below'),
          value: isTinted,
          onChanged: (bool newValue) {
            setState(() {
              isTinted = newValue;
              if (!isTinted) {
                tintColor = Colors.transparent;
              } else {
                if (hasCustomTint) {
                  tintColor = Colors.red;
                } else {
                  tintColor = null;
                }
              }
            });
          },
        ),
        SwitchListTile(
          title: const Text('Use custom red tint?'),
          subtitle: const Text('OFF=null=scheme.primary  ON=Colors.red'),
          value: hasCustomTint && isTinted,
          onChanged: isTinted
              ? (bool newValue) {
            setState(() {
              hasCustomTint = newValue;
              if (!isTinted) {
                tintColor = Colors.transparent;
              } else {
                if (hasCustomTint) {
                  tintColor = Colors.red;
                } else {
                  tintColor = null;
                }
              }
            });
          }
              : null,
        ),
        SwitchListTile(
          title: const Text('Has shadow?'),
          subtitle: const Text('OFF=transparent  ON=setting below'),
          value: hasShadow,
          onChanged: (bool newValue) {
            setState(() {
              hasShadow = newValue;
              if (!hasShadow) {
                shadowColor = Colors.transparent;
              } else {
                if (hasCustomShadow) {
                  shadowColor = Colors.cyan;
                } else {
                  shadowColor = Colors.black;
                }
              }
            });
          },
        ),
        SwitchListTile(
          title: const Text('Use custom cyan shadow?'),
          subtitle: const Text('OFF=null=scheme.shadow  ON=Colors.cyan'),
          value: hasShadow && hasCustomShadow,
          onChanged: (bool newValue) {
            setState(() {
              hasCustomShadow = newValue;
              if (!hasShadow) {
                shadowColor = Colors.transparent;
              } else {
                if (hasCustomShadow) {
                  shadowColor = Colors.cyan;
                } else {
                  shadowColor = null;
                }
              }
            });
          },
        ),
        Wrap(
          spacing: 20,
          children: [
            Card(
              elevation: 0,
              color: cardColor.withValues(alpha: opacity),
              surfaceTintColor: tintColor,
              shadowColor: shadowColor,
              child: const SizedBox(
                width: 150,
                height: 150,
                child: Center(
                  child: Text('Card\nElevation 0'),
                ),
              ),
            ),
            Card(
              elevation: elevation,
              color: cardColor.withValues(alpha: opacity),
              surfaceTintColor: tintColor,
              shadowColor: shadowColor,
              child: SizedBox(
                width: 150,
                height: 150,
                child: Center(
                  child:
                  Text('Card\nElevation\n${elevation.toStringAsFixed(2)}'),
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: cardColor.withValues(alpha: opacity),
              ),
              child: const SizedBox(
                width: 150,
                height: 150,
                child: Center(
                  child: Text('DecoratedBox\nNo elevation'),
                ),
              ),
            ),
          ],
        ),
      ],
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

