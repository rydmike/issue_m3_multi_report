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

// This issue reported here: https://github.com/flutter/flutter/issues/123797

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
    menuTheme: const MenuThemeData(
      style: MenuStyle(
        padding: WidgetStatePropertyAll<EdgeInsetsGeometry?>(
          EdgeInsets.all(8),
        ),
      ),
    ),
    menuButtonTheme: MenuButtonThemeData(
      style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.primary;
          }
          if (states.contains(WidgetState.hovered)) {
            return colorScheme.primary;
          }
          if (states.contains(WidgetState.focused)) {
            return colorScheme.primaryContainer;
          }
          return Colors.transparent;
        }),
        foregroundColor:
            WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.38);
          }
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.onPrimary;
          }
          if (states.contains(WidgetState.hovered)) {
            return colorScheme.onPrimary;
          }
          if (states.contains(WidgetState.focused)) {
            return colorScheme.onPrimaryContainer;
          }
          return colorScheme.onSurface;
        }),
        iconColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.38);
          }
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.onPrimary;
          }
          if (states.contains(WidgetState.hovered)) {
            return colorScheme.onPrimary;
          }
          if (states.contains(WidgetState.focused)) {
            return colorScheme.onPrimaryContainer;
          }
          return colorScheme.onSurfaceVariant;
        }),
        overlayColor:
            WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.onPrimary.withValues(alpha: 0.12);
          }
          if (states.contains(WidgetState.hovered)) {
            return colorScheme.onPrimary.withValues(alpha: 0.08);
          }
          if (states.contains(WidgetState.focused)) {
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
    useCustomMenu: false,
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
            title: const Text('DropdownMenu Keyboard Accessibility'),
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
      children: const <Widget>[
        SizedBox(height: 8),
        Text('DropdownMenu equals keyboard focus with selection, '
            'this prevents navigating the menu without committing a '
            'selection as well as dismissing the menu and expecting '
            'the state menu selection had when it was opened to be '
            'reset without any selection made. '),
        SizedBox(height: 8),
        Text('FAIL:\n'
            '- DropdownMenu keyboard focus is same as selecting an item\n'
            '- DropdownMenu no has no ESC key to dismiss binding'),
        SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [DropDownMenuShowcase()],
        ),
        SizedBox(height: 16),
        Text('OK:\n'
            'MenuBar and MenuAnchor have ESC dismiss key binding'),
        SizedBox(height: 8),
        MenuBarShowcase(),
        SizedBox(height: 16),
        MenuAnchorContextMenu(message: 'M3 MenuAnchor is cool!'),
        SizedBox(height: 16),
        ShowColorSchemeColors(),
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
    return DropdownMenu<String>(
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
    );
  }
}

class MenuBarShowcase extends StatelessWidget {
  const MenuBarShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuBar(
      children: <Widget>[
        SubmenuButton(
          menuChildren: <Widget>[
            MenuItemButton(
              onPressed: () {
                showAboutDialog(
                  context: context,
                  useRootNavigator: false,
                  applicationName: 'MenuBar Demo',
                  applicationVersion: '1.0.0',
                );
              },
              child: const MenuAcceleratorLabel('&About'),
            ),
            SubmenuButton(
              menuChildren: <Widget>[
                MenuItemButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Saved!'),
                      ),
                    );
                  },
                  child: const MenuAcceleratorLabel('&Save now'),
                ),
                MenuItemButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Load!'),
                      ),
                    );
                  },
                  child: const MenuAcceleratorLabel('&Load now'),
                ),
              ],
              child: const Text('File'),
            ),
            MenuItemButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Quit!'),
                  ),
                );
              },
              child: const MenuAcceleratorLabel('&Quit'),
            ),
          ],
          child: const MenuAcceleratorLabel('&File'),
        ),
        SubmenuButton(
          menuChildren: <Widget>[
            MenuItemButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bold!'),
                  ),
                );
              },
              child: const MenuAcceleratorLabel('&Bold'),
            ),
            MenuItemButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Italic!'),
                  ),
                );
              },
              child: const MenuAcceleratorLabel('&Italic'),
            ),
            MenuItemButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Underline!'),
                  ),
                );
              },
              child: const MenuAcceleratorLabel('&Underline'),
            ),
          ],
          child: const MenuAcceleratorLabel('&Style'),
        ),
        SubmenuButton(
          menuChildren: <Widget>[
            const MenuItemButton(
              onPressed: null,
              child: MenuAcceleratorLabel('&Disabled item'),
            ),
            MenuItemButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Minify!'),
                  ),
                );
              },
              child: const MenuAcceleratorLabel('Mi&nify'),
            ),
          ],
          child: const MenuAcceleratorLabel('&View'),
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

/// An enhanced enum to define the available menus and their shortcuts.
///
/// Using an enum for menu definition is not required, but this illustrates how
/// they could be used for simple menu systems.
enum MenuEntry {
  about('About'),
  showMessage(
      'Show Message', SingleActivator(LogicalKeyboardKey.keyS, control: true)),
  hideMessage(
      'Hide Message', SingleActivator(LogicalKeyboardKey.keyH, control: true)),
  colorMenu('Color Menu'),
  colorRed('Red', SingleActivator(LogicalKeyboardKey.keyR, control: true)),
  colorGreen('Green', SingleActivator(LogicalKeyboardKey.keyG, control: true)),
  colorBlue('Blue', SingleActivator(LogicalKeyboardKey.keyB, control: true));

