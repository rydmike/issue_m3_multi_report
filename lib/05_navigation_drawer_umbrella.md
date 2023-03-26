## NavigationDrawer Issues

This is an umbrella issue to collect multiple new and known issues with the `NavigationDrawer`. The here reported new issues may later, if so desired, be added as individual issues, or they may also be addressed as a single entity in one major refactor fix of `NavigationDrawer`.

Currently, the `NavigationDrawer` has a number of Material-3 spec gaps that may warrant significant internal changes to the widget. When that is done, it may be appropriate, certainly more time efficient, to address all these issues one go.

One could argue that the `NavigationDrawer` is just another menu type and could re-use some of the menu components, or at least use `ButtonStyleButton` to offer the correct overlay styles and states it currently lacks. At the same time, it would gain missing customization features. The current version can of course alternatively be modified to offer required features. I partially did so in a quick hack to demonstrate the correct **expected** results.

## Summary of Issues

Summary of found new `NavigationDrawer` issues:

- [ ] **1)** Indicator is centered when sized.
- [ ] **2)** Ink size does not follow indicator size.
- [ ] **3)** Ink effects do not follow M3 spec.
- [ ] **4)** Ink effect colors cannot be changed.
- [ ] **5)** Drawer size change animation overflows.
- [ ] **6)** Label is not truncated to fit.

Previously reported issues with `NavigationDrawer`:

- [ ] https://github.com/flutter/flutter/issues/123380
- [ ] https://github.com/flutter/flutter/issues/121662
- [ ] https://github.com/flutter/flutter/issues/120169
- [ ] https://github.com/flutter/flutter/issues/120083
- [x] https://github.com/flutter/flutter/issues/123324


## 1) Indicator is centered when sized

### Expected results

Expect Indicator to be start aligned when using custom size, so it can be used with a size that does not go all the way to the edge of the Drawer, in both LTR and RTL layouts.

