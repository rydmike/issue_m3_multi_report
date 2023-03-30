// NOTE:
//
// Copy the code for the issue sample to test here. It always only contains
// the sample last looked at.

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
import 'package:flutter/services.dart';

// This issue reported here: https://github.com/flutter/flutter/issues/123829

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

  // The actual colors used doe not really matter, there is a lot not needed
  // complexity it tint and overlay calculations in this example. It is
  // irrelevant for the issue. It was just a theme example I had handy.
  final Color foreground = colorScheme.tertiary;
  final Color background = colorScheme.onTertiary;
  final Color overlay = background;
  final Color tint = foreground;
  final double factor = tintAlphaFactor(tint, colorScheme.brightness, true);

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: settings.useMaterial3,
    visualDensity: VisualDensity.standard,
    iconButtonTheme: settings.useCustomTheme
        ? IconButtonThemeData(
            style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.resolveWith((Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return tintedDisable(colorScheme.onSurface, tint)
                    .withAlpha(kAlphaVeryLowDisabled);
              }
              if (states.contains(MaterialState.selected)) {
                return colorScheme.tertiaryContainer;
              }
              return Colors.transparent;
            }),
            foregroundColor:
                MaterialStateProperty.resolveWith((Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return tintedDisable(colorScheme.onSurface, tint);
              }
              if (states.contains(MaterialState.selected)) {
                return colorScheme.onTertiaryContainer;
              }
              return foreground;
            }),
            overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  if (states.contains(MaterialState.pressed)) {
                    return tintedPressed(overlay, tint, factor);
                  }
                  if (states.contains(MaterialState.hovered)) {
                    return tintedHovered(overlay, tint, factor);
                  }
                  if (states.contains(MaterialState.focused)) {
                    return tintedFocused(overlay, tint, factor);
                  }
                  return Colors.transparent;
                }
                if (states.contains(MaterialState.pressed)) {
                  return tintedPressed(overlay, tint, factor);
                }
                if (states.contains(MaterialState.hovered)) {
                  return tintedHovered(overlay, tint, factor);
                }
                if (states.contains(MaterialState.focused)) {
                  return tintedFocused(overlay, tint, factor);
                }
                return Colors.transparent;
              },
            ),
          ))
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
            title: const Text('IconButton Theming Issue'),
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
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      children: <Widget>[
        const SizedBox(height: 8),
        const Text("If we add theming to IconButton's IconButtonThemeData, we "
            'loose the style of all variant IconButtons. They all get the '
            'same style as IconButton.'),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Enable custom IconButton theme'),
          value: settings.useCustomTheme,
          onChanged: (bool value) {
            onSettings(settings.copyWith(useCustomTheme: value));
          },
        ),
        const SizedBox(height: 8),
        const Text('FAIL: All variant IconButtons loose their style:\n'
            '- IconButton.filled\n'
            '- IconButton.filledTonal\n'
            '- IconButton.outlined\n'),
        const IconButtonM3Showcase(),
        const SizedBox(height: 16),
        const ShowColorSchemeColors(),
      ],
    );
  }
}

class IconButtonM3Showcase extends StatelessWidget {
  const IconButtonM3Showcase({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 4,
      children: <Widget>[
        Column(
          // Standard IconButton
          children: <Widget>[
            _IconM3ToggleButton(
              isEnabled: true,
              tooltip: 'Standard',
              variant: _IconButtonVariant.standard,
            ),
            SizedBox(height: 8),
            _IconM3ToggleButton(
              isEnabled: false,
              tooltip: 'Standard (disabled)',
              variant: _IconButtonVariant.standard,
            ),
          ],
        ),
        Column(
          children: <Widget>[
            // Filled IconButton
            _IconM3ToggleButton(
              isEnabled: true,
              tooltip: 'Filled',
              variant: _IconButtonVariant.filled,
            ),
            SizedBox(height: 8),
            _IconM3ToggleButton(
              isEnabled: false,
              tooltip: 'Filled (disabled)',
              variant: _IconButtonVariant.filled,
            ),
          ],
        ),
        Column(
          children: <Widget>[
            // Filled Tonal IconButton
            _IconM3ToggleButton(
              isEnabled: true,
              tooltip: 'Filled tonal',
              variant: _IconButtonVariant.filledTonal,
            ),
            SizedBox(height: 8),
            _IconM3ToggleButton(
              isEnabled: false,
              tooltip: 'Filled tonal (disabled)',
              variant: _IconButtonVariant.filledTonal,
            ),
          ],
        ),
        Column(
          children: <Widget>[
            // Outlined IconButton
            _IconM3ToggleButton(
              isEnabled: true,
              tooltip: 'Outlined',
              variant: _IconButtonVariant.outlined,
            ),
            SizedBox(height: 8),
            _IconM3ToggleButton(
              isEnabled: false,
              tooltip: 'Outlined (disabled)',
              variant: _IconButtonVariant.outlined,
            ),
          ],
        ),
      ],
    );
  }
}