  const MenuEntry(this.label, [this.shortcut]);
  final String label;
  final MenuSerializableShortcut? shortcut;
}

class MenuAnchorContextMenu extends StatefulWidget {
  const MenuAnchorContextMenu({super.key, required this.message});

  final String message;

  @override
  State<MenuAnchorContextMenu> createState() => _MenuAnchorContextMenuState();
}

class _MenuAnchorContextMenuState extends State<MenuAnchorContextMenu> {
  MenuEntry? _lastSelection;
  final MenuController _menuController = MenuController();
  ShortcutRegistryEntry? _shortcutsEntry;
  bool get showingMessage => _showingMessage;
  bool _showingMessage = false;
  set showingMessage(bool value) {
    if (_showingMessage != value) {
      setState(() {
        _showingMessage = value;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Dispose of any previously registered shortcuts, since they are about to
    // be replaced.
    _shortcutsEntry?.dispose();
    // Collect the shortcuts from the different menu selections so that they can
    // be registered to apply to the entire app. Menus don't register their
    // shortcuts, they only display the shortcut hint text.
    final Map<ShortcutActivator, Intent> shortcuts =
        <ShortcutActivator, Intent>{
      for (final MenuEntry item in MenuEntry.values)
        if (item.shortcut != null)
          item.shortcut!: VoidCallbackIntent(() => _activate(item)),
    };
    // Register the shortcuts with the ShortcutRegistry.
    final Map<ShortcutActivator, Intent>? entries =
        ShortcutRegistry.maybeOf(context)?.shortcuts;
    // Mod to avoid issue of entries being added multiple times, the dispose
    // of them does not seem to work all the time. If this widget is used and
    // potentially shown in many places, the only shortcut entries we should
    // have are the same ones, if it exists and has not been disposed when
    // this is called we can add it, if it exists it is the one we want already.
    // We could also check for the specific entries, but for this workaround
    // works for this demo. ShortcutRegistry is intended to be used as one
    // global setting in the app, it should be higher up in the tree, then
    // we would not have this issue if this widget is used in multiple views
    // and potentially even shown one same screen.
    if (entries?.isEmpty ?? false) {
      _shortcutsEntry = ShortcutRegistry.of(context).addAll(shortcuts);
    }
  }

  @override
  void dispose() {
    _shortcutsEntry?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTapDown: _handleTapDown,
      child: MenuAnchor(
        controller: _menuController,
        consumeOutsideTap: true,
        menuChildren: <Widget>[
          MenuItemButton(
            child: Text(MenuEntry.about.label),
            onPressed: () => _activate(MenuEntry.about),
          ),
          const MenuItemButton(
            child: Text('Disabled item'),
          ),
          if (_showingMessage)
            MenuItemButton(
              onPressed: () => _activate(MenuEntry.hideMessage),
              shortcut: MenuEntry.hideMessage.shortcut,
              child: Text(MenuEntry.hideMessage.label),
            ),
          if (!_showingMessage)
            MenuItemButton(
              onPressed: () => _activate(MenuEntry.showMessage),
              shortcut: MenuEntry.showMessage.shortcut,
              child: Text(MenuEntry.showMessage.label),
            ),
          SubmenuButton(
            menuChildren: <Widget>[
              MenuItemButton(
                onPressed: () => _activate(MenuEntry.colorRed),
                shortcut: MenuEntry.colorRed.shortcut,
                child: Text(MenuEntry.colorRed.label),
              ),
              MenuItemButton(
                onPressed: () => _activate(MenuEntry.colorGreen),
                shortcut: MenuEntry.colorGreen.shortcut,
                child: Text(MenuEntry.colorGreen.label),
              ),
              MenuItemButton(
                onPressed: () => _activate(MenuEntry.colorBlue),
                shortcut: MenuEntry.colorBlue.shortcut,
                child: Text(MenuEntry.colorBlue.label),
              ),
            ],
            child: const Text('Color'),
          ),
        ],
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Click anywhere on this container to show the '
                  'MenuAnchor context menu.',
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'Menu keyboard shortcuts also work.',
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    showingMessage ? widget.message : '',
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  _lastSelection != null
                      ? 'Last Selected: ${_lastSelection!.label}'
                      : '',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _activate(MenuEntry selection) {
    setState(() {
      _lastSelection = selection;
    });
    switch (selection) {
      case MenuEntry.about:
        showAboutDialog(
          context: context,
          useRootNavigator: false,
          applicationName: 'MenuAnchor Demo',
          applicationVersion: '1.0.0',
        );
        break;
      case MenuEntry.showMessage:
      case MenuEntry.hideMessage:
        showingMessage = !showingMessage;
        break;
      case MenuEntry.colorMenu:
        break;
      case MenuEntry.colorRed:
        break;
      case MenuEntry.colorGreen:
        break;
      case MenuEntry.colorBlue:
        break;
    }
  }

  void _handleTapDown(TapDownDetails details) {
    _menuController.open(position: details.localPosition);
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
                label: 'onSurface\nVariant',
                color: colorScheme.onSurfaceVariant,
                textColor: colorScheme.surfaceContainerHighest,
              ),
              ColorCard(
                label: 'Outline',
                color: colorScheme.outline,
                textColor: colorScheme.surface,
              ),
              ColorCard(
                label: 'Outline\nVariant',
                color: colorScheme.outlineVariant,
                textColor: colorScheme.onSurface,
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
