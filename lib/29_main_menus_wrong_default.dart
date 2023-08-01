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

// This issue reported here: https://github.com/flutter/flutter/issues/131676

// A seed color for the M3 ColorScheme.
const Color seedColor = Color(0xFF2E747D);

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
    switchTheme: settings.customTheme
        ? SwitchThemeData(
            thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
              (Set<MaterialState> states) {
                return const Icon(Icons.minimize, color: Colors.transparent);
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
    customTheme: true,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: theme(Brightness.light, settings),
      darkTheme: theme(Brightness.dark, settings),
      home: Scaffold(
        appBar: AppBar(
          title: settings.useMaterial3
              ? const Text('Menu wrong defaults (M3)')
              : const Text('Menu wrong defaults (M2)'),
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
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const PopupMenuButtonsShowcase(explain: true),
        const SizedBox(height: 8),
        const DropDownMenuShowcase(explain: true),
        const MenuAnchorShowcase(explain: true),
        const MenuBarShowcase(explain: true),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('TextTheme', style: theme.textTheme.titleMedium),
                const TextThemeShowcase(),
              ],
            ),
          ),
        ),
        const ShowColorSchemeColors(),
      ],
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

class PopupMenuButtonsShowcase extends StatelessWidget {
  const PopupMenuButtonsShowcase({super.key, this.explain = false});
  final bool explain;

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
          if (explain)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: Text(
                'PopupMenuButton',
                style: denseHeader,
              ),
            ),
          if (explain)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Text(
                'The PopupMenuButton correctly uses labelLarge, but not if '
                'it is populated with ListTiles.',
                style: denseBody,
              ),
            ),
          const Row(
            children: <Widget>[
              PopupMenuButtonShowcase(),
              SizedBox(width: 16),
              CheckedPopupMenuButtonShowcase(),
              SizedBox(width: 16),
              PopupMenuButtonTilesShowcase(),
            ],
          ),
        ]);
  }
}

class PopupMenuButtonShowcase extends StatelessWidget {
  const PopupMenuButtonShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: (_) {},
      position: PopupMenuPosition.under,
      itemBuilder: (BuildContext context) => const <PopupMenuItem<int>>[
        PopupMenuItem<int>(value: 1, child: Text('This is')),
        PopupMenuItem<int>(value: 2, child: Text('using text')),
        PopupMenuItem<int>(value: 3, child: Text('style')),
        PopupMenuItem<int>(value: 4, child: Text('Label Large')),
        PopupMenuItem<int>(value: 5, child: Text('and is OK')),
      ],
      icon: const Icon(Icons.more_vert),
    );
  }
}

class CheckedPopupMenuButtonShowcase extends StatelessWidget {
  const CheckedPopupMenuButtonShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: (_) {},
      position: PopupMenuPosition.under,
      itemBuilder: (BuildContext context) => const <PopupMenuItem<int>>[
        CheckedPopupMenuItem<int>(value: 1, child: Text('This is')),
        CheckedPopupMenuItem<int>(value: 2, child: Text('using text')),
        CheckedPopupMenuItem<int>(value: 3, child: Text('style')),
        CheckedPopupMenuItem<int>(value: 4, child: Text('Label Large')),
        CheckedPopupMenuItem<int>(value: 5, child: Text('and is OK')),
      ],
      icon: const Icon(Icons.playlist_add_check),
    );
  }
}

class PopupMenuButtonTilesShowcase extends StatelessWidget {
  const PopupMenuButtonTilesShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip: 'Show menu using\nListTile items',
      onSelected: (_) {},
      position: PopupMenuPosition.under,
      itemBuilder: (BuildContext context) => const <PopupMenuItem<int>>[
        PopupMenuItem<int>(
            value: 1,
            child: ListTile(
                leading: Icon(Icons.alarm), title: Text('Alarm Body Large'))),
        PopupMenuItem<int>(
            value: 2,
            child: ListTile(leading: Icon(Icons.cabin), title: Text('Cabin'))),
        PopupMenuItem<int>(
            value: 3,
            child: ListTile(
                leading: Icon(Icons.camera_outdoor_rounded),
                title: Text('Camera'))),
        PopupMenuItem<int>(
            value: 4,
            child: ListTile(
                leading: Icon(Icons.water_damage), title: Text('Water'))),
      ],
      icon: const Icon(Icons.more_horiz),
    );
  }
}

class DropDownMenuShowcase extends StatefulWidget {
  const DropDownMenuShowcase({super.key, this.explain = false});
  final bool explain;

  @override
  State<DropDownMenuShowcase> createState() => _DropDownMenuShowcaseState();
}

