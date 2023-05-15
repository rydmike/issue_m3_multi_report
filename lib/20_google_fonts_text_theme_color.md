### Package

google_fonts

### Existing issue?

- [X] I checked the [existing issues](https://github.com/material-foundation/flutter-packages/issues)

### What happened?

## GoogleFonts TextTheme Color defined to always use M2 light mode color

GoogleFonts TextTheme have their TextStyle colors hard coded to M2 light mode colors.

When using a GoogleFonts text theme, like e.g. `GoogleFonts.notoSansTextTheme()` it always comes with the colors from `ThemeData.light().textTheme` baked in as default color.

These TextTheme colors are only appropriate in `ThemeData(textTheme: ..., ...)` for M2 light mode. They are wrong default colors for all other modes, like dark M2, light or dark M3 and primaryTextTheme. Thus, when used for such cases as `TextTheme` in `ThemeData`, the colors have to be overridden for every TextStyle in the TextTheme to get mode correct or even usable contrast color.

If the used `TextStyle` colors in all the GoogleFonts TextThemes were null, `ThemeData` would add M2/M3 mode and light/dark appropriate colors to the GoogleFonts TextThemes when used in a theme.

The GoogleFonts TextThemes already have **NO font sizes defined**, since `ThemeData.light().textTheme` used as default does not yet resolve sizes, they are all null and get applied later in the localization step, this fact gives us M2/M3 mode correct sizes, but not colors.

Letting `Color` remain null in all `GoogleFonts` text themes and be applied by `ThemeData` to appropriate colors would be similar behavior for color and make the default GoogleFonts TextTheme get correct M2 (opacity based) based contrast colors in M2 and M3 (onSurface based) colors in M3 mode as well as correct contrast colors for light/dark mode.

Even when use as `primaryTextTheme` color would be resolved based on `ThemeData` modes, with the known issue and limitation `primaryTextTheme` has see Flutter [issue #118146](https://github.com/flutter/flutter/issues/118146).


Build the attached sample app to see the result. Toggle the switch ON to see expected results, keep OFF to see issues as presented below.


### Expected results

Expect to get M2/M3 mode and light/dark mode correct contrast color on the text when using `GoogleFonts` as `TextTheme` in `ThemeData` when used as `textTheme` and `primaryTextTheme`.

| M3 light | M3 dark |
|----------|---------|
| ![Screenshot 2023-05-15 at 6 05 42](https://github.com/material-foundation/flutter-packages/assets/39990307/8419824d-755d-47a0-b1da-67e40f88e620) | ![Screenshot 2023-05-15 at 6 06 08](https://github.com/material-foundation/flutter-packages/assets/39990307/2f6cf646-765f-4d75-95b8-6d6d1a45d5fc) |


| M2 light  | M2 dark   |
|-----------|-----------|
| ![Screenshot 2023-05-15 at 6 06 38](https://github.com/material-foundation/flutter-packages/assets/39990307/a090c199-04f1-4c39-b32e-fb8f19e0f3c5) | ![Screenshot 2023-05-15 at 6 07 05](https://github.com/material-foundation/flutter-packages/assets/39990307/e2c98e1e-e739-420b-8326-7e244c933751) |

> **NOTE:** The dark mode `primaryTextTheme` above have wrong contrast colors, but that is due to unrelated `ThemeData` [issue #118146](https://github.com/flutter/flutter/issues/118146).


### Actual results

| M3 light | M3 dark |
|----------|---------|
| ![Screenshot 2023-05-15 at 6 07 49](https://github.com/material-foundation/flutter-packages/assets/39990307/8271401b-f39b-4822-a893-cfd7e9ea0909) | ![Screenshot 2023-05-15 at 6 08 14](https://github.com/material-foundation/flutter-packages/assets/39990307/be0051e8-cb20-4cad-ac7e-7c851c1b25ee) |

In M3 light mode, the `textTheme` colors get M2 light mode based colors with its different opacities for different styles. This is incorrect, they should all be `onSurface` color with no opacity.

The `primaryTextTheme` is also M2 light mode text theme based, not only is it incorrect, it is also incorrect contrast for the used `primary` color.

In M3 dark mode, the same M2 light mode colors are used, they are not usable at all as colors on a dark mode `textTheme`.

Ironically, in dark mode, the light M2 theme mode font colors happen to work better on `primary` color than what `ThemeData` actually makes when colors are null. As mentioned, the reason for this is [issue #118146](https://github.com/flutter/flutter/issues/118146) and unrelated to this case.

| M2 light  | M2 dark   |
|-----------|-----------|
| ![Screenshot 2023-05-15 at 6 09 00](https://github.com/material-foundation/flutter-packages/assets/39990307/8bed0490-3d99-4154-82c4-5e1b92544a8b) | ![Screenshot 2023-05-15 at 6 09 22](https://github.com/material-foundation/flutter-packages/assets/39990307/be50c440-e902-4a2e-866d-aba1b9256659) |


In M2 light mode, the colors are actually correct for `textTheme`.
> Well for `Typography2014` anyway, I don't remember if it is actually correct for M2 `Typography2018` as well, or if 2018 changed any of the opacities used from 2014. I seem to recall they did not, it was just font sizes and some letter spacing. In this example that uses just vanilla `ThemeData` we get the very old `Typography2014` that actually don't use correct M2 sizes and letter spacing, but if we were to change to `Typography2018` we would get the correct M2 sizes. So that part works, but colors would remain with 2014 opacities, but as I recall, they are the same as 2018, so they are most likely correct "by accident".


In M2 dark mode, the `textTheme` uses the M2 light mode colors, and they are of course not legible at all. Again, in this case due mentioned unrelated issue, the dark mode `primaryTextTheme` is better than what `ThemeData` would actually make if colors were null.


### Proposal

Keep `color` null in all returned GoogleFonts TextThemes and all their TextStyles, and let `ThemeData` apply appropriate default colors. Users can still apply their own colors as needed.

The change is potentially breaking, but it makes `GoogleFonts` default TextThemes better in all `ThemeData` modes in Flutter. Importantly, it also gives us correct M3 mode font colors by default when we use M3.

Currently, I'm using a version of the fix presented in the attached sample in FlexColorScheme. As seen, I found a "reasonably" safe way to check when a given passed `TextTheme` is using a default GoogleFonts TextTheme, and only set colors to null then. It would be nice to not need this workaround. but I can of course continue to use it. Still it might also be nice to not have all users of GoogleFonts that use vanilla `ThemeData` struggle with this issue.

### Issue sample code

The reproduction sample code is attached below.

#### Sample build requirements

Add GoogleFonts to pubspec yaml.


```yaml
dependencies:
  google_fonts: ^4.0.4
```

If using **macOS** add:

```xml
<key>com.apple.security.network.client</key>
<true/>
```
To at least the macOS debug mode entitlements file.

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
import 'package:google_fonts/google_fonts.dart';

// A seed color for the M3 ColorScheme.
const Color seedColor = Color(0xFF05AAC2);
// Make M3 ColorSchemes from a seed color.
final ColorScheme schemeLight = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: seedColor,
);
final ColorScheme schemeDark = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: seedColor,
);

/// If the TextTheme looks like a GoogleFonts TextTheme, return the same theme
/// with font color set to null in all its TextStyles, otherwise keep as is.
TextTheme? makeGoogleFontsTextThemeColorsNull(final TextTheme? textTheme) {
  if (textTheme != null) {
    final TextTheme googleFontsTextTheme = ThemeData.light().textTheme.apply(
      fontFamily: '',
      fontFamilyFallback: <String>[''],
    );
    final TextTheme passedTextTheme = textTheme.apply(
      fontFamily: '',
      fontFamilyFallback: <String>[''],
    );
    // We don't care which text theme it was, just that its fingerprint
    // looked like a GoogleFonts TextTheme removing the fontFamily and
    // fontFamilyFallback above allows us to match on any font.
    if (googleFontsTextTheme == passedTextTheme) {
      return TextThemeColor.nullFontColor(textTheme);
    } else {
      return textTheme;
    }
  } else {
    return textTheme;
  }
}

// Example theme
ThemeData theme(ThemeMode mode, ThemeSettings settings) {
  final ColorScheme colorScheme =
      mode == ThemeMode.light ? schemeLight : schemeDark;

  final TextTheme textTheme = GoogleFonts.notoSansTextTheme();
  final TextTheme primaryTextTheme = GoogleFonts.robotoCondensedTextTheme();
  debugPrint('GoogleFonts bodyMedium size: ${textTheme.bodyMedium?.fontSize}');
  debugPrint('GoogleFonts bodyMedium color: ${textTheme.bodyMedium?.color}');

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: settings.useMaterial3,
    visualDensity: VisualDensity.standard,
    textTheme: settings.useCustomTheme
        ? makeGoogleFontsTextThemeColorsNull(textTheme)
        : textTheme,
    primaryTextTheme: settings.useCustomTheme
        ? makeGoogleFontsTextThemeColorsNull(primaryTextTheme)
        : primaryTextTheme,
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
                ? const Text("GoogleFonts TextTheme font color (Material 3)")
                : const Text("GoogleFonts TextTheme font color (Material 2)"),
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
    final ThemeData theme = Theme.of(context);
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'GoogleFonts TextTheme have hard coded to M2 light mode colors.\n'
            '\n'
            'When using a GoogleFonts text theme, like e.g. '
            'GoogleFonts.notoSansTextTheme() it always comes with the colors '
            'from ThemeData.light().textTheme baked in as default color.\n'
            '\n'
            'These TextTheme colors are only appropriate in '
            'ThemeData(textTheme: ...) '
            'for M2 light mode. They are wrong default colors for all other'
            'modes, dark M2, light/dark M3 and primaryTextTheme. Thus when '
            'used for such cases as TextTheme in ThemeData, the colors '
            'have to be overridden for every TextStyle in the TextTheme to '
            'get mode correct or even usable contrast color.'
            '\n'
            'If the used TextStyle colors in all the GoogleFonts TextThemes '
            'were null, '
            'ThemeData would add M2/M3 mode and light/dark appropriate colors '
            'to the GoogleFonts TextThemes when used in a theme.\n'
            '\n'
            'The GoogleFonts TextThemes already have NO font sizes defined, '
            'since ThemeData.light().textTheme used as default does not '
            'yet resolve sizes, they are all null and get applied later in '
            'localization step. Letting Color be applied by ThemeData to '
            'appropriate colors would be similar behavior for color and '
            'make the default GoogleFonts TextTheme get correct M2 '
            '(opacity based)/M3 (onSurface based) colors in respective '
            'mode as well as correct contrast colors for light/dark mode.',
          ),
        ),
        SwitchListTile(
          title: const Text(
              'Set GoogleFonts TextTheme colors to NULL to fix issue'),
          value: settings.useCustomTheme,
          onChanged: (bool value) {
            onSettings(settings.copyWith(useCustomTheme: value));
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text('Normal TextTheme',
                            style: theme.textTheme.titleMedium),
                      ),
                      const TextThemeShowcase(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                color: theme.colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text('Primary TextTheme',
                            style: theme.primaryTextTheme.titleMedium),
                      ),
                      const PrimaryTextThemeShowcase(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const ShowColorSchemeColors(),
            ],
          ),
        ),
      ],
    );
  }
}

