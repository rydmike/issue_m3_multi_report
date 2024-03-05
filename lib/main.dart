import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: LongPressDialog(
            onChange: (String value) {
              debugPrint('Selected: $value');
            },
            child: Container(
              color: Theme.of(context).colorScheme.surfaceVariant,
              height: 400,
              width: 300,
              child: const Center(child: Text('Long press dialog')),
            ),
          ),
        ),
      ),
    );
  }
}

ColorScheme scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4));

@immutable
class LongPressDialog extends StatefulWidget {
  const LongPressDialog({
    super.key,
    required this.onChange,
    this.onOpen,
    required this.child,
  });

  final ValueChanged<String> onChange;
  final VoidCallback? onOpen;
  final Widget child;

  @override
  State<StatefulWidget> createState() => _LongPressDialogState();
}

class _LongPressDialogState<T> extends State<LongPressDialog> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: () async {
        widget.onOpen?.call();
        String result = await _showLongPressDialog(context);
        debugPrint('result: $result');
      },
      child: widget.child,
    );
  }

  Future<String> _showLongPressDialog(BuildContext context) async {
    final CapturedThemes themes = InheritedTheme.capture(
      from: context,
      to: Navigator.of(context, rootNavigator: true).context,
    );
    String? value;

    await showGeneralDialog<String?>(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.3),
      useRootNavigator: true,
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (BuildContext context, Animation<double> a1,
          Animation<double> a2, Widget widget) {
        final double curvedValue =
            Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      },
      pageBuilder: (BuildContext context, Animation<double> animation1,
          Animation<double> animation2) {
        return themes.wrap(Builder(
          builder: (BuildContext context) => const MyLongPressShowedWidget(),
        ));
      },
    ).then((String? value) {
      value = value;
    });
    return value ?? 'barrier closed';
  }
}

class MyLongPressShowedWidget extends StatelessWidget {
  const MyLongPressShowedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 300,
          maxWidth: 200,
        ),
        child: Listener(
            behavior: HitTestBehavior.opaque,
            onPointerUp: (PointerUpEvent event) {
              Navigator.of(context)
                  .pop('onPointerUp in MyLongPressShowedWidget');
            },
            child: const Center(child: Text('MyDialogWidget'))),
      ),
    );
  }
}
