import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      title: 'PageView Onboarding Example',
      theme: ThemeData(
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 10,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(56.0)),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  // A map of icons and labels to display on each page
  final Map<String, IconData> _pages = {
    'Home': Icons.home,
    'Favorite': Icons.favorite,
    'Settings': Icons.settings,
    'Help': Icons.help
  };

  // A controller for the page view
  late final PageController _pageController;

  // A controller for the tab page selector
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers
    _pageController = PageController(viewportFraction: 0.75);
    _tabController = TabController(length: _pages.length, vsync: this);
    // Sync the tab controller by listening to the page controller
    _pageController.addListener(() {
      _tabController.animateTo(_pageController.page!.round());
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PageView Onboarding'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                // A card widget to display the icon and label
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 32,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_pages.values.toList()[index],
                            size: 64.0), // An icon
                        const SizedBox(height: 16.0), // A spacer
                        Text(_pages.keys.toList()[index],
                            style: const TextStyle(fontSize: 24.0)), // A label
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          TabPageSelector(controller: _tabController),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {},
            child: const Text('Continue'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// Create a custom scroll behavior class that allows mouse drag
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