class _DropDownMenuShowcaseState extends State<DropDownMenuShowcase> {
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
              'DropdownMenu',
              style: denseHeader,
            ),
          ),
        if (widget.explain)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: Text(
              'The M3 DropdownMenu shares building blocks with MenuBar '
              'and MenuAnchor, also uses InputDecorator for text entry. The '
              'Text entry uses labelLarge and items bodyLarger, correct '
              'M3 style should be the other way around.',
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
                style: ButtonStyle(
                  padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 12)),
                ),
                label: 'Surveillance view',
                leadingIcon: Icon(Icons.camera_outdoor_rounded),
                // value: 'four',
                value: Icons.camera_outdoor_rounded),
            DropdownMenuEntry<IconData>(
              style: ButtonStyle(
                padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 12)),
              ),
              label: 'Water alert - Body Large',
              leadingIcon: Icon(Icons.water_damage),
              // value: 'five',
              value: Icons.water_damage,
            ),
          ],
        ),
      ],
    );
  }
}

class MenuBarShowcase extends StatelessWidget {
  const MenuBarShowcase({
    super.key,
    this.explain = false,
    this.explainIndent = 0,
  });
  final bool explain;
  final double explainIndent;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle denseHeader = theme.textTheme.titleMedium!.copyWith(
      fontSize: 13,
    );
    final TextStyle denseBody = theme.textTheme.bodyMedium!
        .copyWith(fontSize: 12, color: theme.textTheme.bodySmall!.color);
    return Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.keyT, control: true):
            VoidCallbackIntent(debugDumpApp),
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          if (explain)
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(explainIndent, 16, 0, 0),
              child: Text(
                'MenuBar',
                style: denseHeader,
              ),
            ),
          if (explain)
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(explainIndent, 0, 0, 8),
              child: Text(
                'The M3 menus can be used in a MenuBar via SubMenuButton '
                'and its MenuItemButton. The menu items all default to '
                'bodyLarge correct M3 spec is labelLarge. The spec for '
                'size of the buttons on the MenuBar do not seem to be '
                'specified clearly in the M3 spec.',
                style: denseBody,
              ),
            ),
          Row(
            children: <Widget>[
              Expanded(
                child: MenuBar(
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
                          child:
                              const MenuAcceleratorLabel('&About Body Large'),
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MenuAnchorShowcase extends StatelessWidget {
  const MenuAnchorShowcase({super.key, this.explain = false});
  final bool explain;

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
        if (explain) ...<Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: Text(
              'MenuAnchor',
              style: denseHeader,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: Text(
              'The M3 MenuAnchor used on a Container as a context menu. The '
              'menu items all use bodyLarge by default, correct M3 spec '
              'is labelLarge.',
              style: denseBody,
            ),
          ),
        ],
        const Row(
          children: <Widget>[
            Expanded(
              child: MenuAnchorContextMenu(
                message: 'The M3 MenuAnchor is cool!',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// An enhanced enum to define the available menus and their shortcuts.
///
/// Using an enum for menu definition is not required, but this illustrates how
/// they could be used for simple menu systems.
enum MenuEntry {
  about('About Body Large'),
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
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');
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
    // Register the shortcuts with the ShortcutRegistry so that they are
    // available to the entire application.
    final Map<ShortcutActivator, Intent>? entries =
        ShortcutRegistry.maybeOf(context)?.shortcuts;
    if (entries?.isEmpty ?? false) {
      _shortcutsEntry = ShortcutRegistry.of(context).addAll(shortcuts);
    }
  }

  @override
  void dispose() {
    _shortcutsEntry?.dispose();
    _buttonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTapDown: _handleTapDown,
      child: MenuAnchor(
        controller: _menuController,
        anchorTapClosesMenu: true,
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
      case MenuEntry.showMessage:
      case MenuEntry.hideMessage:
        showingMessage = !showingMessage;
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

class TextThemeShowcase extends StatelessWidget {
  const TextThemeShowcase({super.key, this.showDetails = false});
  final bool showDetails;

  @override
  Widget build(BuildContext context) {
    return TextThemeColumnShowcase(
      textTheme: Theme.of(context).textTheme,
      showDetails: showDetails,
    );
  }
}

class PrimaryTextThemeShowcase extends StatelessWidget {
  const PrimaryTextThemeShowcase({super.key, this.showDetails = false});
  final bool showDetails;

  @override
  Widget build(BuildContext context) {
    return TextThemeColumnShowcase(
      textTheme: Theme.of(context).primaryTextTheme,
      showDetails: showDetails,
    );
  }
}

class TextThemeColumnShowcase extends StatelessWidget {
  const TextThemeColumnShowcase({
    super.key,
    required this.textTheme,
    this.showDetails = false,
  });
  final TextTheme textTheme;
  final bool showDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Font: ${textTheme.bodyMedium!.fontFamily}',
            style: textTheme.titleSmall),
        _ShowTextStyle(
          'Display Large '
          '(${textTheme.displayLarge!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.displayLarge!,
          infoStyle: textTheme.labelSmall!,
          showDetails: showDetails,
        ),
        _ShowTextStyle(
          'Display Medium '
          '(${textTheme.displayMedium!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.displayMedium!,
          infoStyle: textTheme.labelSmall!,
          showDetails: showDetails,
        ),
        _ShowTextStyle(
          'Display Small '
          '(${textTheme.displaySmall!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.displaySmall!,
          infoStyle: textTheme.labelSmall!,
          showDetails: showDetails,
        ),
        const SizedBox(height: 12),
        _ShowTextStyle(
          'Headline Large '
          '(${textTheme.headlineLarge!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.headlineLarge!,
          infoStyle: textTheme.labelSmall!,
          showDetails: showDetails,
        ),
        _ShowTextStyle(
          'Headline Medium '
          '(${textTheme.headlineMedium!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.headlineMedium!,
          infoStyle: textTheme.labelSmall!,
          showDetails: showDetails,
        ),
        _ShowTextStyle(
          'Headline Small '
          '(${textTheme.headlineSmall!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.headlineSmall!,
          infoStyle: textTheme.labelSmall!,
          showDetails: showDetails,
        ),
        const SizedBox(height: 12),
        _ShowTextStyle(
          'Title Large '
          '(${textTheme.titleLarge!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.titleLarge!,
          infoStyle: textTheme.labelSmall!,
          showDetails: showDetails,
        ),
        _ShowTextStyle(
          'Title Medium '
          '(${textTheme.titleMedium!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.titleMedium!,
          infoStyle: textTheme.labelSmall!,
          showDetails: showDetails,
        ),
        _ShowTextStyle(
          'Title Small '
          '(${textTheme.titleSmall!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.titleSmall!,
          infoStyle: textTheme.labelSmall!,
          showDetails: showDetails,
        ),
        const SizedBox(height: 12),
        _ShowTextStyle(
          'Body Large '
          '(${textTheme.bodyLarge!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.bodyLarge!,
          infoStyle: textTheme.labelSmall!,
          showDetails: showDetails,
        ),
        _ShowTextStyle(
          'Body Medium '
          '(${textTheme.bodyMedium!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.bodyMedium!,
          infoStyle: textTheme.labelSmall!,
          showDetails: showDetails,
        ),
        _ShowTextStyle(
          'Body Small '
          '(${textTheme.bodySmall!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.bodySmall!,
          infoStyle: textTheme.labelSmall!,
          showDetails: showDetails,
        ),
        const SizedBox(height: 12),
        _ShowTextStyle(
          'Label Large '
          '(${textTheme.labelLarge!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.labelLarge!,
          infoStyle: textTheme.labelSmall!,
          showDetails: showDetails,
        ),
        _ShowTextStyle(
          'Label Medium '
          '(${textTheme.labelMedium!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.labelMedium!,
          infoStyle: textTheme.labelSmall!,
          showDetails: showDetails,
        ),
        _ShowTextStyle(
          'Label Small '
          '(${textTheme.labelSmall!.fontSize!.toStringAsFixed(0)})',
          style: textTheme.labelSmall!,
          infoStyle: textTheme.labelSmall!,
          showDetails: showDetails,
        ),
      ],
    );
  }
}

class _ShowTextStyle extends StatelessWidget {
  const _ShowTextStyle(
    this.label, {
    required this.style,
    required this.infoStyle,
    this.showDetails = false,
  });

  final String label;
  final TextStyle style;
  final TextStyle infoStyle;
  final bool showDetails;

  @override
  Widget build(BuildContext context) {
    final String font = style.fontFamily ?? '';
    final String size = style.fontSize!.toStringAsFixed(1);
    final String fontWeight = style.fontWeight!.toString();
    final String color = style.color!.toString();
    final String spacing = style.letterSpacing != null
        ? style.letterSpacing!.toStringAsFixed(2)
        : '';
    final String height = style.height != null
        ? ' height: ${style.height!.toStringAsFixed(2)}'
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: style),
        if (showDetails) ...<Widget>[
          const SizedBox(height: 4),
          Text(
              '$font $size pt, $fontWeight $color '
              'Letter spacing: $spacing$height',
              style: infoStyle),
          const SizedBox(height: 4),
        ],
      ],
    );
  }
}
