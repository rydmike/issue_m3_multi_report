## `DropdownMenu` leading icon usage layout issue

When using a leading icon in a `DropdownMenu` in the entry field, the menu nicely automatically aligns the text in the menu entry field, with the text part in the dropdown menu entries, shown when it is opened. This is demonstrated in the sample in **DropdownMenu1**.

However, if we also add a `leadingIcon` to a `DropdownMenuEntry`, we also get the extra leading space and things do not line up. This is demonstrated in the sample in **DropdownMenu2**.

## Expected results

Expect the `DropdownMenu` to align icon and text **also** when `leadingIcon`s are used both in the `DropdownMenu` and in its `DropdownMenuEntry` items.


| No leading icons in entries | Leading icons in some entries |
|-----------------------------|-------------------------------|
|                             |                               |


## Actual results

The `DropdownMenu` gets extra padding in `DropdownMenuEntry` items when they both have a leading icon, as a result the items do not line up:


## Fix proposal

The widget should detect if a leading icon is added in both `DropdownMenu` and in a used `DropdownMenuEntry` and not add the extra padding in the entries, when a leading icon is used in both.

The issue can **not** be fixed or worked around with a global app **theme** for the `DropdownMenuEntry` and its `MenuItemButton` used `style`, as there is no such theme property. This is a theme <-> widget property gap. The `DropdownMenuThemeData` should offer a `menuButtonStyle` of type `ButtonStyle`, and use that as its fall through style in normal `widget` ?? `theme` ?? `defaults` manner, for the style of the `MenuItemButton` composed by `DropdownMenuEntry`.

The issue demo shows that `DropdownMenuEntry` cannot be corrected with an ambient `menuButtonTheme`, even though `DropdownMenuEntry` is composed using a `MenuItemButton`, but it has a hard coded default style or only uses the `style` passed in per `DropdownMenuEntry`. It does not use the style from the ambient `menuButtonTheme` theme. This is probably for the best anyway, as it would probably not always fit to use the `style` from the ambient `menuButtonTheme`. Probably better that it gets its own independent themed `ButtonStyle` in `DropdownMenuThemeData`.

This layout issue **can** be fixed and worked around by applying the correct padding in each `style` in every `DropdownMenuEntry` in a `DropdownMenu`. This is something that cannot be fixed by a theme though. A custom style wrapper is needed for every used `DropdownMenu` widget in an application preferring a nicer layout style. Generally any wrapper to fix a style, defeats and negates the usage and applicability of theming an application. The `DropdownMenu3` shows this widget level style fix, it was also used to demonstrate the expected behavior. 


## Other noted issues

Some other noteworthy observation in addition to all other already reported issues about the `DropdownMenu`: 

* The default text style choice of `labelLarge` for the `DropdownMenu` text entry field is odd. Considering that the `DropdownMenuEntry` items use `boydLarge` by default, it does not match with it style wise. If one does not use M3, the sizes of text in a dropdown menu entry field, and the item entries **do** match by default, because in old 2014 Typography, that `ThemeData` defaults to, both `bodyLarge` and `labelLarge` use 14 dp, but in both **Typography2018** (actual M2 typography) and **Typography2021**  (M3 typography) `bodyLarge` is 16 dp and `labelLarge` 14 dp. And since the widget is primarily an M3 addition and follows its styles, one would expect the text styling between entry field and items to match in M3 by default.

* The default text style for the text field part in the dropdown menu is also a poor match with the default of an actual `TextField`. A `TextField` uses `titleLarge` in M2, which is 16 dp in all english like typography, and in M3 mode it uses `bodyLarge` which is 16 dp in the used Typography in M3. The dropdown menu text field entry using `labelLarge` does not match with it either. Matching the used `TextStyle` in a `TextField`is typically desired.

**DropdownMenu default `TexStyle` conclusion**
* The `labelLarge` seems to be a design error. It would make more sense design wise if the default was `bodyLarge`. In M3 mode that would align with the style used in its `DropdownMenuEntry` items and with the default for `TextField` in M3 mode, everything would match and look nice by default.


* The size of a `DropdownMenu` is also very difficult to size match to a `TextField`. This is something that is often desired on mobile devices in a column layout. On mobile the `TextField` is typically allowed to fill available width space with some padding, which it does by default. To match same width by `DropdownMenu` is difficult, it can either be sized by its content (default), or be set to a fixed width. It cannot be sized to width expand to a given width constraint automatically, like `TextField` and e.g., older `DropdownButtonForField` do. A mode where it does this would be nice, maybe it could do so if its `width` property is set to `double.infinity`, or optionally via some other toggle. With current version a `LayoutBuilder` is need to get the available width and pass that to the `width` of the `DropdownMenu`. 

The component theme setting in the issue demo sample demonstrates adjusting the text styles, so that they match size wise in all used theme modes. It also as applies the used inputDecorator theme to `ThemeData.dropdownMenuTheme` component theme, which it does not inherit by default. This is another inconsistency discussed in issue https://github.com/flutter/flutter/issues/131213.

Additionally, when the component theme is enabled, the sample app uses the width from a `LayoutBuilder` to make the **DropdownMenu 3** get same width as the `TextField` under it.

| No leading icons in entries | Leading icons in some entries |
|-----------------------------|-------------------------------|
|                             |                               |


## Other known DropdownMenu issues

- [ ] https://github.com/flutter/flutter/issues/131213
- [ ] https://github.com/flutter/flutter/issues/131120
- [ ] https://github.com/flutter/flutter/issues/130491
- [ ] https://github.com/flutter/flutter/issues/128502
- [ ] https://github.com/flutter/flutter/issues/127672
- [ ] https://github.com/flutter/flutter/issues/127568
- [ ] https://github.com/flutter/flutter/issues/126882
- [ ] https://github.com/flutter/flutter/issues/123797
- [x] https://github.com/flutter/flutter/issues/123631
- [x] https://github.com/flutter/flutter/issues/123615
- [ ] https://github.com/flutter/flutter/issues/123395
- [x] https://github.com/flutter/flutter/issues/120567
- [x] https://github.com/flutter/flutter/issues/120349
- [x] https://github.com/flutter/flutter/issues/119743

## Issue sample code

<details>
<summary>Code sample</summary>


```dart

```

</details>

## Used Flutter version

Channel master, 3.13.0-10.0.pre.37

<details>
  <summary>Doctor output</summary>

```console
flutter doctor -v
[✓] Flutter (Channel master, 3.13.0-10.0.pre.37, on macOS 13.4.1 22F770820d darwin-arm64, locale en-US)
    • Flutter version 3.13.0-10.0.pre.37 on channel master at /Users/rydmike/fvm/versions/master
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision bae1ac2f6f (39 minutes ago), 2023-07-26 10:31:23 -0700
    • Engine revision faf1121d01
    • Dart version 3.1.0 (build 3.1.0-348.0.dev)
    • DevTools version 2.25.0
    • If those were intentional, you can disregard the above warnings; however it is recommended to use "git" directly to perform update checks and upgrades.

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
