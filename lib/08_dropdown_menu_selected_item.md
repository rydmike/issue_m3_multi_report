## DropdownMenu themed focused item broken

The style indication of the found and focused/selected item in a `DropdownMenu` does not use `MenuButtonThemeData`. Its simulation of the focused state omits the theme.

This makes it impossible to provide a consistent style for the focused/selected item when using a custom theme in a `DropdownMenu`. One have to live with the default style for the entire menu, or accept a deviant and out of style looking focused/selected item.

## Expected results

Expect to be able to theme the found selected item in a `DropdownMenu` to a style where the selected item would match the style of used custom theme, and do so on all hover/focus/pressed themed MaterialState dependent colors.

Consider these on purpose wild looking `MenuThemeData` and `MenuButtonThemeData`, used to visually highlight the functional gaps.

<details>
  <summary>Theme snippet</summary>

(For full code sample, see the **Issue sample code** further below).

```dart
  MenuThemeData(
    style: MenuStyle(
      backgroundColor: MaterialStatePropertyAll<Color?>(colorScheme.errorContainer),
      padding: const MaterialStatePropertyAll<EdgeInsetsGeometry?>(EdgeInsets.all(8)),
    ),
  ),
  MenuButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return colorScheme.primary;
        }
        if (states.contains(MaterialState.hovered)) {
          return colorScheme.primary;
        }
        if (states.contains(MaterialState.focused)) {
          return colorScheme.primaryContainer;
        }
        return Colors.transparent;
      }),
      foregroundColor: MaterialStateProperty.resolveWith(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.38);
        }
        if (states.contains(MaterialState.pressed)) {
          return colorScheme.onPrimary;
        }
        if (states.contains(MaterialState.hovered)) {
          return colorScheme.onPrimary;
        }
        if (states.contains(MaterialState.focused)) {
          return colorScheme.onPrimaryContainer;
        }
        return colorScheme.onSurface;
      }),
      iconColor: MaterialStateProperty.resolveWith(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.38);
        }
        if (states.contains(MaterialState.pressed)) {
          return colorScheme.onPrimary;
        }
        if (states.contains(MaterialState.hovered)) {
          return colorScheme.onPrimary;
        }
        if (states.contains(MaterialState.focused)) {
          return colorScheme.onPrimaryContainer;
        }
        return colorScheme.onSurfaceVariant;
      }),
      overlayColor: MaterialStateProperty.resolveWith(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return colorScheme.onPrimary.withValues(alpha: 0.12);
        }
        if (states.contains(MaterialState.hovered)) {
          return colorScheme.onPrimary.withValues(alpha: 0.08);
        }
        if (states.contains(MaterialState.focused)) {
          return colorScheme.onPrimaryContainer.withValues(alpha: 0.12);
        }
        return Colors.transparent;
      }),
      shape: ButtonStyleButton.allOrNull<OutlinedBorder>(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    ),
  ),
```

</details>

Expect the theme to use above defined MenuButtonThemeData `ButtonStyle` theming and look and behave as shown below:

