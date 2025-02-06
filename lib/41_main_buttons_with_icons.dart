// Reported as issue https://github.com/flutter/flutter/issues/162839

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

final ButtonStyle filledButtonStyle = FilledButton.styleFrom(
  foregroundColor: Colors.red,
  backgroundColor: Colors.grey,
);

final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.orange.shade600,
  backgroundColor: Colors.blueGrey,
);

final ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
  foregroundColor: Colors.lightBlue,
);

final ButtonStyle textButtonStyle = TextButton.styleFrom(
  foregroundColor: Colors.green,
);

final ButtonStyle segmentedButtonStyle = SegmentedButton.styleFrom(
  selectedForegroundColor: Colors.tealAccent.shade700,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(
        filledButtonTheme: FilledButtonThemeData(
          style: filledButtonStyle,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: elevatedButtonStyle,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: outlinedButtonStyle,
        ),
        textButtonTheme: TextButtonThemeData(
          style: textButtonStyle,
        ),
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: segmentedButtonStyle,
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Button Icon Color Issue')),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.icon(
                  label: const Text('Filled Themed'),
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  style: filledButtonStyle.copyWith(
                    foregroundColor: WidgetStateProperty.all(Colors.yellow),
                  ),
                  label: const Text('Filled Styled'),
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  label: const Text('Elevated Themed'),
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: elevatedButtonStyle.copyWith(
                    foregroundColor: WidgetStateProperty.all(Colors.lime),
                  ),
                  label: const Text('Elevated Styled'),
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  label: const Text('Outlined Themed'),
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  style: outlinedButtonStyle.copyWith(
                    foregroundColor: WidgetStateProperty.all(Colors.deepOrange),
                  ),
                  label: const Text('Outlined Styled'),
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  label: const Text('Text Themed'),
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  style: textButtonStyle.copyWith(
                    foregroundColor: WidgetStateProperty.all(Colors.pink),
                  ),
                  label: const Text('Text Styled'),
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 8),
            const SegmentedButtonShowcase(),
          ],
        ),
      ),
    );
  }
}

class SegmentedButtonShowcase extends StatefulWidget {
  const SegmentedButtonShowcase({this.showOutlinedButton, super.key});
  final bool? showOutlinedButton;

  @override
  State<SegmentedButtonShowcase> createState() =>
      _SegmentedButtonShowcaseState();
}

enum Calendar { day, week, month, year }

class _SegmentedButtonShowcaseState extends State<SegmentedButtonShowcase> {
  Calendar _selected = Calendar.day;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Calendar>(
      segments: const <ButtonSegment<Calendar>>[
        ButtonSegment<Calendar>(
          value: Calendar.day,
          label: Text('Day'),
          icon: Icon(Icons.calendar_view_day),
        ),
        ButtonSegment<Calendar>(
          value: Calendar.week,
          icon: Icon(Icons.calendar_view_week),
          label: Text('Week'),
        ),
        ButtonSegment<Calendar>(
          value: Calendar.month,
          icon: Icon(Icons.calendar_view_month),
          label: Text('Mont'),
        ),
        ButtonSegment<Calendar>(
          value: Calendar.year,
          icon: Icon(Icons.calendar_today),
          label: Text('Year'),
        ),
      ],
      selected: <Calendar>{_selected},
      onSelectionChanged: (Set<Calendar> selected) {
        setState(() {
          _selected = selected.first;
        });
      },
    );
  }
}