enum _IconButtonVariant { standard, filled, filledTonal, outlined }

class _IconM3ToggleButton extends StatefulWidget {
  const _IconM3ToggleButton({
    required this.isEnabled,
    required this.tooltip,
    required this.variant,
  });

  final bool isEnabled;
  final String tooltip;
  final _IconButtonVariant variant;

  @override
  State<_IconM3ToggleButton> createState() => _IconM3ToggleButtonState();
}

class _IconM3ToggleButtonState extends State<_IconM3ToggleButton> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    final VoidCallback? onPressed = widget.isEnabled
        ? () {
            setState(() {
              selected = !selected;
            });
          }
        : null;

    switch (widget.variant) {
      case _IconButtonVariant.standard:
        {
          return IconButton(
            isSelected: selected,
            tooltip: widget.tooltip,
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            onPressed: onPressed,
          );
        }
      case _IconButtonVariant.filled:
        {
          return IconButton.filled(
            isSelected: selected,
            tooltip: widget.tooltip,
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            onPressed: onPressed,
          );
        }
      case _IconButtonVariant.filledTonal:
        {
          return IconButton.filledTonal(
            isSelected: selected,
            tooltip: widget.tooltip,
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            onPressed: onPressed,
          );
        }
      case _IconButtonVariant.outlined:
        {
          return IconButton.outlined(
            isSelected: selected,
            tooltip: widget.tooltip,
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            onPressed: onPressed,
          );
        }
    }
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

/// Returns the FCS opinionated tinted hover color on an overlay color.
///
/// Typically the primary color is the color used as tint base.
/// The tint effect is different for light and dark mode.
Color tintedHovered(Color overlay, Color tint, [double factor = 1]) {
// Starting kAlphaHover 0x14=20=8%, same as M3 opacity on hover.
  final int usedAlpha = (kAlphaHovered * factor).round().clamp(0x00, 0xFF);
// Tint color alpha blend into overlay kTintHover  0x99=153= 60%
  return overlay.blendAlpha(tint, kTintHover).withAlpha(usedAlpha);
}

/// Returns the FCS opinionated tinted splash color on an overlay color.
///
/// Typically the primary color is the color used as tint base.
/// The tint effect is different for light and dark mode.
Color tintedPressed(Color overlay, Color tint, [double factor = 1]) {
// Starting kAlphaPressed 0x1F = 31 = 12.16%, same as M3 opacity on pressed.
  final int usedAlpha = (kAlphaPressed * factor).round().clamp(0x00, 0xFF);
// Tint color alpha blend into overlay kTintPressed 0xA5 = 165 = 65%
  return overlay.blendAlpha(tint, kTintPressed).withAlpha(usedAlpha);
}

/// Returns the FCS opinionated tinted focus color on an overlay color.
///
/// Typically the primary color is the color used as tint base.
/// The tint effect is different for light and dark mode.
Color tintedFocused(Color overlay, Color tint, [double factor = 1]) {
// Starting kAlphaFocus 0x1F = 31 = 12.16%, same as M3 opacity on focus.
  final int usedAlpha = (kAlphaFocused * factor).round().clamp(0x00, 0xFF);
// Tint color alpha blend into overlay kTintFocus 0xB2 = 178 = 70%.
  return overlay.blendAlpha(tint, kTintFocus).withAlpha(usedAlpha);
}

/// Returns the FCS opinionated tinted disabled color on an overlay color.
///
/// Typically the primary color is the color used as tint base.
/// The tint effect is different for light and dark mode.
Color tintedDisable(Color overlay, Color tint) =>
// Tint color alpha blend into overlay #66=40%
// Opacity of result #61=38%, same as M3 opacity on disable.
    overlay.blendAlpha(tint, kTintDisabled).withAlpha(kAlphaDisabled);