class DatePickerDialogShowcase extends StatelessWidget {
  const DatePickerDialogShowcase({super.key});

  Future<void> _openDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) => DatePickerDialog(
        initialDate: DateTime.now(),
        firstDate: DateTime(1930),
        lastDate: DateTime(2050),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AbsorbPointer(
          child: DatePickerDialog(
            initialDate: DateTime.now(),
            firstDate: DateTime(1930),
            lastDate: DateTime(2050),
          ),
        ),
        TextButton(
          child: const Text(
            'Show DatePickerDialog',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () async => _openDialog(context),
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

class TextThemeShowcase extends StatelessWidget {
  const TextThemeShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return TextThemeColumnShowcase(textTheme: Theme.of(context).textTheme);
  }
}

class PrimaryTextThemeShowcase extends StatelessWidget {
  const PrimaryTextThemeShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return TextThemeColumnShowcase(
        textTheme: Theme.of(context).primaryTextTheme);
  }
}

class TextThemeColumnShowcase extends StatelessWidget {
  const TextThemeColumnShowcase({super.key, required this.textTheme});
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Font: ${textTheme.titleSmall!.fontFamily}',
            style:
                textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600)),
        Text(
          'Display Large '
          '(${textTheme.displayLarge!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.displayLarge,
        ),
        Text(
          'Display Medium '
          '(${textTheme.displayMedium!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.displayMedium,
        ),
        Text(
          'Display Small '
          '(${textTheme.displaySmall!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.displaySmall,
        ),
        const SizedBox(height: 12),
        Text(
          'Headline Large '
          '(${textTheme.headlineLarge!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.headlineLarge,
        ),
        Text(
          'Headline Medium '
          '(${textTheme.headlineMedium!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.headlineMedium,
        ),
        Text(
          'Headline Small '
          '(${textTheme.headlineSmall!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Text(
          'Title Large '
          '(${textTheme.titleLarge!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.titleLarge,
        ),
        Text(
          'Title Medium '
          '(${textTheme.titleMedium!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.titleMedium,
        ),
        Text(
          'Title Small '
          '(${textTheme.titleSmall!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        Text(
          'Body Large '
          '(${textTheme.bodyLarge!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.bodyLarge,
        ),
        Text(
          'Body Medium '
          '(${textTheme.bodyMedium!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.bodyMedium,
        ),
        Text(
          'Body Small '
          '(${textTheme.bodySmall!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        Text(
          'Label Large '
          '(${textTheme.labelLarge!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.labelLarge,
        ),
        Text(
          'Label Medium '
          '(${textTheme.labelMedium!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.labelMedium,
        ),
        Text(
          'Label Small '
          '(${textTheme.labelSmall!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.labelSmall,
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

/// A utility class to set the color of the font color to null in all
/// [TextStyle]s in a [TextTheme].
class TextThemeColor {
  /// Set font color to null in all styles in passed in [TextTheme] and
  /// return the new [TextTheme] other properties remain unchanged.
  static TextTheme nullFontColor(TextTheme textTheme) {
    /// Set font color to null in all styles in passed in [TextTheme] and
    return TextTheme(
      displayLarge: nullColor(textTheme.displayLarge!),
      displayMedium: nullColor(textTheme.displayMedium!),
      displaySmall: nullColor(textTheme.displaySmall!),
      //
      headlineLarge: nullColor(textTheme.headlineLarge!),
      headlineMedium: nullColor(textTheme.headlineMedium!),
      headlineSmall: nullColor(textTheme.headlineSmall!),
      //
      titleLarge: nullColor(textTheme.titleLarge!),
      titleMedium: nullColor(textTheme.titleMedium!),
      titleSmall: nullColor(textTheme.titleSmall!),
      //
      bodyLarge: nullColor(textTheme.bodyLarge!),
      bodyMedium: nullColor(textTheme.bodyMedium!),
      bodySmall: nullColor(textTheme.bodySmall!),
      //
      labelLarge: nullColor(textTheme.labelLarge!),
      labelMedium: nullColor(textTheme.labelMedium!),
      labelSmall: nullColor(textTheme.labelSmall!),
    );
  }

  /// Set font color to null in all styles in passed in [TextStyle] and
  /// return the new [TextStyle] other properties remain unchanged.
  static TextStyle nullColor(TextStyle style) {
    return TextStyle(
      color: null, // Set color to NULL, let ThemeData handle default.
      backgroundColor: style.backgroundColor,
      fontSize: style.fontSize,
      fontWeight: style.fontWeight,
      fontStyle: style.fontStyle,
      letterSpacing: style.letterSpacing,
      wordSpacing: style.wordSpacing,
      textBaseline: style.textBaseline,
      height: style.height,
      leadingDistribution: style.leadingDistribution,
      locale: style.locale,
      foreground: style.foreground,
      background: style.background,
      shadows: style.shadows,
      fontFeatures: style.fontFeatures,
      fontVariations: style.fontVariations,
      decoration: style.decoration,
      decorationColor: style.decorationColor,
      decorationStyle: style.decorationStyle,
      decorationThickness: style.decorationThickness,
      debugLabel: style.debugLabel,
      fontFamily: style.fontFamily,
      fontFamilyFallback: style.fontFamilyFallback,
      overflow: style.overflow,
    );
  }
}

```

</details>






### Used versions

* Flutter Channel stable, 3.10.0
* GoogleFonts 4.0.4

### Relevant log output

<details>
  <summary>Flutter doctor</summary>

```console
flutter doctor -v
[v] Flutter (Channel stable, 3.10.0, on macOS 13.2.1 22D68 darwin-arm64, locale en-US)
    • Flutter version 3.10.0 on channel stable at /Users/rydmike/fvm/versions/stable
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision 84a1e904f4 (6 days ago), 2023-05-09 07:41:44 -0700
    • Engine revision d44b5a94c9
    • Dart version 3.0.0
    • DevTools version 2.23.1

[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.0)
    • Android SDK at /Users/rydmike/Library/Android/sdk
    • Platform android-33, build-tools 33.0.0
    • Java binary at: /Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build 11.0.15+0-b2043.56-8887301)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 14.3)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Build 14E222b
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

[✓] IntelliJ IDEA Community Edition (version 2023.1)
    • IntelliJ at /Applications/IntelliJ IDEA CE.app
    • Flutter plugin version 73.0.4
    • Dart plugin version 231.8109.91

[✓] VS Code (version 1.77.3)
    • VS Code at /Applications/Visual Studio Code.app/Contents
    • Flutter extension version 3.62.0

[✓] Connected device (2 available)
    • macOS (desktop) • macos  • darwin-arm64   • macOS 13.2.1 22D68 darwin-arm64
    • Chrome (web)    • chrome • web-javascript • Google Chrome 113.0.5672.92

[✓] Network resources
    • All expected network resources are available.

```

</details>

