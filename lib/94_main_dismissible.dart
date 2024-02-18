import 'package:flutter/material.dart';

/// Flutter code sample for [Dismissible].

void main() => runApp(const DismissibleExampleApp());

class DismissibleExampleApp extends StatelessWidget {
  const DismissibleExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Dismissible Sample')),
        body: const DismissibleExample(),
      ),
    );
  }
}

class DismissibleExample extends StatefulWidget {
  const DismissibleExample({super.key});

  @override
  State<DismissibleExample> createState() => _DismissibleExampleState();
}

class _DismissibleExampleState extends State<DismissibleExample> {
  List<int> items = List<int>.generate(100, (int index) => index);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Dismissible(
              background: Container(
                decoration: ShapeDecoration(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              secondaryBackground: Container(
                decoration: ShapeDecoration(
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              key: ValueKey<int>(items[index]),
              onDismissed: (DismissDirection direction) {
                setState(() {
                  items.removeAt(index);
                });
              },
              child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Theme.of(context).colorScheme.surfaceVariant,
                clipBehavior: Clip.antiAlias,
                shadowColor: Colors.transparent,
                elevation: 2,
                surfaceTintColor: Colors.transparent,
                child: ListTile(
                  title: Text(
                    'Item ${items[index]}',
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
