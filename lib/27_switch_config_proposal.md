## Switch proposal: Expose `_SwitchConfig` configuration

The `Switch` has many useful styling configuration options hidden in a private mixin class called `_SwitchConfig`. 

```dart
    mixin _SwitchConfig {
    double get trackHeight;
    double get trackWidth;
    double get switchWidth;
    double get switchHeight;
    double get switchHeightCollapsed;
    double get activeThumbRadius;
    double get inactiveThumbRadius;
    double get pressedThumbRadius;
    double get thumbRadiusWithIcon;
    List<BoxShadow>? get thumbShadow;
    MaterialStateProperty<Color> get iconColor;
    double? get thumbOffset;
    Size get transitionalThumbSize;
    int get toggleDuration;
}
```

https://github.com/flutter/flutter/blob/0ff68b8c610d54dd88585d0f97531208988f80b3/packages/flutter/lib/src/material/switch.dart#L1626


The addition of it is a part of what enables the same component to change its look from Material2 to Material3, by using its internal configuration options.

These configuration options would be very useful when creating custom `Switch` design using it. For example, currently the `Switch` in Flutter can currently **not even** mimic the "official" custom switch style used in Android system settings by Google's Pixel phones, shown below:



_Android System Settings Switch Style - Recorded on Pixel7Pro_

In this design, the **Switch** thumb is fixed size, and the height of the switch is more narrow and without a border.


While we could remove the borders from the M3 Switch and even fake the `Switch` thumb being fixed sized by adding a transparent icon, we cannot change the size of the thumb radius, or even height of the `Switch` track.




_Fake fixed thumb size is doable, but size changes are not_

## Proposal

Refactor `_SwitchConfig` class to a public class `SwitchConfig` and add it as a public configuration property `switchConfig` to the `Switch` widget and its `SwitchThemeData`.  

This type of configuration class would be much in-line with current sub-config classes `ButtonStyle` and `MenyStyle`, used in many themes and widgets. Considering those name precedents, maybe a better name would be `SwitchStyle`.

A public `SwitchStyle` (or `SwitchConfig`) would need to use mixin `Diagnosticable`" and implement `debugFillProperties`, `copyWith`, `merge`, `lerp`,  `hashCode` and `operator` ==. 

It should be reasonably straight forward to do this refactoring. 



## Fixed Switch Size Example Code

The code sample used for the fixed 

<details>
<summary>Code sample</summary>


```dart

```

</details>

## Used Flutter version

Channel master, 3.13.0-11.0.pre.24

<details>
  <summary>Flutter doctor</summary>

```
flutter doctor -v
[✓] Flutter (Channel master, 3.13.0-11.0.pre.24, on macOS 13.4.1 22F770820d darwin-arm64, locale en-US)
    • Flutter version 3.13.0-11.0.pre.24 on channel master at ...
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision 0ff68b8c61 (5 hours ago), 2023-07-28 04:09:52 -0400
    • Engine revision cfa5427dc4
    • Dart version 3.2.0 (build 3.2.0-11.0.dev)
    • DevTools version 2.25.0
    • If those were intentional, you can disregard the above warnings; however it is recommended to use "git" directly to
      perform update checks and upgrades.

[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.0)
    • Android SDK at /Users/rydmike/Library/Android/sdk
    • Platform android-33, build-tools 33.0.0
    • Java binary at: /Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build 17.0.6+0-17.0.6b802.4-9586694)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 14.3.1)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Build 14E300c
    • CocoaPods version 1.11.3

[✓] Chrome - develop for the web
    • Chrome at /Applications/Google Chrome.app/Contents/MacOS/Google Chrome

[✓] Android Studio (version 2022.2)
    • Android Studio at /Applications/Android Studio.app/Contents
    • Flutter plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/6351-dart
    • Java version OpenJDK Runtime Environment (build 17.0.6+0-17.0.6b802.4-9586694)

[✓] IntelliJ IDEA Community Edition (version 2023.1.3)
    • IntelliJ at /Applications/IntelliJ IDEA CE.app
    • Flutter plugin version 74.0.4
    • Dart plugin version 231.9161.14

[✓] VS Code (version 1.79.2)
    • VS Code at /Applications/Visual Studio Code.app/Contents
    • Flutter extension version 3.62.0

[✓] Connected device (2 available)
    • macOS (desktop) • macos  • darwin-arm64   • macOS 13.4.1 22F770820d darwin-arm64
    • Chrome (web)    • chrome • web-javascript • Google Chrome 115.0.5790.114

[✓] Network resources
    • All expected network resources are available.

```

</details>
