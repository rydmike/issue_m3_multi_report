// MIT License
//
// Copyright (c) 2022 Mike Rydstrom
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

// App breakpoints
const double phoneWidthBreakpoint = 550;
const double phoneHeightBreakpoint = 600;

// Used as M3 seed color, the M3 baseline generating seed color.
// This color is also used for the TextField spec examples.
const Color seedColor = Color(0xFF6750A4);

// Make a seed generated M3 light mode ColorScheme.
final ColorScheme myLightScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: seedColor,
);

// Make a seed generated M3 light mode ColorScheme.
final ColorScheme myDarkScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: seedColor,
);

// A simple custom theme
ThemeData myTheme(Brightness mode) => ThemeData.from(
      colorScheme: mode == Brightness.light ? myLightScheme : myDarkScheme,
      useMaterial3: true,
    ).copyWith(
      // Use standard so desktop sizes matches mobile for this example.
      visualDensity: VisualDensity.standard,
    );

void main() {
  runApp(const TextFieldDemoApp());
}

class TextFieldDemoApp extends StatefulWidget {
  const TextFieldDemoApp({super.key});

  @override
  State<TextFieldDemoApp> createState() => _TextFieldDemoAppState();
}

class _TextFieldDemoAppState extends State<TextFieldDemoApp> {
  bool useMaterial3 = false;
  ThemeMode themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: myTheme(Brightness.light),
      darkTheme: myTheme(Brightness.dark),
      themeMode: ThemeMode.light, // Did not make dark theme for Chip example.
      home: SelectionArea(
        child: Scaffold(
          appBar: AppBar(title: const Text(('Chip Issues'))),
          body: const HomePage(),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 8),
        Text(
          'Four Material 3 Chip Spec Compliance Issues',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Using ThemeData with Material 3 and'),
        ),
        const ShowColorSchemeColors(),
        const SizedBox(height: 16),
        const ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('ISSUE 1: No Ink Splash on actionable colored Chips'),
          subtitle: Text('Only actionable transparent Chips have splash ink. '
              'Material 3 Design spec shows ink on all actionable Chips.\n'
              'Below compare e.g. ActionChip with manually Widget colored '
              'ActionChip or Themed selected FilterChip and InputChip to '
              'their none selected versions.\n'
              'Currently Ink only works on transparent Chips with no '
              'color applied. The Material 3 guide spec for Chips show '
              'them all having Ink pressed states.\n'
              'See: https://m3.material.io/components/chips/specs \n'),
        ),
        const ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('ISSUE 2: Missing state elevations'),
          subtitle: Text('The Material 3 spec show Chips with different '
              'elevation states for unselected, selected, focused, hovered, '
              'disabled and dragged, and combinations of them. Current '
              'implementation has no such effects, they are all at M3 level 0\n'
              'see: https://m3.material.io/components/chips/specs \n'),
        ),
        const ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('ISSUE 3: Wrong selected and disabled InputChip color'),
          subtitle: Text('Based on M3 Guide spec the disabled selected Input '
              'should have same grey-tinted background as FilterChip. It is '
              'now selected colored with only disabled text and border '
              'colors.\n'
              'See: https://m3.material.io/components/chips/specs#b411b902-6981-4b79-ba15-310ad6fb4234'),
        ),
        const SizedBox(height: 16),
        const ChipShowcase(),
        const SizedBox(height: 32),
        Theme(
          data: Theme.of(context).copyWith(
              chipTheme: ChipTheme.of(context).copyWith(
            backgroundColor: Colors.yellow[100],
            selectedColor: Colors.lightBlue[100],
            secondarySelectedColor: Colors.teal[100],
            disabledColor: Colors.grey[400],
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Using above ThemeData and'),
              ),
              ShowChipColors(),
              SizedBox(height: 32),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('ISSUE 4: Cannot theme color of SELECTED DISABLED '
                    'ChoiceChip, FilterChip and InputChip'),
                subtitle: Text(
                    'It is not possible to via theme adjust themed colors '
                    'of SELECTED and DISABLED FilterChip and InputChip '
                    'due to missing `disabledSelectedColor` property.\n'
                    'Likewise for SELECTED and DISABLED ChoiceChip, due to '
                    'missing `disabledSecondarySelectedColor` property.\n'
                    'This makes it IMPOSSIBLE to with theming recreate the '
                    'Material 3 spec styled Chips (using none default colors), '
                    'where selected disabled '
                    'Chips should have a given tinted gray background, since '
                    'as soon as you give them a themed color, their '
                    'disabled state also uses that color.\n\n'
                    'Similar theming gaps exist regarding individual control '
                    'of different Chip foreground colors and their '
                    'disabled versions.'),
              ),
              SizedBox(height: 16),
              ChipShowcase(),
            ],
          ),
        )
      ],
    );
  }
}

