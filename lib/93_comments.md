@raghavendra-k-j yes it is a correct observation that all values in `ThemeData` are changed via a `lerp` animation. So if you observe the rebuild of widgets that are affected by any changed property value in `ThemeData`, you will see a lot of rebuilds of those widgets as the `Theme` linearly animates through those values to the new target value. This is **normal** and **expected** behavior.

However, the problem is that as soon as you use any component theme that contains a `MaterialStateProperty` (now in master `WidgetStateProperty`) that is not null, ie defined to some custom theme value, the `Theme` will **lerp** animate and rebuild all widgets, even if there is no value change on `ThemeData`.

This happens because using `MaterialStateProperty` breaks object equality, so the same `ThemeData` is no longer equal and everything is animated and rebuilt anyway, even if nothing was changed and nothing should have been rebuilt.

This is imo a **real** and **severe** issue with `ThemeData` and the used `MaterialStateProperty` solution.


## Another sample to demo the issue

Consider this "a bit" more involved sample:


```dart
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
```

On first build we see this:

![Screenshot 2024-04-06 at 16 34 31](https://github.com/flutter/flutter/assets/39990307/d924f4de-4b5b-4709-a7c0-0449e0213417)

We see the 3 builds that the framework triggers (I wish that was just once too, but there are bunch of wrappers that triggers it 3 times).

Then many Scaffold rebuilds as the theme change was animated. But was there really something to lerp animate? Let's look at it in more detail.

### Elevate AppBar

Let's start by elevating the AppBar:

https://github.com/flutter/flutter/assets/39990307/f6563369-6758-4770-a834-4725bef4318b

The `MaterialApp` rebuilds once, and `Scaffold` many times as the `AppBar` elevates and changes style via an animation. The elevation tint color is animated, as is the appearance of the shadow under it. This is all expected and as it should be

> [!NOTE]  
> In the `AppBarTheme` the `shape: const RoundedRectangleBorder()` is needed to make the change in elevation tint color animate as it should. That this is needed is due to a performance optimization that is made on `Material` widget. See issue https://github.com/flutter/flutter/issues/131042 for more info.

### Trigger rebuild - Take 1

Next let us just push the button to trigger a rebuild, notifying listeners that the theme controller has changed and thus also the theme:


https://github.com/flutter/flutter/assets/39990307/9213f0e0-40f7-4e17-8a47-781bb8a52e86

We get the same expected rebuild once of `MaterialApp`, but `Scaffold` was built many times, even if nothing in it changed. This is bad, but why did it happen?

It happened because `ThemeData` object value equality is broken, because we are using a `MaterialStateProperty` that contain callback functions.

In our `ThemeData` the `styleFrom` will define a custom `MaterialStateProperty` for our `AppBarTheme` in `ThemeData` and this kills value equality of `ThemeData`.

```dart
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(elevation: 1),
      ),
```

So the equality checks for rebuilding `ThemeData` no longer works correctly, due to the callback functions in it.


### Trigger rebuild - Take 2

To demo what happens when we do not have any custom `MaterialStateProperty` defined anywhere in our `ThemeData`, just remove or comment the `textButtonTheme` lines in the example theme:


```dart
ThemeData appLightTheme({double appBarElevation = 0}) => ThemeData(
      appBarTheme: AppBarTheme(
        elevation: appBarElevation,
        shadowColor: Colors.black,
        // Adding this will make the elevation tint color change animate too.
        shape: const RoundedRectangleBorder(),
      ),
      // textButtonTheme: TextButtonThemeData(
      //   style: TextButton.styleFrom(elevation: 1),
      // ),
    );
```

Again, let's start with a fresh build, we see that it has the 3 builds by the SDK as before, plus once for our theme change, but now also only once for the `Scaffold`, no animation rebuild!! This is already better and what we would have expected for the start of the above examples too.

Now again just trigger the rebuild:

https://github.com/flutter/flutter/assets/39990307/089ae042-0ce4-45e8-a211-3b64abed406b

And now we get the **expected** behavior, the `MaterialApp` rebuild is as ordered triggered once, but also the `Scaffold` was only rebuilt once, as it should have been, since there was nothing changed in it that needed to be animated. The value of the new `ThemeData` was identical to the previous one, so nothing to animate. However, as shown above earlier, as soon as we have an use any component theme that defines any `MaterialStatePorperty` the object equality is broken and we get all these extra rebuilds. Feel free to try with any other `MaterialStatePorperty` in any component sub theme in `ThemeData` and you will observer the same extra rebuild behavior.

This is imo a **VERY** bad thing when you are using custom component themes that contain `MaterialStatePorperty`, and any serious custom theme will need a lot of them.

This is caused by the current SDK design. I don't know of any workaround or fix to this rebuild issue.

