import 'package:flutter/material.dart';

// Issue ref: https://github.com/flutter/flutter/issues/89127

void main() {
  final ThemeController themeController = ThemeController();
  runApp(MyApp(themeController: themeController));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.themeController});
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    debugPrint('#build MyApp');
    return ListenableBuilder(
        listenable: themeController,
        builder: (BuildContext context, Widget? child) {
          debugPrint('#build MaterialApp');
          return MaterialApp(
            title: 'Flutter Demo',
            theme:
                appLightTheme(appBarElevation: themeController.appBarElevation),
            home: Builder(
              builder: (BuildContext context) {
                debugPrint("#build Scaffold");
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Flutter Demo'),
                  ),
                  backgroundColor: Theme.of(context).canvasColor,
                  body: BodyContent(themeController: themeController),
                );
              },
            ),
          );
        });
  }
}

class BodyContent extends StatelessWidget {
  const BodyContent({super.key, required this.themeController});
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        SwitchListTile(
          title: const Text('Elevate AppBar'),
          onChanged: (bool value) {
            if (value) {
              themeController.setAppBarElevation(4);
            } else {
              themeController.setAppBarElevation(0);
            }
          },
          value: themeController.appBarElevation > 0,
        ),
        TextButton(onPressed: () {}, child: const Text('Text Button')),
      ],
    );
  }
}

class ThemeController with ChangeNotifier {
  ThemeController();
  double _appBarElevation = 0;
  get appBarElevation => _appBarElevation;
  void setAppBarElevation(double elevation) {
    _appBarElevation = elevation;
    notifyListeners();
  }
}

ThemeData appLightTheme({double appBarElevation = 0}) => ThemeData(
      appBarTheme: AppBarTheme(
          elevation: appBarElevation,
          shadowColor: Colors.black,
          // Adding this will make the tint color change animate too.
          shape: const RoundedRectangleBorder()),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(elevation: 1),
      ),
    );
