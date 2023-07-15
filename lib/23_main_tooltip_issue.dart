import 'package:flutter/material.dart';

void main() => runApp(const IssueApp());

class IssueApp extends StatelessWidget {
  const IssueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RenderTheater Tooltip Crash',
      themeMode: ThemeMode.system,
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RenderTheater Tooltip Crash')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: List.generate(
          40,
          (index) => Tooltip(
            message: 'A text $index line with a ToolTip',
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Text with tooltip number $index'),
            ),
          ),
        ),
      ),
    );
  }
}
