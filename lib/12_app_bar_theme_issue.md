## SliverAppBar.medium and SliverAppBar.large Theming and Defaults Issue

### 1) AppBar with Themed and Widget Assigned Color Foreground

The `AppBar`'s foreground theme color, from theme or widget foreground color properties are **not applied** to action icon color for `SliverAppBar.medium` and `SliverAppBar.large`.

### 2) AppBar with Default Foreground Color in M2

The defaults for M2 foreground color on a `SliverAppBar.medium` and `SliverAppBar.large` are **incorrect** in **light theme** mode when using **Material 2**.

### Background and Work in Progress

A previous fix related to `SliverAppBar.medium` and `SliverAppBar.large` was made in this [FIX PR #118322](https://github.com/flutter/flutter/pull/118322), but it did not address these issues.

Another [FIX PR #122542](https://github.com/flutter/flutter/pull/122542) is still open, it addresses multiple related AppBar issues. It is unknown if it addresses any of these issues, it probably does not. Addressing these issues could potentially be added to it, or of course addressed later as a separate fix.


## Expected results

### 1) AppBar with Themed and Widget Assigned Color Foreground

Expect correct themed and widget foreground color to be used in M2 and M3 mode on `SliverAppBar.medium` and `SliverAppBar.large`.


| Light theme | Dark theme |
|-------------|------------|
| Material 2  | Material 2 |
| ![Screenshot 2023-04-01 at 22 50 16](https://user-images.githubusercontent.com/39990307/229311312-8d7d5f31-5870-4b56-b178-b85b7662f705.png) | ![Screenshot 2023-04-01 at 22 51 04](https://user-images.githubusercontent.com/39990307/229311344-8aceb486-03ce-415f-aae6-34f1d9863f96.png) |
| Material 3  | Material 3 |
| ![Screenshot 2023-04-01 at 22 51 30](https://user-images.githubusercontent.com/39990307/229311367-95b04c45-76b1-4e35-a1bd-a4e28de23d64.png) | ![Screenshot 2023-04-01 at 22 51 51](https://user-images.githubusercontent.com/39990307/229311388-5c0b5ae0-833e-40a7-8920-066ae4d98a10.png) |

### 2) AppBar with Default Foreground Color in M2

Expect Material 2 theme to use correct default foreground color on `SliverAppBar.medium` and `SliverAppBar.large`.

| Light theme | Dark theme |
|-------------|------------|
|  ![Screenshot 2023-04-01 at 22 33 00](https://user-images.githubusercontent.com/39990307/229310937-c2aaae59-5dc6-49a4-803d-64976e642e77.png)           | ![Screenshot 2023-04-01 at 22 34 31](https://user-images.githubusercontent.com/39990307/229310959-cfd0f969-159c-49b6-ab62-7a32c2e42343.png) |

## Actual results

### 1) AppBar with Themed and Widget Assigned Color Foreground

Get **incorrect** themed and widget foreground color in both M2 and M3 mode on `SliverAppBar.medium` and `SliverAppBar.large` on **action icons**, as shown below:

| Light theme | Dark theme |
|-------------|------------|
| Material 2  | Material 2 |
| ![Screenshot 2023-04-01 at 23 03 43](https://user-images.githubusercontent.com/39990307/229311839-632d3f3d-1395-49c3-b294-2dcd5519d5fb.png) | ![Screenshot 2023-04-01 at 23 05 23](https://user-images.githubusercontent.com/39990307/229311872-ddb3ced9-678e-491f-b085-e836c178b879.png) |
| Material 3  | Material 3 |
| ![Screenshot 2023-04-01 at 23 06 12](https://user-images.githubusercontent.com/39990307/229311893-74e60133-a601-4c83-9974-92a2d54a11f2.png) | ![Screenshot 2023-04-01 at 23 06 55](https://user-images.githubusercontent.com/39990307/229311920-47e08933-9b1f-4446-83f7-8254b0ed17b5.png) |


### 2) AppBar with Default Foreground Color in M2

In Material 2 mode, when using light theme mode, get **incorrect** default foreground color on `SliverAppBar.medium` and `SliverAppBar.large` **title** and **action icons**, as shown below:

| Light theme | Dark theme |
|-------------|------------|
| ![Screenshot 2023-04-01 at 22 44 07](https://user-images.githubusercontent.com/39990307/229311113-f368f814-5813-4d8d-a746-41c6a330ec6e.png) | ![Screenshot 2023-04-01 at 22 45 29](https://user-images.githubusercontent.com/39990307/229311133-4899bbc9-b603-49b3-8df6-29fff96074d6.png) |

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
// FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// This issue reported here:

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
    appBarTheme: settings.useCustomTheme
        ? AppBarTheme(
      backgroundColor: colorScheme.secondary,
      foregroundColor: colorScheme.onSecondary,
    )
        : null,
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
                ? const Text("AppBar Theme Issue (Material 3)")
                : const Text("AppBar Theme Issue (Material 2)"),
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
      children: [
        const SizedBox(height: 8),
        const Text(
          "The AppBar's foreground color is not applied to action icons "
              'for SliverAppBar.medium and large.\n'
              '\n'
              'The defaults for M2 foreground color on a SliverAppBar.medium '
              'and large are incorrect light theme mode.\n',
        ),
        SwitchListTile(
          title: const Text('Enable custom AppBar theme'),
          value: settings.useCustomTheme,
          onChanged: (bool value) {
            onSettings(settings.copyWith(useCustomTheme: value));
          },
        ),
        const SizedBox(height: 16),
        const AppBarShowcase(),
        const SizedBox(height: 16),
        const ShowColorSchemeColors(),
      ],
    );
  }
}

class AppBarShowcase extends StatelessWidget {
  const AppBarShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool usesDefault =
        Theme.of(context).appBarTheme == const AppBarTheme();
    return Card(
      color: colorScheme.surfaceVariant,
      child: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        removeTop: true,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {},
                ),
                title: usesDefault
                    ? const Text('Standard AppBar Default')
                    : const Text('Standard AppBar Themed'),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppBar(
                backgroundColor: colorScheme.tertiary,
                foregroundColor: colorScheme.onTertiary,
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {},
                ),
                title: const Text('Standard AppBar Widget Colors'),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                ],
              ),
              // A bit nasty usage of CustomScrollViews and Slivers and
              // shrinkWraps, to show what the SliverAppBars look like, don't
              // do this in a production app. With just a few widgets,
              // we can get away with it.
              const SizedBox(height: 16),
              CustomScrollView(
                shrinkWrap: true,
                slivers: <Widget>[
                  SliverAppBar(
                    leading: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {},
                    ),
                    title: usesDefault
                        ? const Text('SliverAppBar Default')
                        : const Text('SliverAppBar Themed'),
                    actions: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),
              CustomScrollView(
                shrinkWrap: true,
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: colorScheme.tertiary,
                    foregroundColor: colorScheme.onTertiary,
                    leading: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {},
                    ),
                    title: const Text('SliverAppBar Widget Colors'),
                    actions: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),
              CustomScrollView(
                shrinkWrap: true,
                slivers: <Widget>[
                  SliverAppBar.medium(
                    leading: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {},
                    ),
                    title: usesDefault
                        ? const Text('SliverAppBar.medium Default')
                        : const Text('SliverAppBar.medium Themed'),
                    actions: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),
              CustomScrollView(
                shrinkWrap: true,
                slivers: <Widget>[
                  SliverAppBar.medium(
                    backgroundColor: colorScheme.tertiary,
                    foregroundColor: colorScheme.onTertiary,
                    leading: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {},
                    ),
                    title: const Text('SliverAppBar.medium Widget Colors'),
                    actions: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),
              CustomScrollView(
                shrinkWrap: true,
                slivers: <Widget>[
                  SliverAppBar.large(
                    // foregroundColor: colorScheme.onTertiary,
                    leading: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {},
                    ),
                    title: usesDefault
                        ? const Text('SliverAppBar.large Default')
                        : const Text('SliverAppBar.large Themed'),
                    actions: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),
              CustomScrollView(
                shrinkWrap: true,
                slivers: <Widget>[
                  SliverAppBar.large(
                    backgroundColor: colorScheme.tertiary,
                    foregroundColor: colorScheme.onTertiary,
                    leading: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {},
                    ),
                    title: const Text('SliverAppBar.large Widget Colors'),
                    actions: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
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

## Used Flutter version

Channel master, 3.9.0-20.0.pre.76

<details>
  <summary>Flutter doctor</summary>

```

flutter doctor -v
[✓] Flutter (Channel master, 3.9.0-20.0.pre.76, on macOS 13.2.1 22D68 darwin-arm64, locale en-US)
    • Flutter version 3.9.0-20.0.pre.76 on channel master at /Users/rydmike/fvm/versions/master
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision 1d90b7654a (6 hours ago), 2023-04-01 09:10:01 -0400
    • Engine revision dc204128ff
    • Dart version 3.0.0 (build 3.0.0-393.0.dev)
    • DevTools version 2.22.2
    • If those were intentional, you can disregard the above warnings; however it is recommended to use "git"
      directly to perform update checks and upgrades.

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
    • Flutter plugin version 72.1.5
    • Dart plugin version 231.8109.91

[✓] VS Code (version 1.77.0)
    • VS Code at /Applications/Visual Studio Code.app/Contents
    • Flutter extension version 3.60.0

[✓] Connected device (2 available)
    • macOS (desktop) • macos  • darwin-arm64   • macOS 13.2.1 22D68 darwin-arm64
    • Chrome (web)    • chrome • web-javascript • Google Chrome 111.0.5563.146

[✓] Network resources
    • All expected network resources are available.


```

</details>
