import 'package:flutter/material.dart';

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
        TextButton(
            onPressed: () {
              themeController.triggerRebuild();
            },
            child: const Text('Trigger Rebuild')),
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

  void triggerRebuild() {
    notifyListeners();
  }
}

ThemeData appLightTheme({double appBarElevation = 0}) => ThemeData(
      appBarTheme: AppBarTheme(
        elevation: appBarElevation,
        shadowColor: Colors.black,
        // Adding this will make the elevation tint color change animate too.
        shape: const RoundedRectangleBorder(),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(elevation: 1),
      ),
    );

/// This widget is good for using a boolean condition to show/hide the [child]
/// widget. It is a simple convenience wrapper for AnimatedSwitcher
/// where the Widget that is Switched to is an invisible SizedBox.shrink()
/// effectively removing the child by animation in a zero sized widget
/// instead.
class AnimatedHide extends StatelessWidget {
  const AnimatedHide({
    super.key,
    this.hide = false,
    this.duration = const Duration(milliseconds: 300),
    this.axis = Axis.vertical,
    required this.child,
  });

  /// Set hide to true to remove the child with size transition.
  final bool hide;

  /// The duration of the hide animation.
  final Duration duration;

  /// Transition Axis vertical or horizontal?
  final Axis axis;

  /// The widget to be conditionally hidden, when hide is true.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SizeTransition(
          axis: axis,
          sizeFactor: animation,
          axisAlignment: hide ? -1.0 : 1.0,
          child: child,
        );
      },
      child: hide ? const SizedBox.shrink() : child,
      // child: hide ? null : child,
    );
  }
}
