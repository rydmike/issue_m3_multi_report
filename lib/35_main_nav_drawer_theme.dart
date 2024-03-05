import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme(),
      home: Scaffold(
        appBar: AppBar(),
        drawer: getNavDrawer(),
        body: const Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}

NavigationDrawer getNavDrawer() {
  return const NavigationDrawer(children: [
    SizedBox(height: 32),
    NavigationDrawerDestination(
        // backgroundColor: Colors.transparent,
        icon: Icon(Icons.home),
        label: Text('Home screen')),
    NavigationDrawerDestination(
        // backgroundColor: Colors.transparent,
        icon: Icon(Icons.settings),
        label: Text('Settings')),
    NavigationDrawerDestination(
        // backgroundColor: Colors.transparent,
        icon: Icon(Icons.person),
        label: Text('Profile'))
  ]);
}

ColorScheme scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4));

ThemeData theme() => ThemeData(
      colorScheme: scheme,
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: scheme.surface,
        // elevation: 12,
      ),
    );