![Screenshot 2023-03-30 at 1 12 28](https://user-images.githubusercontent.com/39990307/228695749-89395f80-20c6-4d4a-ab48-81b23d2c5bec.png)


https://user-images.githubusercontent.com/39990307/228695784-c44ba365-0174-44a7-8d67-d07a727aef44.mov

## Actual results

Get a style where the **focused** (and selected) item has a style that does not used the themed style, it effectively ignores the theme defined by the `MenuButtonThemeData` theme, concerning its `focused` states for all theme colors.

![Screenshot 2023-03-30 at 2 09 44](https://user-images.githubusercontent.com/39990307/228695835-f474b528-bd89-435b-9c86-ca80095fa346.png)


https://user-images.githubusercontent.com/39990307/228695848-fa1c1675-ff88-483d-9c05-c3b15666ae14.mov

## Discussion

**EDIT:** The accessibility topic found during creation of this issues and included in this discussion topic previously, have on request been moved to its own issues, see https://github.com/flutter/flutter/issues/123797.


## Fix used to demo expected result

An experimental revised and fixed version of `_buildButtons(..)` function from file `dropdown_menu.dart`, used to generate the expected result above is included below for reference.

It may be useful as a starting point for an actual fix. It only patches the current implementation concerning it ignoring the theme. It does not address the discussion part above.

This fix also has the same "hack" feel as the original implementation. It uses knowledge about what the M3 token defaults are for a default `focused` dropdown menu item, as its fallback defaults for the simulated none widget/themed defaults. It does so, since it cannot access the `_MenuButtonDefaultsM3` private class in `menu_anchor.dart`. This is not the first time I have run into a situation where it would be useful to have access to the theme default classes, outside their component class files.

I checked the quick fix below with existing tests in `dropdown_menu_theme_test.dart` and `dropdown_test.dart`. It did not break any existing test in them. Existing tests do not capture this issue because they do not even include any customization of `DropdownMenu` via `MenuButtonThemeData`. The tests rely on that being covered by `MenuItemButton` related tests. Since `DropdownMenu` overrides `MenuItemButton` default behavior, it needs its own tests of those parts to ensure those overrides do not break expected theming features of used `MenuItemButton`.


```dart
List<Widget> _buildButtons(
  List<DropdownMenuEntry<T>> filteredEntries,
  TextEditingController textEditingController,
  TextDirection textDirection,
  { int? focusedIndex }
) {
  final List<Widget> result = <Widget>[];
  final double padding = leadingPadding ?? _kDefaultHorizontalPadding;
  final EdgeInsetsGeometry effectivePadding;
  switch (textDirection) {
    case TextDirection.rtl:
      effectivePadding = EdgeInsets.only(left: _kDefaultHorizontalPadding, right: padding);
    case TextDirection.ltr:
      effectivePadding = EdgeInsets.only(left: padding, right: _kDefaultHorizontalPadding);
  }
  final ThemeData theme = Theme.of(context);
  final ButtonStyle defaultStyle = theme.menuButtonTheme.style?.copyWith(padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(effectivePadding)) ?? MenuItemButton.styleFrom(padding: effectivePadding);

  for (int i = 0; i < filteredEntries.length; i++) {
    final DropdownMenuEntry<T> entry = filteredEntries[i];
    ButtonStyle effectiveStyle = entry.style ?? defaultStyle;
    final Color focusedBackgroundColor = effectiveStyle.backgroundColor?.resolve(<MaterialState>{MaterialState.focused}) ?? theme.colorScheme.onSurface.withValues(alpha: 0.12);
    final Color focusedForegroundColor = effectiveStyle.foregroundColor?.resolve(<MaterialState>{MaterialState.focused}) ?? theme.colorScheme.onSurface;
    final Color focusedIconColor = effectiveStyle.iconColor?.resolve(<MaterialState>{MaterialState.focused}) ?? theme.colorScheme.onSurfaceVariant;
    final Color focusedOverlayColor = effectiveStyle.overlayColor?.resolve(<MaterialState>{MaterialState.focused}) ?? theme.colorScheme.onSurface.withValues(alpha: 0.12);

    // Simulate the focused state because the text field should always be focused
    // during traversal. Include potential MenuItemButton theme in the focus
    // simulation for all colors in the theme.
    effectiveStyle = entry.enabled && i == focusedIndex
      ? effectiveStyle.copyWith(
          backgroundColor: MaterialStatePropertyAll<Color>(focusedBackgroundColor),
          foregroundColor: MaterialStatePropertyAll<Color>(focusedForegroundColor),
          iconColor: MaterialStatePropertyAll<Color>(focusedIconColor),
          overlayColor: MaterialStatePropertyAll<Color>(focusedOverlayColor),
       )
     : effectiveStyle;

    final MenuItemButton menuItemButton = MenuItemButton(
      style: effectiveStyle,
      leadingIcon: entry.leadingIcon,
      trailingIcon: entry.trailingIcon,
      onPressed: entry.enabled
        ? () {
            textEditingController.text = entry.label;
            textEditingController.selection = TextSelection.collapsed(offset: textEditingController.text.length);
            currentHighlight = widget.enableSearch ? i : null;
            widget.onSelected?.call(entry.value);
          }
        : null,
      requestFocusOnHover: false,
      child: Text(entry.label),
    );
    result.add(menuItemButton);
  }

  return result;
}

```

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
  final ColorScheme colorScheme =
      mode == ThemeMode.light ? schemeLight : schemeDark;
  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: settings.useMaterial3,
    visualDensity: VisualDensity.standard,
    menuTheme: settings.useCustomMenu
        ? MenuThemeData(
            style: MenuStyle(
              backgroundColor:
                  MaterialStatePropertyAll<Color?>(colorScheme.errorContainer),
              padding: const MaterialStatePropertyAll<EdgeInsetsGeometry?>(
                EdgeInsets.all(8),
              ),
            ),
          )
        : null,
    menuButtonTheme: settings.useCustomMenu
        ? MenuButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return colorScheme.primary;
                }
                if (states.contains(MaterialState.hovered)) {
                  return colorScheme.primary;
                }
                if (states.contains(MaterialState.focused)) {
                  return colorScheme.primaryContainer;
                }
                return Colors.transparent;
              }),
              foregroundColor: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return colorScheme.onSurface.withValues(alpha: 0.38);
                }
                if (states.contains(MaterialState.pressed)) {
                  return colorScheme.onPrimary;
                }
                if (states.contains(MaterialState.hovered)) {
                  return colorScheme.onPrimary;
                }
                if (states.contains(MaterialState.focused)) {
                  return colorScheme.onPrimaryContainer;
                }
                return colorScheme.onSurface;
              }),
              iconColor: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return colorScheme.onSurface.withValues(alpha: 0.38);
                }
                if (states.contains(MaterialState.pressed)) {
                  return colorScheme.onPrimary;
                }
                if (states.contains(MaterialState.hovered)) {
                  return colorScheme.onPrimary;
                }
                if (states.contains(MaterialState.focused)) {
                  return colorScheme.onPrimaryContainer;
                }
                return colorScheme.onSurfaceVariant;
              }),
              overlayColor: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return colorScheme.onPrimary.withValues(alpha: 0.12);
                }
                if (states.contains(MaterialState.hovered)) {
                  return colorScheme.onPrimary.withValues(alpha: 0.08);
                }
                if (states.contains(MaterialState.focused)) {
                  return colorScheme.onPrimaryContainer.withValues(alpha: 0.12);
                }
                return Colors.transparent;
              }),
              shape: ButtonStyleButton.allOrNull<OutlinedBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
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
    useCustomMenu: true,
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
            title: const Text('DropdownMenu Issue'),
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
        SwitchListTile(
          title: const Text('Text directionality'),
          subtitle: const Text('OFF=LTR  ON=RTL'),
          value: textDirection == TextDirection.rtl,
          onChanged: (bool value) {
            value
                ? onTextDirection(TextDirection.rtl)
                : onTextDirection(TextDirection.ltr);
          },
        ),
        const SizedBox(height: 8),
        const Text('DropdownMenu focused item style broken\n\n'
            'The style indication of the found and selected item in a '
            'DropdownMenu does not use MenuButtonThemeData. Its simulation of '
            'the focused state omits the theme.'),
        SwitchListTile(
          title: const Text('Enable custom menu theme'),
          value: settings.useCustomMenu,
          onChanged: (bool value) {
            onSettings(settings.copyWith(useCustomMenu: value));
          },
        ),
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: DropDownMenuShowcase(),
        ),
        const SizedBox(height: 16),
        const ShowColorSchemeColors(),
      ],
    );
  }
}

