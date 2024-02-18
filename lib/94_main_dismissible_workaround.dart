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
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Stack(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.purpleAccent),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Dismissible(
                key: ValueKey<int>(items[index]),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.limeAccent,
                  ),
                  child: Center(
                    child: Text(
                      'Item ${items[index]}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
                onDismissed: (DismissDirection direction) {
                  setState(() {
                    items.removeAt(index);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