| Default Size  | Custom Size LTR | Custom Size RTL |
|---------------|-----------------|-----------------|
| ![Screenshot 2023-03-26 at 23 46 14](https://user-images.githubusercontent.com/39990307/227806661-5bacb391-8c95-40d8-b8cd-6dd440dacad0.png) | ![Screenshot 2023-03-26 at 23 46 27](https://user-images.githubusercontent.com/39990307/227806688-8d97fa55-dd2d-41ba-a926-a6d09c17780c.png) | ![Screenshot 2023-03-26 at 23 46 43](https://user-images.githubusercontent.com/39990307/227806705-99fa1a1f-3892-434f-822a-3e4acbd1e594.png) |

### Actual results

Get an indicator that is centered. This is not usable if you want to make an indicator that does not go all the way to the edge of the Drawer. Making a less wide indicator than all the way to the edge must be one use case of the indicator-sizing feature, but it is broken. Height adjustments work well.

| Default Size  | Custom Size |
|---------------|-------------|
| ![Screenshot 2023-03-27 at 0 22 23](https://user-images.githubusercontent.com/39990307/227806743-064cadc0-4cac-4598-9bdd-02a3b4bf242a.png) | ![Screenshot 2023-03-27 at 0 22 34](https://user-images.githubusercontent.com/39990307/227806755-ad3bff89-3470-4787-b6d3-24c24aaa872f.png) |



## 2) Ink size does not follow indicator size

### Expected results

Expect Ink (hover, focus, pressed) to follow drawer indicator size.

| Default Size  | Custom Size |
|---------------|-------------|
| ![Screenshot 2023-03-26 at 23 47 27](https://user-images.githubusercontent.com/39990307/227806823-dbab3197-c3aa-46f4-a6e4-a242c7b8c586.png) | ![Screenshot 2023-03-26 at 23 47 11](https://user-images.githubusercontent.com/39990307/227806828-57a957fc-4fb9-4437-981d-66123ffe1a1a.png) |



### Actual results

Ink (hover, focus, pressed) do not follow the size of the indicator, they remain default sized.

| Default Size  | Custom Size 1 |  Custom Size 2 |
|---------------|---------------|----------------|
| ![Screenshot 2023-03-27 at 0 22 52](https://user-images.githubusercontent.com/39990307/227806901-6219225b-0b8d-402b-9394-9fcf54e1ad3e.png) | ![Screenshot 2023-03-27 at 0 23 24](https://user-images.githubusercontent.com/39990307/227806913-3488c8a6-b3bb-41b5-8a5b-3c04ff2036ae.png) | ![Screenshot 2023-03-27 at 0 23 41](https://user-images.githubusercontent.com/39990307/227806922-bf46ef0a-e472-4e94-b2c3-52f6b7b5fb1e.png) |


## 3) Ink effects do not follow M3 spec

### Expected results

Expect a default `NavigationDrawer` to have ink or interaction state effects matching its [Material-3 specification](https://m3.material.io/components/navigation-drawer/specs#255ac2b9-e732-4765-993b-bb4fa1b16d02).

![Screenshot 2023-03-27 at 0 54 31](https://user-images.githubusercontent.com/39990307/227807024-e7d5d1ba-3743-4052-a06b-0030ca76ce52.png)

Also shown in recording below:

https://user-images.githubusercontent.com/39990307/227806979-f3238e3c-653c-42dc-aa08-10c0e338b98c.mov



### Actual results

Get interaction state effects that are incorrect.

* No ink at all on selected item, on the indicator. The M3 spec defines how it should look, and that it has ink.

* Tapping an item uses the `NavigationIndicator` used by `NavigationRail` and `NavigationBar` that animates out in one plane from the center with no ink. This is correct for those widgets, but in M3 spec `NavigationDrawer` does not use this style. Comparing to Android native applications e.g. with **M3 Catalog** we can confirm this as well on Android native implementation of its `NavigationDrawer`. We can also se that the `NavigationRail` and `NavigationBar` on native Android have the center plane expand indicator, so that part is correct in Flutter M3 as well. It seems like it was assumed that `NavigationDrawer` indicator should behave the same, perhaps the spec did not exists when it was made, and it arrived later, would not be the first time that has happened.

* Ink colors are wrong since InkWell with defaults is used. There are no M3 tokens used to ensure correct ink colors. InkWell without colors defined, get defaults from ThemeData hover, focus, splash etc, and they are not correct colors for M3 design.

![image](https://user-images.githubusercontent.com/39990307/227807281-50aaec66-db6e-4484-8447-26f74bf0eab1.png)

Also demonstrated in slow-mo recording below:

https://user-images.githubusercontent.com/39990307/227807288-fe50da8d-d750-4493-9556-fb942f434ebe.mov


## 4) Ink effect colors cannot be changed

### Expected results

Expect to be able to change the ink response overlay colors.

When you style or theme a widget with colors different from default colors, you need to be able to modify the used overlay colors on selected item and unselected items, to provide it with correct color expressiveness.

### Actual results

There are no properties to modify used ink styles (overlay color depending on state). The drawer indicator can thus not really be styled properly. If the custom style deviates significantly from the default color, the design starts to look very odd.



## 5) Drawer size change animation overflows

### Expected results

Expect to be able to change the width of the `NavigationDrawer`, even completely removing a custom width and going back to null by default property, without the theme change animation causing an overflow error due to content being temporarily truncated.

Typically, widgets handle this type of change well, but not in this case. For example buttons do it well, even the removal of custom tile height in `NavigationDrawer` itself handles it well, items scale down to nothing and up again when the custom size is removed and replaced with null default value. Example shown below with this OK behavior on `tileHeight` change in slow motion:

https://user-images.githubusercontent.com/39990307/227807484-bca28939-a0c6-487b-9bb9-6373236c8939.mov


### Actual results

Removing a custom drawer width causes an overflow error, shown below in slow-mo:

https://user-images.githubusercontent.com/39990307/227807556-55002e20-360d-4f22-aac6-598dfa540317.mov


## 6) Label is not truncated to fit

The M3 guide depicts labels being on only one line and to get truncated when not fitting.

See: https://m3.material.io/components/navigation-drawer/guidelines#02f84591-77c5-403e-b992-ae5ae8267471

![image](https://user-images.githubusercontent.com/39990307/227807626-540cd254-2349-4e72-96dc-724ff907d9cf.png)


Some users expected that if the above is the case, the widget should offer it as a built-in feature.

This feature could be useful if the labels are from dynamically added content, like links, folders, files etc., that may have long names and will never fit.

### Expected results

Truncated long label:

![Screenshot 2023-03-27 at 0 27 13](https://user-images.githubusercontent.com/39990307/227807656-bbb43b05-f6c3-4cda-90e2-e694ef0762a1.png)

### Actual results

Long labels are not truncated, they overflow.

![Screenshot 2023-03-26 at 23 52 19](https://user-images.githubusercontent.com/39990307/227807670-39039d5a-2887-48e0-a3a2-e53b4058bcab.png)


**Note**:

This request could also be addressed via documentation. Users can already add truncation to their `NavigationDrawerDestination`'s by simply using a `SizedBox` and `overflow`, to style to their `Text` label, for example:

```dart
NavigationDrawerDestination(
  icon: const Icon(Icons.create_new_folder_outlined),
  selectedIcon: const Icon(Icons.create_new_folder),
  label: widget.longLabel
      ? const SizedBox(
          width: 150,
          child: Text(
            'Folder with a very long name',
            overflow: TextOverflow.ellipsis,
          ),
        )
      : const Text('Folder'),
),
```

## Used quick fixes for the issue demo

For the sample app, a few custom fixes were made to demonstrate expected behavior. They are not so useful for final solution, only here offered to show what was done to quickly produce expected results.

As mentioned before, it might be good to consider if the entire `NavigationDrawer` should perhaps just be another menu type implementation, or at least use `ButtonStyleButton` to be able to offer the required states and styles per state, via M3 defaults, theme and widget properties.

<details>
  <summary>Fixes for the issue demo</summary>

```dart
/// Widget that handles the semantics and layout of a navigation drawer
/// destination.
///
/// Prefer [NavigationDestination] over this widget, as it is a simpler
/// (although less customizable) way to get navigation drawer destinations.
///
/// The icon and label of this destination are built with [buildIcon] and
/// [buildLabel]. They should build the unselected and selected icon and label
/// according to [_NavigationDrawerDestinationInfo.selectedAnimation], where an
/// animation value of 0 is unselected and 1 is selected.
///
/// See [NavigationDestination] for an example.
class _NavigationDestinationBuilder extends StatelessWidget {
  /// Builds a destination (icon + label) to use in a Material 3 [NavigationDrawer].
  const _NavigationDestinationBuilder({
    required this.buildIcon,
    required this.buildLabel,
    required this.selected,
  });

  /// Builds the icon for a destination in a [NavigationDrawer].
  ///
  /// To animate between unselected and selected, build the icon based on
  /// [_NavigationDrawerDestinationInfo.selectedAnimation]. When the animation is 0,
  /// the destination is unselected, when the animation is 1, the destination is
  /// selected.
  ///
  /// The destination is considered selected as soon as the animation is
  /// increasing or completed, and it is considered unselected as soon as the
  /// animation is decreasing or dismissed.
  final WidgetBuilder buildIcon;

  /// Builds the label for a destination in a [NavigationDrawer].
  ///
  /// To animate between unselected and selected, build the icon based on
  /// [_NavigationDrawerDestinationInfo.selectedAnimation]. When the animation is
  /// 0, the destination is unselected, when the animation is 1, the destination
  /// is selected.
  ///
  /// The destination is considered selected as soon as the animation is
  /// increasing or completed, and it is considered unselected as soon as the
  /// animation is decreasing or dismissed.
  final WidgetBuilder buildLabel;

  /// This [_NavigationDestinationBuilder] item is selected.
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final _NavigationDrawerDestinationInfo info = _NavigationDrawerDestinationInfo.of(context);
    final NavigationDrawerThemeData navigationDrawerTheme = NavigationDrawerTheme.of(context);
    final NavigationDrawerThemeData defaults = _NavigationDrawerDefaultsM3(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: _NavigationDestinationSemantics(
        child: SizedBox(
          height: navigationDrawerTheme.tileHeight ?? defaults.tileHeight,
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: <Widget>[
              SizedBox(
                width: (navigationDrawerTheme.indicatorSize ?? defaults.indicatorSize!).width,
                height: (navigationDrawerTheme.indicatorSize ?? defaults.indicatorSize!).height,
                child: Material(
                  shape: info.indicatorShape ?? navigationDrawerTheme.indicatorShape ?? defaults.indicatorShape!,
                  color: selected ? info.indicatorColor ?? navigationDrawerTheme.indicatorColor ?? defaults.indicatorColor! : Colors.transparent,
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    hoverColor: selected ? colorScheme.onSecondaryContainer.withOpacity(0.08) : colorScheme.onSurface.withOpacity(0.08),
                    focusColor: selected ? colorScheme.onSecondaryContainer.withOpacity(0.12) : colorScheme.onSurface.withOpacity(0.12),
                    splashColor: selected ? colorScheme.onSecondaryContainer.withOpacity(0.12) : colorScheme.onSurface.withOpacity(0.12),
                    onTap: info.onTap,
                    customBorder: info.indicatorShape ?? navigationDrawerTheme.indicatorShape ?? defaults.indicatorShape!,
                    child: Row(
                      children: <Widget>[
                        const SizedBox(width: 16),
                        buildIcon(context),
                        const SizedBox(width: 12),
                        buildLabel(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

The above only uses Ink colors suitable for the default M3 theme, they where just added to demo more correct expected ink results. The values should come from token DB for defaults. Start with fall through from widget values, to theme values to M3 defaults, as always.

In `NavigationDrawerDestination` that returns `_NavigationDestinationBuilder` the `selected` property was added as:

```dart
      selected: _isForwardOrCompleted(animation)
          ? true
          : false,
```

in addition to `buildIcon` and `buildLabel`. This was just a quick workaround to get the desired style. The entire used animation can potentially be removed, since the beautifully animated `NavigationIndicator` should not be used based on M3 specs and observed native Android widget behavior.

Also in `_NavigationDestinationSemantics` the `Stack` alignment becomes `AlignmentDirectional.centerStart`, instead of `Alignment.center`:

```dart
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: <Widget>[
``` 

</details>


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
import 'package:flutter/foundation.dart';
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
ThemeData theme(ThemeMode mode, ThemeSettings settings) {
  return ThemeData(
    colorScheme: mode == ThemeMode.light ? schemeLight : schemeDark,
    useMaterial3: settings.useMaterial3,
    visualDensity: VisualDensity.standard,
    navigationDrawerTheme: NavigationDrawerThemeData(
      indicatorSize: settings.useIndicatorWidth ? const Size(150, 56) : null,
      tileHeight: settings.useTileHeight ? 70 : null,
    ),
    drawerTheme: DrawerThemeData(
      width: settings.useDrawerWidth ? 250 : null,
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
  ThemeMode themeMode = ThemeMode.light;
  bool longLabel = false;
  TextDirection textDirection = TextDirection.ltr;
  ThemeSettings settings = const ThemeSettings(
    useMaterial3: true,
    useDrawerWidth: false,
    useIndicatorWidth: false,
    useTileHeight: false,
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
          drawer: NavigationDrawerShowcase(longLabel: longLabel),
          appBar: AppBar(
            title: const Text('NavigationDrawer Umbrella Issues'),
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
          '    1) Indicator is centered when sized.\n'
              '    2) Ink size does not follow indicator size.\n'
              '    3) Ink effects do not follow M3 spec.\n'
              '    4) Ink effect colors cannot be changed.\n'
              '    5) Drawer size change animation overflows\n'
              '    6) Label is not truncated to fit',
        ),
        SwitchListTile(
          title: const Text('Custom indicator width'),
          subtitle: const Text('ON: 150dp, OFF: default (null)'),
          value: settings.useIndicatorWidth,
          onChanged: (bool value) {
            onSettings(settings.copyWith(useIndicatorWidth: value));
          },
        ),
        SwitchListTile(
          title: const Text('Custom Drawer width'),
          subtitle: const Text('ON: 250dp, OFF: default (null)'),
          value: settings.useDrawerWidth,
          onChanged: (bool value) {
            onSettings(settings.copyWith(useDrawerWidth: value));
          },
        ),
        SwitchListTile(
          title: const Text('Use custom tile height'),
          subtitle: const Text('ON: 70dp, OFF: default (null)'),
          value: settings.useTileHeight,
          onChanged: (bool value) {
            onSettings(settings.copyWith(useTileHeight: value));
          },
        ),
        SwitchListTile(
          title: const Text('Use a long Folder label'),
          value: longLabel,
          onChanged: (bool value) {
            onLongLabel(value);
          },
        ),
        SwitchListTile(
          title: const Text('Text directionality'),
          subtitle: const Text('OFF=LTR, ON=RTL Used later to test menu '
              'indicator works correctly in both modes.'),
          value: textDirection == TextDirection.rtl,
          onChanged: (bool value) {
            value
                ? onTextDirection(TextDirection.rtl)
                : onTextDirection(TextDirection.ltr);
          },
        ),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: DrawerDesktopWrapper(longLabel: longLabel),
        ),
        const SizedBox(height: 16),
        const ShowColorSchemeColors(),
      ],
    );
  }
}

class DrawerDesktopWrapper extends StatelessWidget {
  const DrawerDesktopWrapper({Key? key, this.longLabel = false})
      : super(key: key);
  final bool longLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          removeTop: true,
          removeLeft: true,
          removeRight: true,
          child: SizedBox(
            height: 330,
            child: NavigationDrawerShowcase(longLabel: longLabel),
          ),
        ),
      ],
    );
  }
}

class NavigationDrawerShowcase extends StatefulWidget {
  const NavigationDrawerShowcase({super.key, this.longLabel = false});

  final bool longLabel;

  @override
  State<NavigationDrawerShowcase> createState() =>
      _NavigationDrawerShowcaseState();
}

class _NavigationDrawerShowcaseState extends State<NavigationDrawerShowcase> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      key: widget.key,
      selectedIndex: selectedIndex,
      onDestinationSelected: (int value) {
        setState(() {
          selectedIndex = value;
        });
      },
      children: <Widget>[
        const SizedBox(height: 16),
        // theme.brightness == Brightness.light
        //     ? const Text('Light theme')
        //     : const Text('Dark theme'),
        const NavigationDrawerDestination(
          icon: Badge(
            label: Text('26'),
            child: Icon(Icons.chat_bubble_outline),
          ),
          selectedIcon: Badge(
            label: Text('26'),
            child: Icon(Icons.chat_bubble),
          ),
          label: Text('Chat'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.beenhere_outlined),
          selectedIcon: Icon(Icons.beenhere),
          label: Text('Tasks'),
        ),
        const Divider(),
        NavigationDrawerDestination(
          icon: const Icon(Icons.create_new_folder_outlined),
          selectedIcon: const Icon(Icons.create_new_folder),
          label: widget.longLabel
              ? const Text('Folder with a very long name')
              : const Text('Folder'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: Text('Settings'),
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
  final bool useDrawerWidth;
  final bool useIndicatorWidth;
  final bool useTileHeight;

  const ThemeSettings({
    required this.useMaterial3,
    required this.useDrawerWidth,
    required this.useIndicatorWidth,
    required this.useTileHeight,
  });

  /// Flutter debug properties override, includes toString.
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('useMaterial3', useMaterial3));
    properties.add(DiagnosticsProperty<bool>('useDrawerWidth', useDrawerWidth));
    properties
        .add(DiagnosticsProperty<bool>('useIndicatorWidth', useIndicatorWidth));
    properties.add(DiagnosticsProperty<bool>('useTileHeight', useTileHeight));
  }

  /// Copy the object with one or more provided properties changed.
  ThemeSettings copyWith({
    bool? useMaterial3,
    bool? useDrawerWidth,
    bool? useIndicatorWidth,
    bool? useTileHeight,
  }) {
    return ThemeSettings(
      useMaterial3: useMaterial3 ?? this.useMaterial3,
      useDrawerWidth: useDrawerWidth ?? this.useDrawerWidth,
      useIndicatorWidth: useIndicatorWidth ?? this.useIndicatorWidth,
      useTileHeight: useTileHeight ?? this.useTileHeight,
    );
  }

  /// Override the equality operator.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ThemeSettings &&
        other.useMaterial3 == useMaterial3 &&
        other.useDrawerWidth == useDrawerWidth &&
        other.useIndicatorWidth == useIndicatorWidth &&
        other.useTileHeight == useTileHeight;
  }

  /// Override for hashcode, dart.ui Jenkins based.
  @override
  int get hashCode => Object.hashAll(<Object?>[
    useMaterial3.hashCode,
    useDrawerWidth.hashCode,
    useIndicatorWidth.hashCode,
    useTileHeight.hashCode,
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

Channel master, 3.9.0-17.0.pre.27

<details>
  <summary>Flutter doctor</summary>

```
 flutter doctor -v          
[✓] Flutter (Channel master, 3.9.0-17.0.pre.27, on macOS 13.2.1 22D68 darwin-arm64, locale en-US)
    • Flutter version 3.9.0-17.0.pre.27 on channel master at /Users/rydmike/fvm/versions/master
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision 4a1002e2e2 (43 minutes ago), 2023-03-26 22:55:12 +0200
    • Engine revision 685fbc6f4d
    • Dart version 3.0.0 (build 3.0.0-366.0.dev)
    • DevTools version 2.22.2
    • If those were intentional, you can disregard the above warnings; however it is recommended
      to use "git" directly to perform update checks and upgrades.

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