class ChipShowcase extends StatelessWidget {
  const ChipShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        Chip(
          label: const Text('Chip'),
          onDeleted: () {},
        ),
        const Chip(
          label: Text('Chip'),
          avatar: FlutterLogo(),
        ),
        ActionChip(
          label: const Text('ActionChip'),
          avatar: const Icon(Icons.settings),
          onPressed: () {},
        ),
        ActionChip(
          label: const Text('ActionChip using WidgetColor'),
          avatar: const Icon(Icons.settings),
          backgroundColor: Colors.purple[100],
          onPressed: () {},
        ),
        const ActionChip(
          label: Text('ActionChip'),
          avatar: Icon(Icons.settings),
          onPressed: null,
        ),
        FilterChip(
          label: const Text('FilterChip'),
          selected: true,
          onSelected: (bool value) {},
        ),
        const FilterChip(
          label: Text('FilterChip'),
          selected: true,
          onSelected: null,
        ),
        FilterChip(
          label: const Text('FilterChip'),
          selected: false,
          onSelected: (bool value) {},
        ),
        const FilterChip(
          label: Text('FilterChip'),
          selected: false,
          onSelected: null,
        ),
        ChoiceChip(
          label: const Text('ChoiceChip'),
          selected: true,
          onSelected: (bool value) {},
        ),
        const ChoiceChip(
          label: Text('ChoiceChip'),
          selected: true,
        ),
        ChoiceChip(
          label: const Text('ChoiceChip'),
          selected: false,
          onSelected: (bool value) {},
        ),
        const ChoiceChip(
          label: Text('ChoiceChip'),
          selected: false,
          onSelected: null,
        ),
        InputChip(
          selected: true,
          label: const Text('InputChip'),
          onSelected: (bool value) {},
          onDeleted: () {},
        ),
        InputChip(
          selected: true,
          label: const Text('InputChip'),
          isEnabled: false,
          onSelected: (bool value) {},
          onDeleted: () {},
        ),
        InputChip(
          label: const Text('InputChip'),
          onSelected: (bool value) {},
          onDeleted: () {},
        ),
        InputChip(
          label: const Text('InputChip'),
          isEnabled: false,
          onSelected: (bool value) {},
          onDeleted: () {},
          // onDeleted: () {},
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

  // Return true if the color is dark, meaning it needs light text for contrast.
  static bool _isDark(final Color color) =>
      ThemeData.estimateBrightnessForColor(color) == Brightness.dark;

  // On color used when a theme color property does not have a theme onColor.
  static Color _onColor(final Color color, final Color bg) =>
      _isLight(Color.alphaBlend(color, bg)) ? Colors.black : Colors.white;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDark = colorScheme.brightness == Brightness.dark;
    final bool useMaterial3 = theme.useMaterial3;

    final MediaQueryData media = MediaQuery.of(context);
    final bool isPhone = media.size.width < phoneWidthBreakpoint ||
        media.size.height < phoneHeightBreakpoint;
    final double spacing = isPhone ? 3 : 6;

    // Grab the card border from the theme card shape
    ShapeBorder? border = theme.cardTheme.shape;
    // If we had one, copy in a border side to it.
    if (border is RoundedRectangleBorder) {
      border = border.copyWith(
        side: BorderSide(
          color: theme.dividerColor,
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
          color: theme.dividerColor,
          width: 1,
        ),
      );
    }

    // Get effective background color.
    final Color background =
        onBackgroundColor ?? theme.cardTheme.color ?? theme.cardColor;

    // Warning label for scaffold background when it uses to much blend.
    final String surfaceTooHigh = isDark
        ? _isLight(theme.colorScheme.surface)
            ? '\nTOO HIGH'
            : ''
        : _isDark(theme.colorScheme.surface)
            ? '\nTOO HIGH'
            : '';

    // Warning label for scaffold background when it uses to much blend.
    final String backTooHigh = isDark
        ? _isLight(theme.colorScheme.background)
            ? '\nTOO HIGH'
            : ''
        : _isDark(theme.colorScheme.background)
            ? '\nTOO HIGH'
            : '';

    // Wrap this widget branch in a custom theme where card has a border outline
    // if it did not have one, but retains in ambient themed border radius.
    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: CardTheme.of(context).copyWith(
          elevation: 0,
          shape: border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'ColorScheme Colors (M3 Baseline colors)',
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
                label: 'Background$backTooHigh',
                color: colorScheme.background,
                textColor: colorScheme.onBackground,
              ),
              ColorCard(
                label: 'on\nBackground',
                color: colorScheme.onBackground,
                textColor: colorScheme.background,
              ),
              ColorCard(
                label: 'Surface$surfaceTooHigh',
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
              // ColorCard(
              //   label: 'Outline\nVariant',
              //   color: colorScheme.outlineVariant,
              //   textColor: colorScheme.onBackground,
              // ),
              ColorCard(
                label: 'Shadow',
                color: colorScheme.shadow,
                textColor: _onColor(colorScheme.shadow, background),
              ),
              // ColorCard(
              //   label: 'Scrim',
              //   color: colorScheme.scrim,
              //   textColor: _onColor(colorScheme.scrim, background),
              // ),
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

/// Draw a number of boxes showing the colors of key theme color properties
/// in the ChipTheme of the inherited ThemeData and its color properties.
class ShowChipColors extends StatelessWidget {
  const ShowChipColors({super.key, this.onBackgroundColor});

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
    final bool useMaterial3 = theme.useMaterial3;

    final MediaQueryData media = MediaQuery.of(context);
    final bool isPhone = media.size.width < phoneWidthBreakpoint ||
        media.size.height < phoneHeightBreakpoint;
    final double spacing = isPhone ? 3 : 6;

    // Grab the card border from the theme card shape
    ShapeBorder? border = theme.cardTheme.shape;
    // If we had one, copy in a border side to it.
    if (border is RoundedRectangleBorder) {
      border = border.copyWith(
        side: BorderSide(
          color: theme.dividerColor,
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
          color: theme.dividerColor,
          width: 1,
        ),
      );
    }

    // Get effective background color.
    final Color background =
        onBackgroundColor ?? theme.cardTheme.color ?? theme.cardColor;

    // Wrap this widget branch in a custom theme where card has a border outline
    // if it did not have one, but retains in ambient themed border radius.
    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: CardTheme.of(context).copyWith(
          elevation: 0,
          shape: border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'ChipTheme Colors',
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
                label: 'background\nColor',
                color: theme.chipTheme.backgroundColor!,
                textColor:
                    _onColor(theme.chipTheme.backgroundColor!, background),
              ),
              ColorCard(
                label: 'disabled\nColor',
                color: theme.chipTheme.disabledColor!,
                textColor: _onColor(theme.chipTheme.disabledColor!, background),
              ),
              ColorCard(
                label: 'selected\nColor',
                color: theme.chipTheme.selectedColor!,
                textColor: _onColor(theme.chipTheme.selectedColor!, background),
              ),
              ColorCard(
                label: 'secondary\nSelected\nColor',
                color: theme.chipTheme.secondarySelectedColor!,
                textColor: _onColor(
                    theme.chipTheme.secondarySelectedColor!, background),
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
