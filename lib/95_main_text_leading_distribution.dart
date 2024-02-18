import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const Example(),
    );
  }
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  TextLeadingDistribution leadingStyle = TextLeadingDistribution.even;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = Theme.of(context)
        .textTheme
        .displayLarge!
        .copyWith(leadingDistribution: leadingStyle);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text('TextStyle.height'),
            Text('${style.height}'),
            const Text('TextLeadingDistribution'),
            Text(leadingStyle.name),
            Card(
              shape: const CircleBorder(),
              elevation: 6,
              shadowColor: Colors.transparent,
              child: SizedBox(
                width: 100,
                height: 100,
                child: Center(child: Text('1', style: style)),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            switch (leadingStyle) {
              case TextLeadingDistribution.even:
                leadingStyle = TextLeadingDistribution.proportional;
              case TextLeadingDistribution.proportional:
                leadingStyle = TextLeadingDistribution.even;
            }
          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