class DropDownMenuShowcase extends StatefulWidget {
  const DropDownMenuShowcase({super.key});

  @override
  State<DropDownMenuShowcase> createState() => _DropDownMenuShowcaseState();
}

class _DropDownMenuShowcaseState extends State<DropDownMenuShowcase> {
  String selectedItem = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DropdownMenu<String>(
          initialSelection: selectedItem,
          onSelected: (String? value) {
            setState(() {
              selectedItem = value ?? 'one';
            });
          },
          dropdownMenuEntries: const <DropdownMenuEntry<String>>[
            DropdownMenuEntry<String>(
              label: 'Alarm settings',
              leadingIcon: Icon(Icons.alarm),
              value: 'one',
            ),
            DropdownMenuEntry<String>(
              label: 'Cabin overview',
              leadingIcon: Icon(Icons.cabin),
              value: 'three',
            ),
            DropdownMenuEntry<String>(
              label: 'Surveillance view',
              leadingIcon: Icon(Icons.camera_outdoor_rounded),
              value: 'four',
            ),
            DropdownMenuEntry<String>(
              label: 'Water alert',
              leadingIcon: Icon(Icons.water_damage),
              value: 'five',
            ),
            DropdownMenuEntry<String>(
              label: 'Disabled settings',
              leadingIcon: Icon(Icons.settings),
              value: 'two',
              enabled: false,
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
  final bool useCustomMenu;

  const ThemeSettings({
    required this.useMaterial3,
    required this.useCustomMenu,
  });

  /// Flutter debug properties override, includes toString.
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('useMaterial3', useMaterial3));
    properties.add(DiagnosticsProperty<bool>('useCustomMenu', useCustomMenu));
  }

  /// Copy the object with one or more provided properties changed.
  ThemeSettings copyWith({
    bool? useMaterial3,
    bool? useCustomMenu,
  }) {
    return ThemeSettings(
      useMaterial3: useMaterial3 ?? this.useMaterial3,
      useCustomMenu: useCustomMenu ?? this.useCustomMenu,
    );
  }

  /// Override the equality operator.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ThemeSettings &&
        other.useMaterial3 == useMaterial3 &&
        other.useCustomMenu == useCustomMenu;
  }

