import 'package:flutter/material.dart';

// Flutter code sample for [BubbleTabs].
//
// Available as gist:
// https://gist.github.com/rydmike/f77c8ff139f13c9d0e7a231c69cb375b
// And DartPad:
// https://dartpad.dev/?id=f77c8ff139f13c9d0e7a231c69cb375b
// Related to this tweet:
// https://x.com/RydMike/status/1843380238258184605
void main() => runApp(const BubbleTabsApp());

class BubbleTabsApp extends StatelessWidget {
  const BubbleTabsApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DemoBubbleTabsPage(),
    );
  }
}

class DemoBubbleTabsPage extends StatefulWidget {
  const DemoBubbleTabsPage({super.key});

  @override
  State<DemoBubbleTabsPage> createState() => _DemoBubbleTabsPageState();
}

class _DemoBubbleTabsPageState extends State<DemoBubbleTabsPage> {
  int selectedTab = 1;
  bool showCheckmark = false;
  bool isEnabled = true;

  static const RoundedRectangleBorder tileShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 64),
              Text('Messages',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              BubbleTabs(
                labels: const <String>['All', 'Personal', 'Work', 'Updates'],
                selected: selectedTab,
                onSelected: (int index) {
                  setState(() {
                    selectedTab = index;
                  });
                },
                showCheckmark: showCheckmark,
                isEnabled: isEnabled,
                // Uncomment to test custom colors and shapes
                // -------------------------------------------
                // selectedForegroundColor: Colors.green[700],
                // selectedBackgroundColor: Colors.green[50],
                // unselectedForegroundColor: Colors.blueGrey,
                // unselectedBackgroundColor: Colors.blueGrey[50],
                // selectedShape: const RoundedRectangleBorder(
                //   borderRadius: BorderRadius.all(Radius.circular(10)),
                // ),
                // unselectedShape: const RoundedRectangleBorder(
                //   borderRadius: BorderRadius.all(Radius.circular(2)),
                // ),
              ),
              Text('Selected tab: $selectedTab'),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const CircleAvatar(child: Text('MM')),
                      title: const Text('Mohammad, Lili, So'),
                      subtitle: const Text('That looks so good!'),
                      trailing: const Text('Now'),
                      tileColor: Theme.of(context).colorScheme.surfaceContainer,
                      shape: tileShape,
                    ),
                    const ListTile(
                      leading: CircleAvatar(child: Text('FR')),
                      title: Text('Fabia Reza'),
                      subtitle: Text("'Hey! I'm heading out now"),
                      trailing: Text('10 min'),
                      shape: tileShape,
                    ),
                    const ListTile(
                      leading: CircleAvatar(child: Text('RQ')),
                      title: Text('Ruichi Qiang'),
                      subtitle: Text('No idea how to do those chars!'),
                      trailing: Text('20 min'),
                      shape: tileShape,
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      dense: true,
                      shape: tileShape,
                      title: const Text('Enable BubbleTabs'),
                      value: isEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          isEnabled = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      dense: true,
                      shape: tileShape,
                      title: const Text('BubbleTabs with checkmark'),
                      value: showCheckmark,
                      onChanged: (bool value) {
                        setState(() {
                          showCheckmark = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A BubbleTabs control with BubbleTabItem children.
///
/// The BubbleTabs takes a list of strings used as labels for the tabs in the
/// control.
/// It defaults to the first tab being selected, but you can set the selected
/// tab by passing the index of the tab you want to be selected.
/// It ha a callback that is called when a tab is selected, it will pass the
/// index of the selected tab to the callback.
class BubbleTabs extends StatelessWidget {
  const BubbleTabs({
    super.key,
    required this.labels,
    this.selected = 0,
    this.onSelected,
    this.showCheckmark,
    this.isEnabled,
    this.selectedForegroundColor,
    this.selectedBackgroundColor,
    this.unselectedForegroundColor,
    this.unselectedBackgroundColor,
    this.selectedShape,
    this.unselectedShape,
  });
  final List<String> labels;
  final int selected;
  final ValueChanged<int>? onSelected;
  final bool? showCheckmark;
  final bool? isEnabled;
  final Color? selectedForegroundColor;
  final Color? selectedBackgroundColor;
  final Color? unselectedForegroundColor;
  final Color? unselectedBackgroundColor;
  final OutlinedBorder? selectedShape;
  final OutlinedBorder? unselectedShape;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List<Widget>.generate(labels.length, (int index) {
        return Padding(
          padding: const EdgeInsets.all(4),
          child: BubbleTabItem(
            selected: index == selected,
            label: labels[index],
            // Setting the onSelected as null when isEnabled is false, will
            // give us nice disabled style courtesy of the ChoiceChip features.
            onSelected: isEnabled ?? true
                ? (bool selected) {
                    onSelected?.call(index);
                  }
                : null,
            showCheckmark: showCheckmark,
            selectedForegroundColor: selectedForegroundColor,
            selectedBackgroundColor: selectedBackgroundColor,
            unselectedForegroundColor: unselectedForegroundColor,
            unselectedBackgroundColor: unselectedBackgroundColor,
            selectedShape: selectedShape,
            unselectedShape: unselectedShape,
          ),
        );
      }),
    );
  }
}

// An item in a BubbleTab tabbed control.
class BubbleTabItem extends StatelessWidget {
  const BubbleTabItem({
    super.key,
    required this.selected,
    this.onSelected,
    required this.label,
    this.showCheckmark,
    this.selectedForegroundColor,
    this.selectedBackgroundColor,
    this.unselectedForegroundColor,
    this.unselectedBackgroundColor,
    this.selectedShape,
    this.unselectedShape,
  });
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final String label;
  final bool? showCheckmark;
  final Color? selectedForegroundColor;
  final Color? selectedBackgroundColor;
  final Color? unselectedForegroundColor;
  final Color? unselectedBackgroundColor;
  final OutlinedBorder? selectedShape;
  final OutlinedBorder? unselectedShape;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    // Some default colors for the BubbleTabItem.
    final Color foregroundColor = selected
        ? selectedForegroundColor ?? scheme.onTertiaryContainer
        : unselectedForegroundColor ?? scheme.onSurfaceVariant;
    final Color backgroundColor = selected
        ? selectedBackgroundColor ?? scheme.tertiaryContainer
        : unselectedBackgroundColor ?? scheme.surfaceContainerHighest;
    // Default: Make shape stadium border when selected, otherwise radius 8.
    final OutlinedBorder shape = selected
        ? selectedShape ?? const StadiumBorder()
        : unselectedShape ??
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            );
    final WidgetStateProperty<Color> effectiveBackgroundColor =
        WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return backgroundColor.withOpacity(0.4);
      }
      return backgroundColor;
    });
    final TextStyle labelStyle =
        theme.textTheme.labelLarge!.copyWith(color: foregroundColor);
    return ChoiceChip(
      label: Text(label),
      labelStyle: labelStyle,
      selected: selected,
      onSelected: onSelected,
      showCheckmark: showCheckmark ?? false,
      checkmarkColor: foregroundColor,
      color: effectiveBackgroundColor,
      shape: shape,
      side: BorderSide.none,
      chipAnimationStyle: ChipAnimationStyle(
        selectAnimation: AnimationStyle(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }
}
