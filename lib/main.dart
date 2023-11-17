import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FooBar',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
        cardTheme: const CardTheme(
          shadowColor: Colors.transparent,
          elevation: 10,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          showDragHandle: true,
          shadowColor: Colors.transparent,
          constraints: BoxConstraints(maxWidth: 300),
          elevation: 10,
        ),
        drawerTheme: const DrawerThemeData(
          shadowColor: Colors.transparent,
          elevation: 10,
        ),
      ),
      home: const FooWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FooWidget extends StatelessWidget {
  const FooWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('FooBar'),
      ),
      drawer: const Drawer(child: Center(child: Text('Drawer'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Card(
              child: SizedBox(
                height: 120,
                width: 300,
                child: Center(
                  child: Text('Card\nelevation 10\nShadow: transparent'),
                ),
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * .3,
                    child: const Center(child: Text('FooBar')),
                  );
                },
              ),
              child: const Text('Trigger Panel'),
            ),
          ],
        ),
      ),
    );
  }
}
