import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home screen'),
        elevation: 3,
      ),
      body: Center(
        child: FilledButton(
          child: const Text('Go to other screen'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const SecondScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),

        // IconButton(
        //   icon: const BackButtonIcon(),
        //   onPressed: () async {
        //     await Navigator.maybePop(context);
        //   },
        // ),
        toolbarHeight: 96,
        title: const Text('Other screen'),
        elevation: 3,
      ),
      body: const Center(
        child: Text(
          'Other screen content',
        ),
      ),
    );
  }
}

// leading: IconButton(
//   icon: const BackButtonIcon(),
//   onPressed: () async {
//     await Navigator.maybePop(context);
//   },
// ),
