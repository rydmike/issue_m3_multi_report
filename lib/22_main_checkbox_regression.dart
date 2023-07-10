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

// This issue reported here: https://github.com/flutter/flutter/issues/130295

// ***************************************************************************
// THESE styling constants and functions below are not important for the issue
// I just usd them as a real example of the syles created by this use case

/// The amount of alpha based opacity used on tinted disabled effect.
///
/// Same value as used on focused opacity on controls in M3, given as alpha.
///
/// Value: 0x61 = 97 = 38.04%
const int kAlphaDisabled = 0x61;

/// Unselected colored Checkbox, Radio alpha value.
///
/// Value: 0xDD = 221 = 86.67%
const int kAlphaUnselect = 0xDD;

/// The amount of alpha based opacity used on tinted hover effect.
///
/// Same value as used on Hover opacity on controls in M3, given as alpha.
///
/// Value: 0x14 = 20 = 8%
const int kAlphaHovered = 0x14;

/// The amount of alpha based opacity used on tinted focus effect.
///
/// Same value as used on focused opacity on controls in M3, given as alpha.
///
/// Value: 0x1F = 31 = 12.16%
const int kAlphaFocused = 0x1F;

/// The amount of alpha based opacity used on tinted pressed effect.
///
/// Same value as used on pressed opacity on controls in M3, given as alpha.
///
/// Value: 0x1F = 31 = 12.16%
const int kAlphaPressed = 0x1F;

/// The amount of alpha blend used on tinted hover effect that is blended
/// into overlay color.
///
/// Value: 0x99 = 153 = 60%
const int kTintHover = 0x99;

/// The amount of alpha blend used on tinted disabled effect that is blended
/// into overlay color.
///
/// Value: 0x66 = 102 = 40%
const int kTintDisabled = 0x66;

/// The amount of alpha blend used on tinted pressed effect that is blended
/// into overlay color.
///
/// Value: 0xA5 = 165 = 65%
const int kTintPressed = 0xA5;

/// The amount of alpha blend used on tinted focus effect that is blended
/// into overlay color.
///
/// Value: 0xB2 = 178 = 70%
const int kTintFocus = 0xB2;