extension ColorExtensions on Color {
  /// Blend in the given input Color with an alpha value.
  ///
  /// You typically apply this on a background color, light or dark
  /// to create a background color with a hint of a color used in a theme.
  ///
  /// This is a use case of the alphaBlend static function that exists in
  /// dart:ui Color. It is used to create the branded surface colors in
  /// FlexColorScheme and to calculate dark scheme colors from light ones,
  /// by blending in white color with light scheme color.
  ///
  /// Defaults to alpha 0x0A alpha blend of the passed in Color value,
  /// which is 10% alpha blend.
  Color blendAlpha(final Color input, [final int alpha = 0x0A]) {
    // Skip blending for impossible value and return the instance color value.
    if (alpha <= 0) return this;
    // Blend amounts >= 255 results in the input Color.
    if (alpha >= 255) return input;
    return Color.alphaBlend(input.withAlpha(alpha), this);
  }
}

/// A factor used by tinted interactions to increase the alpha based
/// opacity Material 3 baseline based opacity values for hover, focus and
/// splash under certain conditions.
///
/// Used by component themes. The factor is different depending on
/// if the color is light or dark. This factor increases the opacity of
/// the overlay color compared to the opacity used by M3 default. It works
/// well because the overlay color is also alpha blend colored. This extra
/// factor is used for interaction effects on colored widgets, when
/// using interactions on surface colors a lower factor is used.
double tintAlphaFactor(Color color, Brightness mode,
    [bool surfaceMode = false]) {
  if (mode == Brightness.light) {
    return surfaceMode
        ? ThemeData.estimateBrightnessForColor(color) == Brightness.dark
            ? 1.5
            : 4.0
        : ThemeData.estimateBrightnessForColor(color) == Brightness.dark
            ? 5.0
            : 2.0;
  } else {
    return surfaceMode
        ? ThemeData.estimateBrightnessForColor(color) == Brightness.dark
            ? 5.0
            : 2.0
        : ThemeData.estimateBrightnessForColor(color) == Brightness.dark
            ? 5.0
            : 4.0;
  }
}

/// The amount of alpha blend used on tinted hover effect that is blended
/// into overlay color.
///
/// Value: 0x99 = 153 = 60%
const int kTintHover = 0x99;

/// The amount of alpha based opacity used on tinted hover effect.
///
/// Same value as used on Hover opacity on controls in M3, given as alpha.
///
/// Value: 0x14 = 20 = 8%
const int kAlphaHovered = 0x14;

/// The amount of alpha blend used on tinted pressed effect that is blended
/// into overlay color.
///
/// Value: 0xA5 = 165 = 65%
const int kTintPressed = 0xA5;

/// The amount of alpha based opacity used on tinted pressed effect.
///
/// Same value as used on pressed opacity on controls in M3, given as alpha.
///
/// Value: 0x1F = 31 = 12.16%
const int kAlphaPressed = 0x1F;

/// The amount of alpha blend used on tinted focus effect that is blended
/// into overlay color.
///
/// Value: 0xB2 = 178 = 70%
const int kTintFocus = 0xB2;

/// The amount of alpha based opacity used on tinted focus effect.
///
/// Same value as used on focused opacity on controls in M3, given as alpha.
///
/// Value: 0x1F = 31 = 12.16%
const int kAlphaFocused = 0x1F;

/// The amount of alpha blend used on tinted disabled effect that is blended
/// into overlay color.
///
/// Value: 0x66 = 102 = 40%
const int kTintDisabled = 0x66;

/// The amount of alpha based opacity used on tinted disabled effect.
///
/// Same value as used on focused opacity on controls in M3, given as alpha.
///
/// Value: 0x61 = 97 = 38.04%
const int kAlphaDisabled = 0x61;

/// An optional lower amount of alpha based opacity used on tinted disabled
/// effect.
///
/// This is used e.g. on disabled M2 switch track color, and M3 disabled track
/// and disabled trackOutline color.
///
/// Value: 0x1F = 31 = 12.16%
const int kAlphaVeryLowDisabled = 0x1F;
