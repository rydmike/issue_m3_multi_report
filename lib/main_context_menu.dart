import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme(),
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: ContextCopyPasteMenu(
            onSelected: (CopyPasteCommands? value) {
              debugPrint('Selected: $value');
            },
            child: Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              height: 400,
              width: 300,
              child: const Center(child: Text('Context menu')),
            ),
          ),
        ),
      ),
    );
  }
}

ColorScheme scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4));

ThemeData theme() => ThemeData(
      colorScheme: scheme,
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: scheme.surface,
        // elevation: 12,
      ),
    );

/// Enum to handle copy and paste commands.
///
/// Not library exposed, private to the library.
enum CopyPasteCommands {
  /// Copy command
  copy,

  /// Paste command
  paste,
}

/// A cut, copy paste long press menu.
///
/// Not library exposed, private to the library.
@immutable
class ContextCopyPasteMenu extends StatelessWidget {
  /// Default const constructor.
  const ContextCopyPasteMenu({
    super.key,
    this.useLongPress = true,
    this.useSecondaryTapDown = false,
    this.menuWidth = 80,
    this.menuItemHeight = 30,
    this.copyLabel,
    this.copyIcon = Icons.copy,
    this.pasteLabel,
    this.pasteIcon = Icons.paste,
    this.menuIconThemeData,
    this.menuThemeData,
    required this.onSelected,
    this.onOpen,
    required this.child,
  }) : assert(!(!useLongPress && !useSecondaryTapDown),
            'Both useLongPress and useSecondaryTapDown cannot be false');

  /// Use long press to show context menu.
  ///
  /// Defaults to false.
  final bool useLongPress;

  /// Use secondary button tap down to show context menu.
  ///
  /// Secondary button is typically the right button on a mouse, but may in the
  /// host system be configured to be some other buttons as well, often by
  /// switching mouse right and left buttons.
  /// Defaults to false.
  final bool useSecondaryTapDown;

  /// The width of the menu.
  ///
  /// Defaults to 80 dp.
  final double menuWidth;

  /// The height of each menu item.
  ///
  /// Defaults to 30 dp.
  final double menuItemHeight;

  /// Text label used for the copy action in the menu.
  ///
  /// If null, defaults to MaterialLocalizations.of(context).copyButtonLabel.
  final String? copyLabel;

  /// Icon used for the copy action in the menu.
  ///
  /// Defaults to [Icons.copy].
  final IconData copyIcon;

  /// Text label used for the paste action in the menu.
  ///
  /// If null, defaults to MaterialLocalizations.of(context).pasteButtonLabel.
  final String? pasteLabel;

  /// Icon used for the paste action in the menu.
  ///
  /// Defaults to [Icons.paste].
  final IconData pasteIcon;

  /// The theme for the menu icons.
  ///
  /// The menu is compact, so icons are small by design.
  ///
  /// Uses any none null property in passed in [IconThemeData]. If the
  /// passed value is null, or any property in it is null, then it uses
  /// property values from `Theme.of(context).iconTheme`, if they are not
  /// null. For any null value, the following fallback defaults are used:
  ///   color: remains null, so default [IconThemeData] color behavior is kept.
  ///   size: 16
  ///   opacity: 0.90
  final IconThemeData? menuIconThemeData;

  /// The theme of the popup menu.
  ///
  /// Uses any none null property in passed in [PopupMenuThemeData]. If the
  /// passed value is null, or any property in it is null, then it uses
  /// property values from `Theme.of(context).popupMenuTheme`, if they are not
  /// null. For any null value, the following fallback defaults are used:
  ///   color: theme.cardColor.withValues(alpha: 0.9)
  ///   shape: RoundedRectangleBorder(
  ///            borderRadius: BorderRadius.circular(8),
  ///            side: BorderSide(
  ///            color: theme.dividerColor))
  ///   elevation: 3
  ///   textStyle: theme.textTheme.bodyMedium
  ///   enableFeedback: true
  final PopupMenuThemeData? menuThemeData;

  /// ValueChanged callback with selected item in the long press menu.
  /// Is null if menu closed without selection by clicking outside the menu.
  final ValueChanged<CopyPasteCommands?> onSelected;

  /// Optional void callback, called when the long press menu is opened.
  /// A way to tell when a long press opened the menu.
  final VoidCallback? onOpen;

