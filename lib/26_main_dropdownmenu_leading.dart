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
const Color seedColor = Color(0xFF2E747D);

// Input decoration to demonstrate hover/focus issue clearly.
const InputDecorationTheme inputDecoration = InputDecorationTheme(
  filled: true,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
);

// Example theme
ThemeData theme(Brightness brightness, ThemeSettings settings) {
  // Make M3 ColorSchemes from a seed color.
  final ColorScheme colorScheme = ColorScheme.fromSeed(
    brightness: brightness,
    seedColor: seedColor,
  );
  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: settings.useMaterial3,
    visualDensity: VisualDensity.standard,
    inputDecorationTheme: settings.customTheme ? inputDecoration : null,
    dropdownMenuTheme: settings.customTheme
        ? DropdownMenuThemeData(
            textStyle: settings.useMaterial3
                ? const TextStyle(fontSize: 16)
                : const TextStyle(fontSize: 14),
            inputDecorationTheme: inputDecoration,
          )
        : null,
    menuButtonTheme: const MenuButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 12)),
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
  ThemeMode themeMode = ThemeMode.light;
  ThemeSettings settings = const ThemeSettings(
    useMaterial3: true,
    customTheme: false,
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
              ? const Text('DropdownMenu (M3)')
              : const Text('DropdownMenu (M2)'),
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
  String selectedItem = '1 DropdownButtonFormField';

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('DropdownMenu leading icon layout issue.'),
        ),
        const Divider(),
        SwitchListTile(
          title: const Text('Use component theme'),
          value: widget.settings.customTheme,
          onChanged: (bool value) {
            widget.onSettings(widget.settings.copyWith(customTheme: value));
          },
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: TextFieldShowcase(),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownMenu1(explain: true),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownMenu2(explain: true),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownMenu3(
            explain: true,
            expand: widget.settings.customTheme,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: TextFieldShowcase(),
        ),
        const Divider(height: 32),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ShowColorSchemeColors(),
        ),
      ],
    );
  }
}

class DropdownMenu1 extends StatefulWidget {
  const DropdownMenu1({super.key, this.explain = false});
  final bool explain;

  @override
  State<DropdownMenu1> createState() => _DropdownMenu1State();
}

class _DropdownMenu1State extends State<DropdownMenu1> {
  IconData selectedItem = Icons.alarm;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle denseHeader = theme.textTheme.titleMedium!.copyWith(
      fontSize: 13,
    );
    final TextStyle denseBody = theme.textTheme.bodyMedium!
        .copyWith(fontSize: 12, color: theme.textTheme.bodySmall!.color);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.explain)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: Text(
              'DropdownMenu 1',
              style: denseHeader,
            ),
          ),
        if (widget.explain)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: Text(
              'Using leading icon in DropdownMenu.',
              style: denseBody,
            ),
          ),
        DropdownMenu<IconData>(
          initialSelection: selectedItem,
          leadingIcon: Icon(selectedItem),
          onSelected: (IconData? value) {
            setState(() {
              selectedItem = value ?? Icons.alarm;
            });
          },
          dropdownMenuEntries: const <DropdownMenuEntry<IconData>>[
            DropdownMenuEntry<IconData>(
              label: 'Alarm settings',
              value: Icons.alarm,
            ),
            DropdownMenuEntry<IconData>(
              label: 'Disabled settings',
              enabled: false,
              value: Icons.settings,
            ),
            DropdownMenuEntry<IconData>(
              label: 'Cabin overview',
              value: Icons.cabin,
            ),
            DropdownMenuEntry<IconData>(
                label: 'Surveillance view',
                value: Icons.camera_outdoor_rounded),
            DropdownMenuEntry<IconData>(
              label: 'Water alert',
              value: Icons.water_damage,
            ),
          ],
        ),
      ],
    );
  }
}

class DropdownMenu2 extends StatefulWidget {
  const DropdownMenu2({super.key, this.explain = false});
  final bool explain;

  @override
  State<DropdownMenu2> createState() => _DropdownMenu2State();
}

class _DropdownMenu2State extends State<DropdownMenu2> {
  IconData selectedItem = Icons.cabin;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle denseHeader = theme.textTheme.titleMedium!.copyWith(
      fontSize: 13,
    );
    final TextStyle denseBody = theme.textTheme.bodyMedium!
        .copyWith(fontSize: 12, color: theme.textTheme.bodySmall!.color);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.explain)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: Text(
              'DropdownMenu 2',
              style: denseHeader,
            ),
          ),
        if (widget.explain)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: Text(
              'Using leading icon in DropdownMenu and DropdownMenuEntry.',
              style: denseBody,
            ),
          ),
        DropdownMenu<IconData>(
          initialSelection: selectedItem,
          leadingIcon: Icon(selectedItem),
          onSelected: (IconData? value) {
            setState(() {
              selectedItem = value ?? Icons.cabin;
            });
          },
          dropdownMenuEntries: const <DropdownMenuEntry<IconData>>[
            DropdownMenuEntry<IconData>(
              label: 'Alarm settings',
              leadingIcon: Icon(Icons.alarm),
              value: Icons.alarm,
            ),
            DropdownMenuEntry<IconData>(
              label: 'Disabled settings',
              leadingIcon: Icon(Icons.settings),
              enabled: false,
              value: Icons.settings,
            ),
            DropdownMenuEntry<IconData>(
              label: 'Cabin overview',
              leadingIcon: Icon(Icons.cabin),
              value: Icons.cabin,
            ),
            DropdownMenuEntry<IconData>(
                label: 'Surveillance view',
                value: Icons.camera_outdoor_rounded),
            DropdownMenuEntry<IconData>(
              label: 'Water alert',
              leadingIcon: Icon(Icons.water_damage),
              value: Icons.water_damage,
            ),
          ],
        ),
      ],
    );
  }
}

