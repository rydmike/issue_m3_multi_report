import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
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
      drawer: const Drawer(),
      endDrawer: const Drawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              child: const Text('Go to other screen'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const OtherScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              child: const Text('Go to modal screen'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => const OtherScreen(),
                  ),
                );
              },
            ),
            IconButton.outlined(
              icon: const Icon(Icons.add),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class OtherScreen extends StatelessWidget {
  const OtherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const BackButtonIcon(),
          onPressed: () async {
            await Navigator.maybePop(context);
          },
        ),
        actions: [
          IconButton.outlined(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
          IconButton.outlined(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
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

// leading: BackButton(),

// Container(
// width: 48,
// height: 48,
// decoration: BoxDecoration(
// color: Colors.white,
// borderRadius: BorderRadius.circular(0),
// ),
// child: ConstrainedBox(
// constraints: const BoxConstraints.tightFor(width: 40, height: 40),
// child: Center(
// child: IconButton.outlined(
// icon: const Icon(Icons.add),
// onPressed: () {},
// ),
// ),
// ),
// ),
// Container(
// width: 48,
// height: 48,
// decoration: BoxDecoration(
// color: Colors.yellow,
// borderRadius: BorderRadius.circular(0),
// ),
// child: ConstrainedBox(
// constraints: const BoxConstraints.tightFor(width: 40, height: 40),
// child: Center(
// child: IconButton.outlined(
// icon: const Icon(Icons.search),
// onPressed: () {},
// ),
// ),
// ),
// ),