extension FlexColorExtensions on Color {
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

/// Returns the FCS opinionated tinted disabled color on an overlay color.
///
/// Typically the primary color is the color used as tint base.
/// The tint effect is different for light and dark mode.
Color tintedDisabled(Color overlay, Color tint) =>
// Tint color alpha blend into overlay #66=40%
// Opacity of result #61=38%, same as M3 opacity on disable.
    overlay.blendAlpha(tint, kTintDisabled).withAlpha(kAlphaDisabled);

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

// END of not ISSUE relevant styling constants and functions.
// ***************************************************************************

// A seed color for the M3 ColorScheme.
const Color seedColor = Color(0xFF2E747D); // Color(0xFF6750A4);

// Example theme
ThemeData theme(Brightness brightness, ThemeSettings settings) {
  // Make M3 ColorSchemes from a seed color.
  final ColorScheme colorScheme = ColorScheme.fromSeed(
    brightness: brightness,
    seedColor: seedColor,
  );
  final bool useM3 = settings.useMaterial3;
  final bool isLight = brightness == Brightness.light;
  final bool useCustomCheck = settings.customCheck;
  final bool coloredUnselected = settings.coloredUnselected;
  final bool tintedDisable = settings.tintedDisable;
  final bool tintedInteract = settings.tintedInteraction;
  final Color baseColor = colorScheme.primary;
  final Color onBaseColor = colorScheme.onPrimary;

  // Using these tinted overlay variable in all themes for ease of
  // reasoning and duplication.
  final Color overlay = colorScheme.surface;
  final Color tint = baseColor;
  final double factor = tintAlphaFactor(tint, colorScheme.brightness, true);

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: settings.useMaterial3,
    visualDensity: VisualDensity.standard,
    checkboxTheme: useCustomCheck
        ? CheckboxThemeData(
            checkColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (useM3) {
                  if (states.contains(MaterialState.disabled)) {
                    if (states.contains(MaterialState.selected)) {
                      return colorScheme.surface;
                    }
                    return Colors.transparent;
                  }
                  if (states.contains(MaterialState.selected)) {
                    if (states.contains(MaterialState.error)) {
                      return colorScheme.onError;
                    }
                    return onBaseColor;
                  }
                  return Colors.transparent;
                } else {
                  if (states.contains(MaterialState.disabled)) {
                    return isLight
                        ? Colors.grey.shade200
                        : Colors.grey.shade900;
                  }
                  if (states.contains(MaterialState.selected)) {
                    return onBaseColor;
                  }
                  return isLight ? Colors.grey.shade50 : Colors.grey.shade400;
                }
              },
            ),
            fillColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (useM3) {
                  if (states.contains(MaterialState.disabled)) {
                    if (tintedDisable) {
                      return tintedDisabled(colorScheme.onSurface, baseColor);
                    }
                    return colorScheme.onSurface.withAlpha(kAlphaDisabled);
                  }
                  if (states.contains(MaterialState.error)) {
                    return colorScheme.error;
                  }
                  if (states.contains(MaterialState.selected)) {
                    return baseColor;
                  }
                  if (states.contains(MaterialState.pressed)) {
                    if (coloredUnselected) return baseColor;
                    return colorScheme.onSurface;
                  }
                  if (states.contains(MaterialState.hovered)) {
                    if (coloredUnselected) return baseColor;
                    return colorScheme.onSurface;
                  }
                  if (states.contains(MaterialState.focused)) {
                    if (coloredUnselected) return baseColor;
                    return colorScheme.onSurface;
                  }
                  if (coloredUnselected) {
                    return baseColor.withAlpha(kAlphaUnselect);
                  }
                  return colorScheme.onSurfaceVariant;
                } else {
                  if (states.contains(MaterialState.disabled)) {
                    if (tintedDisable) {
                      return tintedDisabled(colorScheme.onSurface, baseColor);
                    }
                    return isLight
                        ? Colors.grey.shade400
                        : Colors.grey.shade800;
                  }
                  if (states.contains(MaterialState.selected)) {
                    return baseColor;
                  }
                  // Opinionated color on unselected checkbox.
                  if (coloredUnselected) {
                    return baseColor.withAlpha(kAlphaUnselect);
                  }
                  // This is M2 SDK default.
                  return isLight ? Colors.black54 : Colors.white70;
                }
              },
            ),
            overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                // Error state only exists in M3 mode.
                if (states.contains(MaterialState.error) && useM3) {
                  if (states.contains(MaterialState.pressed)) {
                    return colorScheme.error.withAlpha(kAlphaPressed);
                  }
                  if (states.contains(MaterialState.hovered)) {
                    return colorScheme.error.withAlpha(kAlphaHovered);
                  }
                  if (states.contains(MaterialState.focused)) {
                    return colorScheme.error.withAlpha(kAlphaFocused);
                  }
                }
                if (states.contains(MaterialState.selected)) {
                  if (states.contains(MaterialState.pressed)) {
                    if (tintedInteract) {
                      return tintedPressed(overlay, tint, factor);
                    }
                    return colorScheme.onSurface.withAlpha(kAlphaPressed);
                  }
                  if (states.contains(MaterialState.hovered)) {
                    if (tintedInteract) {
                      return tintedHovered(overlay, tint, factor);
                    }
                    return baseColor.withAlpha(kAlphaHovered);
                  }
                  if (states.contains(MaterialState.focused)) {
                    if (tintedInteract) {
                      return tintedFocused(overlay, tint, factor);
                    }
                    return baseColor.withAlpha(kAlphaFocused);
                  }
                  return Colors.transparent;
                }
                if (states.contains(MaterialState.pressed)) {
                  if (tintedInteract) {
                    return tintedPressed(overlay, tint, factor);
                  }
                  return baseColor.withAlpha(kAlphaPressed);
                }
                if (states.contains(MaterialState.hovered)) {
                  if (tintedInteract) {
                    return tintedHovered(overlay, tint, factor);
                  }
                  return colorScheme.onSurface.withAlpha(kAlphaHovered);
                }
                if (states.contains(MaterialState.focused)) {
                  if (tintedInteract) {
                    return tintedFocused(overlay, tint, factor);
                  }
                  return colorScheme.onSurface.withAlpha(kAlphaFocused);
                }
                return Colors.transparent;
              },
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
  ThemeSettings settings = const ThemeSettings(
    useMaterial3: true,
    customCheck: false,
    tintedDisable: false,
    tintedInteraction: false,
    coloredUnselected: false,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: theme(Brightness.light, settings),
      darkTheme: theme(Brightness.dark, settings),
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: settings.useMaterial3
              ? const Text('Checkbox regression (M3)')
              : const Text('Checkbox regression (M2)'),
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
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.settings,
    required this.onSettings,
  });

  final ThemeSettings settings;
  final ValueChanged<ThemeSettings> onSettings;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool? isSelected1 = true;
  bool? isSelected2;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Checkbox regression by '
            'PR https://github.com/flutter/flutter/pull/125643.',
          ),
        ),
        const Divider(),
        SwitchListTile(
          title: const Text('Enable custom Checkbox theme'),
          value: widget.settings.customCheck,
          onChanged: (bool value) {
            widget.onSettings(widget.settings.copyWith(customCheck: value));
          },
        ),
        SwitchListTile(
          title: const Text('Checkbox theme with tinted interactions'),
          value: widget.settings.customCheck
              ? widget.settings.tintedInteraction
              : false,
          onChanged: widget.settings.customCheck
              ? (bool value) {
                  widget.onSettings(
                      widget.settings.copyWith(tintedInteraction: value));
                }
              : null,
        ),
        SwitchListTile(
          title: const Text('Checkbox theme with tinted disabled states'),
          value: widget.settings.customCheck
              ? widget.settings.tintedDisable
              : false,
          onChanged: widget.settings.customCheck
              ? (bool value) {
                  widget.onSettings(
                      widget.settings.copyWith(tintedDisable: value));
                }
              : null,
        ),
        SwitchListTile(
          title: const Text('Checkbox theme with colored unselected outline'),
          value: widget.settings.customCheck
              ? widget.settings.coloredUnselected
              : false,
          onChanged: widget.settings.customCheck
              ? (bool value) {
                  widget.onSettings(
                      widget.settings.copyWith(coloredUnselected: value));
                }
              : null,
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            const SizedBox(width: 8),
            const Text('Themed Checkbox: '),
            Checkbox(
              value: isSelected1,
              onChanged: (bool? value) {
                setState(() {
                  isSelected1 = value;
                });
              },
            ),
            Checkbox(
              tristate: true,
              value: isSelected2,
              onChanged: (bool? value) {
                setState(() {
                  isSelected2 = value;
                });
              },
            ),
            Checkbox(
              value: false,
              onChanged: (bool? value) {},
            ),
            const Checkbox(
              value: true,
              onChanged: null,
            ),
            const Checkbox(
              value: null,
              tristate: true,
              onChanged: null,
            ),
            const Checkbox(
              value: false,
              onChanged: null,
            ),
          ],
        ),
        const Divider(),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ShowColorSchemeColors(),
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
  final bool customCheck;
  final bool tintedInteraction;
  final bool tintedDisable;
  final bool coloredUnselected;

  const ThemeSettings({
    required this.useMaterial3,
    required this.customCheck,
    required this.tintedInteraction,
    required this.tintedDisable,
    required this.coloredUnselected,
  });

  /// Flutter debug properties override, includes toString.
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('useMaterial3', useMaterial3));
    properties.add(DiagnosticsProperty<bool>('customCheckTheme', customCheck));
    properties
        .add(DiagnosticsProperty<bool>('tintedInteraction', tintedInteraction));
    properties.add(DiagnosticsProperty<bool>('tintedDisable', tintedDisable));
    properties.add(
        DiagnosticsProperty<bool>('customCheckUnselected', coloredUnselected));
  }

  /// Copy the object with one or more provided properties changed.
  ThemeSettings copyWith({
    bool? useMaterial3,
    bool? customCheck,
    bool? tintedInteraction,
    bool? tintedDisable,
    bool? coloredUnselected,
  }) {
    return ThemeSettings(
      useMaterial3: useMaterial3 ?? this.useMaterial3,
      customCheck: customCheck ?? this.customCheck,
      tintedInteraction: tintedInteraction ?? this.tintedInteraction,
      tintedDisable: tintedDisable ?? this.tintedDisable,
      coloredUnselected: coloredUnselected ?? this.coloredUnselected,
    );
  }

  /// Override the equality operator.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ThemeSettings &&
        other.useMaterial3 == useMaterial3 &&
        other.customCheck == customCheck &&
        other.tintedInteraction == tintedInteraction &&
        other.tintedDisable == tintedDisable &&
        other.coloredUnselected == coloredUnselected;
  }

  /// Override for hashcode, dart.ui Jenkins based.
  @override
  int get hashCode => Object.hashAll(<Object?>[
        useMaterial3.hashCode,
        customCheck.hashCode,
        tintedInteraction.hashCode,
        tintedDisable.hashCode,
        coloredUnselected.hashCode,
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