class DropdownMenu3 extends StatefulWidget {
  const DropdownMenu3({super.key, this.explain = false, this.expand = false});
  final bool explain;
  final bool expand;

  @override
  State<DropdownMenu3> createState() => _DropdownMenu3State();
}

class _DropdownMenu3State extends State<DropdownMenu3> {
  IconData selectedItem = Icons.water_damage;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle denseHeader = theme.textTheme.titleMedium!.copyWith(
      fontSize: 13,
    );
    final TextStyle denseBody = theme.textTheme.bodyMedium!
        .copyWith(fontSize: 12, color: theme.textTheme.bodySmall!.color);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.explain)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: Text(
              'DropdownMenu 3',
              style: denseHeader,
            ),
          ),
        if (widget.explain)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: Text(
              'Using leading icon in DropdownMenu and DropdownMenuEntry WITH '
              'an appropriate custom style fix in EACH DropdownMenuEntry.',
              style: denseBody,
            ),
          ),
        LayoutBuilder(builder: (context, constraints) {
          return DropdownMenu<IconData>(
            width: widget.expand ? constraints.maxWidth : null,
            initialSelection: selectedItem,
            leadingIcon: Icon(selectedItem),
            onSelected: (IconData? value) {
              setState(() {
                selectedItem = value ?? Icons.water_damage;
              });
            },
            dropdownMenuEntries: const <DropdownMenuEntry<IconData>>[
              DropdownMenuEntry<IconData>(
                style: ButtonStyle(
                  padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 12)),
                ),
                label: 'Alarm settings',
                leadingIcon: Icon(Icons.alarm),
                value: Icons.alarm,
              ),
              DropdownMenuEntry<IconData>(
                style: ButtonStyle(
                  padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 12)),
                ),
                label: 'Disabled settings',
                leadingIcon: Icon(Icons.settings),
                enabled: false,
                value: Icons.settings,
              ),
              DropdownMenuEntry<IconData>(
                style: ButtonStyle(
                  padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 12)),
                ),
                label: 'Cabin overview',
                leadingIcon: Icon(Icons.cabin),
                value: Icons.cabin,
              ),
              DropdownMenuEntry<IconData>(
                  label: 'Surveillance view',
                  value: Icons.camera_outdoor_rounded),
              DropdownMenuEntry<IconData>(
                style: ButtonStyle(
                  padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 12)),
                ),
                label: 'Water alert',
                leadingIcon: Icon(Icons.water_damage),
                value: Icons.water_damage,
              ),
            ],
          );
        }),
      ],
    );
  }
}

class TextFieldShowcase extends StatefulWidget {
  const TextFieldShowcase({super.key});

  @override
  State<TextFieldShowcase> createState() => _TextFieldShowcaseState();
}

class _TextFieldShowcaseState extends State<TextFieldShowcase> {
  late TextEditingController _textController1;
  bool _errorState1 = false;

  @override
  void initState() {
    super.initState();
    _textController1 = TextEditingController();
  }

  @override
  void dispose() {
    _textController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (String text) {
        setState(() {
          if (text.contains('a') | text.isEmpty) {
            _errorState1 = false;
          } else {
            _errorState1 = true;
          }
        });
      },
      controller: _textController1,
      decoration: InputDecoration(
        hintText: 'Hint: Write something...',
        labelText: 'Enter some text',
        errorText:
            _errorState1 ? "Any entry ut an 'a' will trigger this error" : null,
      ),
    );
  }
}

/// A Theme Settings class to bundle properties we want to modify on our
/// theme interactively.
@immutable
class ThemeSettings with Diagnosticable {
  final bool useMaterial3;
  final bool customTheme;

  const ThemeSettings({
    required this.useMaterial3,
    required this.customTheme,
  });

  /// Flutter debug properties override, includes toString.
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('useMaterial3', useMaterial3));
    properties.add(DiagnosticsProperty<bool>('customCheckTheme', customTheme));
  }

  /// Copy the object with one or more provided properties changed.
  ThemeSettings copyWith({
    bool? useMaterial3,
    bool? customTheme,
  }) {
    return ThemeSettings(
      useMaterial3: useMaterial3 ?? this.useMaterial3,
      customTheme: customTheme ?? this.customTheme,
    );
  }

  /// Override the equality operator.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ThemeSettings &&
        other.useMaterial3 == useMaterial3 &&
        other.customTheme == customTheme;
  }

  /// Override for hashcode, dart.ui Jenkins based.
  @override
  int get hashCode => Object.hashAll(<Object?>[
        useMaterial3.hashCode,
        customTheme.hashCode,
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