  /// Override for hashcode, dart.ui Jenkins based.
  @override
  int get hashCode => Object.hashAll(<Object?>[
        useMaterial3.hashCode,
        useCustomMenu.hashCode,
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

Channel master, 3.9.0-19.0.pre.50

<details>
  <summary>Flutter doctor</summary>

```

flutter doctor -v          
[✓] Flutter (Channel master, 3.9.0-19.0.pre.50, on macOS 13.2.1 22D68 darwin-arm64, locale en-US)
    • Flutter version 3.9.0-19.0.pre.50 on channel master at /Users/rydmike/fvm/versions/master
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision 4e1ad59f75 (61 minutes ago), 2023-03-30 01:06:46 +0200
    • Engine revision 45467e2a8b
    • Dart version 3.0.0 (build 3.0.0-378.0.dev)
    • DevTools version 2.22.2
    • If those were intentional, you can disregard the above warnings; however it is recommended to use "git" directly
      to perform update checks and upgrades.

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
    • Chrome (web)    • chrome • web-javascript • Google Chrome 111.0.5563.146

[✓] Network resources
    • All expected network resources are available.


```

</details>

## Other Issues Related to DropdownMenu and Menus

- [ ] https://github.com/flutter/flutter/issues/123615
- [ ] https://github.com/flutter/flutter/issues/123631
- [ ] https://github.com/flutter/flutter/issues/123797
- [ ] https://github.com/flutter/flutter/issues/123395
- [ ] https://github.com/flutter/flutter/issues/120567
- [ ] https://github.com/flutter/flutter/issues/120349
- [ ] https://github.com/flutter/flutter/issues/119743