  /// The child that gets the CopyPaste long press menu.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // This is a merge of provided menuThemeData, with surrounding theme, with
    // fallback to default values.
    final PopupMenuThemeData effectiveMenuTheme = theme.popupMenuTheme.copyWith(
      color: menuThemeData?.color ??
          theme.popupMenuTheme.color ??
          theme.colorScheme.surface.withValues(alpha: 0.9),
      shape: menuThemeData?.shape ??
          theme.popupMenuTheme.shape ??
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: theme.colorScheme.outlineVariant)),
      elevation:
          menuThemeData?.elevation ?? theme.popupMenuTheme.elevation ?? 3,
      textStyle: menuThemeData?.textStyle ??
          theme.popupMenuTheme.textStyle ??
          theme.textTheme.bodyMedium ??
          const TextStyle(fontSize: 14),
      enableFeedback: menuThemeData?.enableFeedback ??
          theme.popupMenuTheme.enableFeedback ??
          true,
    );
    // This is a merge of provided iconThemeData, with surrounding theme, with
    // fallback to default values, color has no default, remains as null.
    final IconThemeData effectiveIconTheme = theme.iconTheme.copyWith(
      color: menuIconThemeData?.color ?? theme.iconTheme.color,
      size: menuIconThemeData?.size ?? theme.iconTheme.size ?? 16,
      opacity: menuIconThemeData?.opacity ?? theme.iconTheme.opacity ?? 0.90,
    );
    // Get the Material localizations.
    final MaterialLocalizations translate = MaterialLocalizations.of(context);
    return Theme(
      data: theme.copyWith(
          popupMenuTheme: effectiveMenuTheme, iconTheme: effectiveIconTheme),
      child: ContextPopupMenu<CopyPasteCommands>(
        useLongPress: useLongPress,
        useSecondaryTapDown: useSecondaryTapDown,
        items: <PopupMenuEntry<CopyPasteCommands>>[
          PopupMenuItem<CopyPasteCommands>(
            value: CopyPasteCommands.copy,
            height: menuItemHeight,
            child: SizedBox(
              width: menuWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(copyLabel ?? translate.copyButtonLabel),
                  Icon(copyIcon),
                ],
              ),
            ),
          ),
          PopupMenuItem<CopyPasteCommands>(
            value: CopyPasteCommands.paste,
            height: menuItemHeight,
            child: SizedBox(
              width: menuWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(pasteLabel ?? translate.pasteButtonLabel),
                  Icon(pasteIcon),
                ],
              ),
            ),
          ),
        ],
        onSelected: onSelected,
        onOpen: onOpen,
        child: child,
      ),
    );
  }
}

/// A context popup menu.
///
/// Wrap a child with [ContextPopupMenu] and provide it a list of
/// [PopupMenuEntry], typically it is a [PopupMenuItem] where each item have a
/// unique value. Often the [PopupMenuItem] has a child of type [ListTile], with
/// an int as value for its list index. The child can also be a custom widget
/// with any type of row content or even images, their values could be an
/// enum for its selection as well.
///
/// The popup menu with the provided entries will show up next to the long press
/// location on the child in a way that fits best on the screen and child.
///
/// The [onSelected] returns the associated value of the selected
/// [PopupMenuEntry]. If the menu is closed without selection, which happens
/// when user clicks outside it, null is returned. In all cases an [onSelected]
/// event also signals that the menu was closed.
///
/// The optional [onOpen] callback event is triggered when the menu is opened.
///
/// The menu can be styled with [PopupMenuThemeData] either via
/// Theme.of(context).PopupMenuThemeData globally for the app and all other
/// popup menus in it, or you can wrap just your custom popup widget that
/// composes its content using [ContextPopupMenu] with a [Theme] that defines
/// the [PopupMenuThemeData] just for that popup menu widget.
///
/// Not library exposed, private to the library.
@immutable
class ContextPopupMenu<T> extends StatefulWidget {
  /// Default const constructor.
  const ContextPopupMenu({
    super.key,
    required this.items,
    required this.onSelected,
    this.onOpen,
    required this.child,
    this.useLongPress = true,
    this.useSecondaryTapDown = false,
  }) : assert(!(!useLongPress && !useSecondaryTapDown),
            'Both useLongPress and useSecondaryTapDown cannot be false');

  /// The popup menu entries for the long press menu.
  final List<PopupMenuEntry<T>> items;

  /// ValueChanged callback with selected item in the long press menu.
  /// Is null if menu closed without selection by clicking outside the menu.
  final ValueChanged<T?> onSelected;

  /// Optional void callback, called when the long press menu is opened.
  /// A way to tell when a long press opened the menu.
  final VoidCallback? onOpen;

  /// The child that can be long pressed to activate the long press menu.
  final Widget child;

  /// Use long press to show context menu.
  ///
  /// Defaults to false.
  final bool useLongPress;

  /// Use secondary button tap down to show context menu.
  ///
  /// Secondary button is typically the right button on a mouse, but may in the
  /// host system be configured to be some other buttons as well, often by
  /// switching mouse right and left buttons.
  /// Defaults to false.
  final bool useSecondaryTapDown;

  @override
  State<StatefulWidget> createState() => _ContextPopupMenuState<T>();
}

class _ContextPopupMenuState<T> extends State<ContextPopupMenu<T>> {
  Offset _downPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final bool useLongPress = widget.useLongPress;
    final bool useSecondaryClick = widget.useSecondaryTapDown;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPressCancel: useLongPress
          ? () {
              debugPrint('Long press canceled');
              widget.onSelected(null);
            }
          : null,
      onLongPressStart: useLongPress
          ? (LongPressStartDetails details) async {
              widget.onOpen?.call();
              _downPosition = details.globalPosition;
              await _showMenu(_downPosition);
            }
          : null,
      onSecondaryTapDown: useSecondaryClick
          ? (TapDownDetails details) async {
              widget.onOpen?.call();
              _downPosition = details.globalPosition;
              await _showMenu(_downPosition);
            }
          : null,
      child: widget.child,
    );
  }

  Future<void> _showMenu(Offset position) async {
    widget.onOpen?.call();
    final RenderBox? overlay =
        Overlay.maybeOf(context)?.context.findRenderObject() as RenderBox?;
    if (overlay != null) {
      final T? value = await showMenu<T>(
        context: context,
        items: widget.items,
        position: RelativeRect.fromLTRB(
          position.dx,
          position.dy,
          overlay.size.width - position.dx,
          overlay.size.height - position.dy,
        ),
      );
      widget.onSelected(value);
    }
  }
}
