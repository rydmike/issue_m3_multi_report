## NavigationDrawer has wrong width

The `NavigationDrawer` drawer width does not follow Material-3 specification.

**Reference:** Material-3 Navigation Drawer specification https://m3.material.io/components/navigation-drawer/specs

![Drawer-M3-spec](https://user-images.githubusercontent.com/39990307/227427692-07d1e352-1714-47ce-a783-229a0c64eca8.png)

## Expected Results

Expected default `NavigationDrawer` to follow the Material-3 specification in Material 3 mode, and be **360 dp wide**.

| M3 NavigationDrawer Width | M2 NavigationDrawer Width |
|---------------------------|---------------------------|
| ![Drawer-M3-360dp](https://user-images.githubusercontent.com/39990307/227426199-131616e7-27c0-40a6-b5cd-06f3018fdad1.png) | ![Drawer-M2-304dp](https://user-images.githubusercontent.com/39990307/227426420-7fac0dbe-30e9-4408-b2b9-90e44266a41e.png) |
| ![Drawer-M3-surface-360dp](https://user-images.githubusercontent.com/39990307/227426317-4aac4911-1df2-4de6-9a2a-6b1efc5c6fd1.png)| ![Drawer-M2-surface-304dp](https://user-images.githubusercontent.com/39990307/227426469-ca2d5221-8631-4e7b-905c-daad4f89512e.png)|

## Actual Results

* The width is 304 dp in both Material-2 and Material-3 mode.
* It should be 360 dp in Material-3 mode.

| M3 NavigationDrawer Width | M2 NavigationDrawer Width |
|---------------------------|---------------------------|
| ![Drawer-M3-304dp](https://user-images.githubusercontent.com/39990307/227426675-88102e70-f174-4b3c-8d99-c03d0cd60e06.png) | ![Drawer-M2-304dp](https://user-images.githubusercontent.com/39990307/227426420-7fac0dbe-30e9-4408-b2b9-90e44266a41e.png) |
| ![Drawer-M3-surface-304dp](https://user-images.githubusercontent.com/39990307/227426718-7be38039-5d57-462a-9dc4-e3af453c1b4c.png)| ![Drawer-M2-surface-304dp](https://user-images.githubusercontent.com/39990307/227426469-ca2d5221-8631-4e7b-905c-daad4f89512e.png)|


## Cause

In Flutter the `NavigationDrawer` gets its width from `Drawer`, one of its building blocks, that if not specified uses a const value from file **drawer.dart** that has value **304**:

```dart
const double _kWidth = 304.0;
``` 

## Modifying the NavigationDrawer Width

Users can currently only modify the width of the `NavigationDrawer` by specifying a `DrawerThemeData` width different width, that then gets used by `Drawer` that `NavigationDrawer` is using.

There is no widget property in `NavigationDrawer`, that would be passed to `Drawer` it uses, or any property in theme `NavigationDrawerThemeData` to control the width. There is also no token from the Material-2 token database that would generate any default of width of **360 dp** for the  `NavigationDrawer`.

**Maybe consider** adding a `drawerWidth` to `NavigationDrawer` and `NavigationDrawerThemeData` to make it more obvious how to customize the width of the `NavigationDrawer`.

## Issue Sample Code

<details>
<summary>Code sample</summary>

```dart
// MIT License
//
// Copyright (c) 2023 Mike Rydstrom
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
import 'package:flutter/material.dart';

// A seed color for the M3 ColorScheme.
const Color seedColor = Color(0xFF6750A4);
// Make M3 ColorSchemes from a seed color.
final ColorScheme schemeLight = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: seedColor,
);
final ColorScheme schemeDark = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: seedColor,
);

// Example theme
ThemeData demoTheme(Brightness mode, bool useMaterial3) {
  return ThemeData(
    colorScheme: mode == Brightness.light ? schemeLight : schemeDark,
    useMaterial3: useMaterial3,
    visualDensity: VisualDensity.standard,
  );
}

void main() {
  runApp(const IssueDemoApp());
}

class IssueDemoApp extends StatefulWidget {
  const IssueDemoApp({super.key});

  @override
  State<IssueDemoApp> createState() => _IssueDemoAppState();
}

class _IssueDemoAppState extends State<IssueDemoApp> {
  bool useMaterial3 = true;
  ThemeMode themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: demoTheme(Brightness.light, useMaterial3),
      darkTheme: demoTheme(Brightness.dark, useMaterial3),
      home: Scaffold(
        drawer: const NavigationDrawerShowcase(),
        appBar: AppBar(
          title: const Text('NavigationDrawer Width'),
          actions: [
            IconButton(
              icon: useMaterial3
                  ? const Icon(Icons.filter_3)
                  : const Icon(Icons.filter_2),
              onPressed: () {
                setState(() {
                  useMaterial3 = !useMaterial3;
                });
              },
              tooltip: "Switch to Material ${useMaterial3 ? 2 : 3}",
            ),
            IconButton(
              icon: themeMode == ThemeMode.dark
                  ? const Icon(Icons.wb_sunny_outlined)
                  : const Icon(Icons.wb_sunny),
              onPressed: () {
                setState(() {
                  if (themeMode == ThemeMode.light) {
                    themeMode = ThemeMode.dark;
                  } else {
                    themeMode = ThemeMode.light;
                  }
                });
              },
              tooltip: "Toggle brightness",
            ),
          ],
        ),
        body: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 8),
        Text(
          'NavigationDrawer has wrong width in M3',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        const Text(
          'ISSUE: NavigationDrawer has wrong width in M3 mode.\n'
              '\n'
              'EXPECT: NavigationDrawer width to match M3 spec in M3 mode '
              'and be 360dp, it is 304dp and using the M2 spec.',
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.all(32.0),
          child: DrawerDesktopWrapper(),
        ),
        const SizedBox(height: 16),
        const ShowColorSchemeColors(),
      ],
    );
  }
}

class DrawerDesktopWrapper extends StatelessWidget {
  const DrawerDesktopWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          removeTop: true,
          removeLeft: true,
          removeRight: true,
          child: const SizedBox(
            height: 320,
            child: NavigationDrawerShowcase(),
          ),
        ),
      ],
    );
  }
}

class NavigationDrawerShowcase extends StatefulWidget {
  const NavigationDrawerShowcase({
    super.key,
  });

  @override
  State<NavigationDrawerShowcase> createState() =>
      _NavigationDrawerShowcaseState();
}

class _NavigationDrawerShowcaseState extends State<NavigationDrawerShowcase> {
  int selectedIndex = 0;
  late final GlobalKey _key = GlobalKey();
  RenderBox? renderBox;

  _afterLayout(_) {
    setState(() {
      if (_key.currentContext?.findRenderObject() != null) {
        renderBox = _key.currentContext!.findRenderObject() as RenderBox;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  @override
  Widget build(BuildContext context) {
    final double width = renderBox?.size.width ?? 0;
    return NavigationDrawer(
      key: _key,
      selectedIndex: selectedIndex,
      onDestinationSelected: (int value) {
        setState(() {
          selectedIndex = value;
        });
      },
      children: <Widget>[
        const SizedBox(height: 16),
        const NavigationDrawerDestination(
          icon: Badge(
            label: Text('26'),
            child: Icon(Icons.chat_bubble),
          ),
          label: Text('Chat'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.beenhere),
          label: Text('Tasks'),
        ),
        const Divider(),
        const NavigationDrawerDestination(
          icon: Icon(Icons.create_new_folder),
          label: Text('Folder'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.logout),
          label: Text('Logout'),
        ),
        const SizedBox(height: 16),
        Text('Drawer is $width dp wide', textAlign: TextAlign.center),
      ],
    );
  }
}

/// Draw a number of boxes showing the colors of key theme color properties
/// in the ColorScheme of the inherited ThemeData and its color properties.
class ShowColorSchemeColors extends StatelessWidget {
  const ShowColorSchemeColors({super.key, this.onBackgroundColor});

  /// The color of the background the color widget are being drawn on.
  ///
  /// Some of the theme colors may have semi transparent fill color. To compute
  /// a legible text color for the sum when it shown on a background color, we
  /// need to alpha merge it with background and we need the exact background
  /// color it is drawn on for that. If not passed in from parent, it is
  /// assumed to be drawn on card color, which usually is close enough.
  final Color? onBackgroundColor;

  // Return true if the color is light, meaning it needs dark text for contrast.
  static bool _isLight(final Color color) =>
      ThemeData.estimateBrightnessForColor(color) == Brightness.light;

  // On color used when a theme color property does not have a theme onColor.
  static Color _onColor(final Color color, final Color bg) =>
      _isLight(Color.alphaBlend(color, bg)) ? Colors.black : Colors.white;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool useMaterial3 = theme.useMaterial3;
    const double spacing = 4;

    // Grab the card border from the theme card shape
    ShapeBorder? border = theme.cardTheme.shape;
    // If we had one, copy in a border side to it.
    if (border is RoundedRectangleBorder) {
      border = border.copyWith(
        side: BorderSide(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      );
      // If
    } else {
      // If border was null, make one matching Card default, but with border
      // side, if it was not null, we leave it as it was.
      border ??= RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(useMaterial3 ? 12 : 4)),
        side: BorderSide(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      );
    }

    // Get effective background color.
    final Color background =
        onBackgroundColor ?? theme.cardTheme.color ?? theme.cardColor;

    // Wrap this widget branch in a custom theme where card has a border outline
    // if it did not have one, but retains its ambient themed border radius.
    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: CardTheme.of(context).copyWith(
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          shape: border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'ColorScheme Colors',
              style: theme.textTheme.titleMedium,
            ),
          ),
          Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: spacing,
            runSpacing: spacing,
            children: <Widget>[
              ColorCard(
                label: 'Primary',
                color: colorScheme.primary,
                textColor: colorScheme.onPrimary,
              ),
              ColorCard(
                label: 'on\nPrimary',
                color: colorScheme.onPrimary,
                textColor: colorScheme.primary,
              ),
              ColorCard(
                label: 'Primary\nContainer',
                color: colorScheme.primaryContainer,
                textColor: colorScheme.onPrimaryContainer,
              ),
              ColorCard(
                label: 'onPrimary\nContainer',
                color: colorScheme.onPrimaryContainer,
                textColor: colorScheme.primaryContainer,
              ),
              ColorCard(
                label: 'Secondary',
                color: colorScheme.secondary,
                textColor: colorScheme.onSecondary,
              ),
              ColorCard(
                label: 'on\nSecondary',
                color: colorScheme.onSecondary,
                textColor: colorScheme.secondary,
              ),
              ColorCard(
                label: 'Secondary\nContainer',
                color: colorScheme.secondaryContainer,
                textColor: colorScheme.onSecondaryContainer,
              ),
              ColorCard(
                label: 'on\nSecondary\nContainer',
                color: colorScheme.onSecondaryContainer,
                textColor: colorScheme.secondaryContainer,
              ),
              ColorCard(
                label: 'Tertiary',
                color: colorScheme.tertiary,
                textColor: colorScheme.onTertiary,
              ),
              ColorCard(
                label: 'on\nTertiary',
                color: colorScheme.onTertiary,
                textColor: colorScheme.tertiary,
              ),
              ColorCard(
                label: 'Tertiary\nContainer',
                color: colorScheme.tertiaryContainer,
                textColor: colorScheme.onTertiaryContainer,
              ),
              ColorCard(
                label: 'on\nTertiary\nContainer',
                color: colorScheme.onTertiaryContainer,
                textColor: colorScheme.tertiaryContainer,
              ),
              ColorCard(
                label: 'Error',
                color: colorScheme.error,
                textColor: colorScheme.onError,
              ),
              ColorCard(
                label: 'on\nError',
                color: colorScheme.onError,
                textColor: colorScheme.error,
              ),
              ColorCard(
                label: 'Error\nContainer',
                color: colorScheme.errorContainer,
                textColor: colorScheme.onErrorContainer,
              ),
              ColorCard(
                label: 'onError\nContainer',
                color: colorScheme.onErrorContainer,
                textColor: colorScheme.errorContainer,
              ),
              ColorCard(
                label: 'Background',
                color: colorScheme.background,
                textColor: colorScheme.onBackground,
              ),
              ColorCard(
                label: 'on\nBackground',
                color: colorScheme.onBackground,
                textColor: colorScheme.background,
              ),
              ColorCard(
                label: 'Surface',
                color: colorScheme.surface,
                textColor: colorScheme.onSurface,
              ),
              ColorCard(
                label: 'on\nSurface',
                color: colorScheme.onSurface,
                textColor: colorScheme.surface,
              ),
              ColorCard(
                label: 'Surface\nVariant',
                color: colorScheme.surfaceVariant,
                textColor: colorScheme.onSurfaceVariant,
              ),
              ColorCard(
                label: 'onSurface\nVariant',
                color: colorScheme.onSurfaceVariant,
                textColor: colorScheme.surfaceVariant,
              ),
              ColorCard(
                label: 'Outline',
                color: colorScheme.outline,
                textColor: colorScheme.background,
              ),
              ColorCard(
                label: 'Outline\nVariant',
                color: colorScheme.outlineVariant,
                textColor: colorScheme.onBackground,
              ),
              ColorCard(
                label: 'Shadow',
                color: colorScheme.shadow,
                textColor: _onColor(colorScheme.shadow, background),
              ),
              ColorCard(
                label: 'Scrim',
                color: colorScheme.scrim,
                textColor: _onColor(colorScheme.scrim, background),
              ),
              ColorCard(
                label: 'Inverse\nSurface',
                color: colorScheme.inverseSurface,
                textColor: colorScheme.onInverseSurface,
              ),
              ColorCard(
                label: 'onInverse\nSurface',
                color: colorScheme.onInverseSurface,
                textColor: colorScheme.inverseSurface,
              ),
              ColorCard(
                label: 'Inverse\nPrimary',
                color: colorScheme.inversePrimary,
                textColor: colorScheme.inverseSurface,
              ),
              ColorCard(
                label: 'Surface\nTint',
                color: colorScheme.surfaceTint,
                textColor: colorScheme.onPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A [SizedBox] with a [Card] and string text in it. Used in this demo to
/// display theme color boxes.
///
/// Can specify label text color and background color.
class ColorCard extends StatelessWidget {
  const ColorCard({
    super.key,
    required this.label,
    required this.color,
    required this.textColor,
    this.size,
  });

  final String label;
  final Color color;
  final Color textColor;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    const double fontSize = 11;
    const Size effectiveSize = Size(86, 58);

    return SizedBox(
      width: effectiveSize.width,
      height: effectiveSize.height,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        color: color,
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: textColor, fontSize: fontSize),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

```
</details>

## Used Flutter Version

Channel master, 3.9.0-16.0.pre.42

<details>
  <summary>Flutter doctor</summary>

```
flutter doctor -v          
[✓] Flutter (Channel master, 3.9.0-16.0.pre.42, on macOS 13.2.1 22D68 darwin-arm64, locale en-US)
    • Flutter version 3.9.0-16.0.pre.42 on channel master at /Users/rydmike/fvm/versions/master
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision a8afbfa22e (36 minutes ago), 2023-03-24 00:00:20 -0400
    • Engine revision 1da070c57c
    • Dart version 3.0.0 (build 3.0.0-362.0.dev)
    • DevTools version 2.22.2
    • If those were intentional, you can disregard the above warnings; however it is recommended
      to use "git" directly to perform update checks and upgrades.

[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.0)
    • Android SDK at /Users/rydmike/Library/Android/sdk
    • Platform android-33, build-tools 33.0.0
    • Java binary at: /Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build 11.0.15+0-b2043.56-8887301)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 14.2)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Build 14C18
    • CocoaPods version 1.11.3

[✓] Chrome - develop for the web
    • Chrome at /Applications/Google Chrome.app/Contents/MacOS/Google Chrome

[✓] Android Studio (version 2022.1)
    • Android Studio at /Applications/Android Studio.app/Contents
    • Flutter plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/6351-dart
    • Java version OpenJDK Runtime Environment (build 11.0.15+0-b2043.56-8887301)

[✓] IntelliJ IDEA Community Edition (version 2022.3.3)
    • IntelliJ at /Applications/IntelliJ IDEA CE.app
    • Flutter plugin version 72.1.4
    • Dart plugin version 223.8888

[✓] VS Code (version 1.76.2)
    • VS Code at /Applications/Visual Studio Code.app/Contents
    • Flutter extension version 3.60.0

[✓] Connected device (2 available)
    • macOS (desktop) • macos  • darwin-arm64   • macOS 13.2.1 22D68 darwin-arm64
    • Chrome (web)    • chrome • web-javascript • Google Chrome 111.0.5563.110

[✓] Network resources
    • All expected network resources are available.

```

</details>


- - -

I could stop here and say it is in the Material-3 specification, it should be used, but that would not be very me 😄.

I would like to take this opportunity to discuss the Material-3 specification default value for the `NavigationDrawer` and how it looks when used on different sized phones.

Ping @rodydavis and anybody else on the Material design team. Below my thoughts, input and a discussion of some design considerations, when it comes to the Drawer's width.

## Drawer Width Design Considerations

The `NavigationDrawer` is primarily intended to be used on phone sized devices and should look good and work well on phones, typically when used in vertical orientation.

Flutter has up until now defaulted to using above fixed width of **304 dp** on its `Drawer` implementation.

Was this the Material-2 design specification? No it actually was not, it is only a default that Flutter implementation has used that fit well on most phones. The Flutter framework never actually implemented the correct Material-2 drawer width specification.

What we can still find in the available Material-2 specification, that the width should be, width of the phone in vertical-mode minus **56 dp**.

**Reference**: Material-2 Drawer specification https://m2.material.io/components/navigation-drawer#specs

![Drawer-M2-Spec](https://user-images.githubusercontent.com/39990307/227428500-206cc511-cb83-47f0-9858-31b441f55c38.png)


Additionally, in Flutter code comments we can find this extra information:

**Mobile:**
* Width = Screen width − 56 dp
* Maximum width: 320 dp
* Maximum width applies only when using a left nav. When using a right nav, the panel can cover the full width of the screen.

**Desktop/Tablet:**
* The maximum width for a left nav is 400 dp.
* The right nav can vary depending on content.

![Drawer-M2-Flutter-Comments](https://user-images.githubusercontent.com/39990307/227428699-360994ec-1760-4f18-8543-95b53b3de5d4.png)


Why bring up this? Because the device variable `Drawer` width as specified in Material-2 design makes a lot of sense. It creates a design that is both visually much more appealing and also more usable than the current Material-3 specification using fixed value of **360 dp**. It varies with slight phone width variations, leaves a minimum constant gap at the end side, making it easier to fling the drawer back with your thumb or tap background to dismiss it.

The best way to demonstrate these design differences, and why the actual past Material-2 design specification, results in a better design than both Flutter's past/current 304 dp fixed size, and the new Material-3 360 dp fixed size, is to show them visually on different sized phones.

## A "Brief" Drawer Width Design Study

Below a comparison of what a Drawer looks like on phones of different sizes when you open it, and then toggle the theme between Material-2 and Material-3.

For demonstration convenience, this uses [Themes Playground v7 final beta (7.0.0-dev.3)](https://rydmike.com/flexcolorscheme/themesplayground-v7/#/) a companion app to [FlexColorScheme](https://docs.flexcolorscheme.com/), using a custom Material-3 theme that in this beta defaults the **Drawer** to the Material-3 360dp specification in Material-3 mode, and to current Flutter default 304 dp in Material-2 mode.

We can use the **Themes Playground** mock device simulator to show the Drawer on devices of commonly used sizes. We can also use the **Themes Playground**, to quickly visually compare what a Drawer using the new Material-3 spec value of 360dp looks like, compared to what it would like, if it would use actual Material-2 spec width, on a device of that size, while otherwise using a Material-3 designed Drawer with elevation tint and rounded edges.


### Small Device Width (iPhone SE)

On a small device we can see that using the M3 width **360 dp**, almost entirely covers the width of the small phone. The Flutter fixed width of **304 dp** actually works better on a small phone.

https://user-images.githubusercontent.com/39990307/227428965-63b10e32-9425-4763-b3fc-c909c6c46127.mov

#### Comparing 360dp fixed width to 56dp edge space on iPhone SE

Using the variable width with 56 dp space on the edge, looks and works best of the options on a small phone, shown below.

| Using M3 360dp Width | Variable width, 56dp edge space (M2 spec) |
|----------------------|-------------------------------------------|
| ![Screenshot 2023-03-24 at 2 05 22](https://user-images.githubusercontent.com/39990307/227429053-603cea09-b0ad-490d-80ab-9b6a51ea9834.png) | ![Screenshot 2023-03-24 at 2 05 59](https://user-images.githubusercontent.com/39990307/227429102-2f57714f-e683-4598-809b-575649425f86.png) |

### Very Small Device Width - Width 360 dp or Lower (Galaxy S20)

There are still many phones around that have only a device pixel width of 360 dp, rarely less though. On such small devices we can see that using the M3 width **360 dp**, covers the width of the small phone entirely. This does not look very good, and also UX suffers. The only default way to close the Drawer is now to fling or swipe it back, there is no visible background area that can be tapped to dismiss it.

The past Flutter fixed width of **304 dp** actually works better on a narrow phone. This is demonstrated by using a **Samsung Galaxy S20** device, that here represents a small width, 360 dp wide phone.

https://user-images.githubusercontent.com/39990307/227429398-669cd96d-bbe2-4b17-860b-c28508af2864.mov

#### Comparing 360dp fixed width to 56dp edge space on Galaxy S20

Below we can again we can show that using the variable width with 56dp space on the edge, looks and works best of the options on narrow phones. There is, of course a risk that the width of the Drawer gets too narrow to fit needed content on very narrow phones. However, the 360 dp width pretty much represents the smallest width one might still run into today on commonly used phones.

| Using M3 360dp Width | Variable width, 56dp edge space (M2 spec) |
|----------------------|-------------------------------------------|
| ![Screenshot 2023-03-24 at 2 09 25](https://user-images.githubusercontent.com/39990307/227429438-0143b7bb-929a-4922-9e4b-f84408009d1a.png) | ![GalaxyS20-304dp](https://user-images.githubusercontent.com/39990307/227430168-7e1427f5-095c-438e-95da-1f335177af27.png) |


### Medium Device Width (iPhone 13)

On a medium width device we can see that using the M3 width **360 dp**, while not so close to the edge anymore, it is still a bit uncomfortably close. The Flutter fixed width of **304 dp** is however now looking too narrow.

https://user-images.githubusercontent.com/39990307/227430336-ebf2a880-f9d7-434e-9daf-7a59ab49b464.mov

#### Comparing 360dp fixed width to 56dp edge space on iPhone13

Using the variable width with 56dp space on the edge, looks and works best of the options on medium sized phone, this is shown below.

| Using M3 360dp Width | Variable width, 56dp edge space (M2 spec) |
|----------------------|-------------------------------------------|
| ![iPhone13-360dp](https://user-images.githubusercontent.com/39990307/227430509-7a9e5117-154d-4772-b53d-fa12e6c74b03.png) | ![iPhone13-334dp](https://user-images.githubusercontent.com/39990307/227430573-50201ccf-bd10-4ed3-b70c-e304fdc0ae8e.png) |


### Medium+ Device Width and Very Tall (Sony Experia 1 II)

On a medium+ width device, that is a bit wider device pixel wise than an iPhone 13, but a lot taller, we can see that using the M3 width **360 dp** is looking mostly OK, maybe the shown background is a bit narrow, but not so bad. The Flutter fixed width of **304 dp** is however now looking much too narrow.

https://user-images.githubusercontent.com/39990307/227430647-e1ecd3ad-e3df-4579-9391-c7892735152d.mov

#### Comparing 360dp fixed width to 56dp edge space on Sony Experia 1 II

Using the variable width with 56 dp space on the edge, looks and works best of the options here too. In this case the difference is only 5 dp to the M3 spec default, so the M3 spec default is also a reasonably good fit.

| Using M3 360dp Width | Variable width, 56dp edge space (M2 spec) |
|----------------------|-------------------------------------------|
| ![Sony-Experia-360dp](https://user-images.githubusercontent.com/39990307/227430714-d5f2d879-7b34-4c50-afc3-090e3508254a.png) | ![Sony-Experia-355dp](https://user-images.githubusercontent.com/39990307/227430737-f38d75c1-9b20-4d51-8aec-c6c3e2d87621.png) |

### Large Device Width (iPhone 13 Pro Max)

On a large width device we can see that using the M3 width **360 dp** looks and works fine. The Flutter fixed width of **304 dp** is obviously now looking way too narrow and not well sized to such a wide device.

https://user-images.githubusercontent.com/39990307/227430851-b152fcc4-ed47-4571-a649-39b4af549b4a.mov

#### Comparing 360dp fixed width to 56dp edge space on Phone 13 Pro Max

Using the variable width with 56 dp space on the edge, works well too, but so does the M3 spec default of 360 dp.

| Using M3 360dp Width | Variable width, 56dp edge space (M2 spec) |
|----------------------|-------------------------------------------|
| ![iPhone13ProMax-360dp](https://user-images.githubusercontent.com/39990307/227430920-aa9791a7-3645-407e-876e-a00289c5a973.png) | ![iPhone13ProMax-372dp](https://user-images.githubusercontent.com/39990307/227430960-b9162613-e890-43c8-847d-9adc4d35c6d9.png) |


### Specification Considerations

The comment in the Flutter source code about how Material-2 Drawer spec should use an edge gap of 56 dp, matches the existing web published Material-2 spec. I could however not find any mention of the in the Flutter source comment, that it should also be constrained to max width **320 dp**.

A maximum constraint on the Drawer width does however make sense. The Material 3 design width 360 dp and now generally wider phones, makes the **360 dp** value a good fit for that constraint. However, without leaving what still seems like an appropriate minimum edge gap of **56 dp**, a **360 dp** fixed width Drawer is not a design that fits well on many phones.

Only very few phone devices have a viewport that is so wide that they would get a maximum width constrained 360 dp wide Drawer, and still have an edge gap that is 56 dp or larger. Some such devices are e.g. iPhone 13/14 Pro Max, with their massive 428 dp wide viewport. Above this would be represented by the "Using M3 360dp Width" case. This looks totally fine too, instead of the right side 56 dp space.

All other phones in the above examples, would get the 56dp edge result and the Drawer would be more narrow than its max constraint of 360 dp.

### Conclusion: A 360 dp Fixed Width Drawer Is Too Wide

No other phones in the used examples are as wide as the iPhone 13/14 Pro Max. I searched and did not find many on the market that have a width viewport that is as wide. For example, Pixel 6/7 Pro, and Samsung Ultra S20...S23 have a 412 dp wide viewport. Their Drawer would still only become 356 dp wide. A **360 dp** wide Drawer could even be considered too wide for these flagship Android phones.

The only phones that a **360 dp** fixed width wide Drawer fits comfortable on are, iPhone 14 Plus, 12/13/14 Pro Max. While certainly a popular range of phones, they are not a good representation of the global market.

The **Material 3 design** specification does however not mention anywhere that **360 dp** should be used as the max width constraint on phones, and that at least a **56 dp** edge gap should be left. It does in fact specify **360 dp** as the default fixed width on a navigation Drawer

**My suggestion** is that the fixed M3 spec drawer width of 360 dp should be reconsidered, maybe using some of the findings and suggestions above.


## Advice to devs that want to use M3

Don't use the current M3 specified 360 dp width on navigation drawers. You still have complete control control over the width of the `NavigationDrawer` in Flutter, albeit at the moment only a bit awkwardly via the `DrawerTheme`. Use a width that fits with your content and design.

