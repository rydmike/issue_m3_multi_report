import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Button hide demo')),
        body: const HideDemo(),
      ),
    );
  }
}

class HideDemo extends StatefulWidget {
  const HideDemo({super.key});

  @override
  State<HideDemo> createState() => _HideDemoState();
}

class _HideDemoState extends State<HideDemo> {
  bool hideButton = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Expanded(
                  child: TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
              )),
              AnimatedHide(
                hide: hideButton,
                axis: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8.0),
                  child:
                      TextButton(onPressed: () {}, child: const Text('Cancel')),
                ),
              ),
            ],
          ),
        ),
        SwitchListTile(
          title: const Text('Hide button'),
          onChanged: (bool value) {
            setState(() {
              hideButton = value;
            });
          },
          value: hideButton,
        ),
      ],
    );
  }
}

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
    );
  }
}
