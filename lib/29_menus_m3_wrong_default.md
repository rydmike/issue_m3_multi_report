## TextStyles in Menus do not follow Material-3 spec

Based on Material-3 specification menus should use text style `labelLarge` (M3 14dp) for its menu items. For a `Textfield` part the default for `Textfield`should be used `bodyLarge` (M3 16dp). They currently do not always do so.

See spec: https://m3.material.io/components/menus/specs#ad796ca6-3d66-4e7e-9322-c0d93bff5423

The supplied code sample can be used to show and demonstrate the wrong text styles.

## Expect

Menu items in all menus in Material-3 mode to follow spec `labelLarge` (M3 14dp) and `TextField` part of `DropdownMenu` to follow `TextField` spec for its default text styles `bodyLarge` (M3 16dp).

### Actual

Menu items in all menus in Material-3 mode do **not** to follow M3 spec and `TextField` part of `DropdownMenu` does not follow `TextField` spec.


Currently `PopupMenuButton` does use correct spec when using `PopupMenuIem` and `CheckedPopupMenuItem`, but **not** if using it with `ListTiles`, it then uses `bodyLarge` (M3 16dp). This is discussed here: https://github.com/flutter/flutter/pull/131609#issuecomment-1659024603

All the new M3 menus, like `MenuBar`, `MenuAnchor` and `DropdownMenu` are using `bodyLarge` by default. Changing this default will be breaking, but they are currently not according to M3 specification, see spec https://m3.material.io/components/menus/specs#ad796ca6-3d66-4e7e-9322-c0d93bff5423

The only place where new menus use `labelLarge` is the `TextField` part in the `DropdownMenu` where the input field uses `labelLarge`, but the menu that it opens uses `bodyLarge` on its items. As do all other menu in Flutter that come from `MenuItemButton` used in e.g. `MenuAnchor` and `MenuBar`, this is coming from:

https://github.com/flutter/flutter/blob/bd64bf5f923fa79635f2971531d9dfd717046963/packages/flutter/lib/src/material/menu_anchor.dart#L3792

The ironical part is that for the `TextField` part in a `DropdownMenu` the `labelLarge` is also wrong.

If we look at **Jetpack Compose** and what a `DropdownMenu` looks like there. We can see that the input field is actually `bodyLarge` like the default in a `TextField`. In it the items are also correctly using the `labelLarge` size like the M3 spec states for the items, so they are a bit smaller, but **do** follow the M3 spec for the items. 

The text input field then just follows the spec for the `TextField`, making it fit and match well when used together with a default styled `TextField`, which is a very common use case.

![image](https://github.com/flutter/flutter/assets/39990307/0954c23e-19c2-480a-ad5c-31a6e046f803)

The M3 web spec is a bit vague on the correct default for the `TextField` in a `DropdownMenu`, but it is reasonable to assume that  **Jetpack Compose** gets this right, since the style also matches what is expected on the input part when a `DropdownMenu` is used in forms together with `TextField`s.


This means that **Flutter** basically has its `TextStyles` for input field and menu items in all the new menus reversed. When using the `PopupMenuButton` we only get incorrect style if we populate it with `ListTile`s, otherwise with recent changes, it is now correct. 

### First notice

The incorrect text styles where first mentioned and noted as a side topic in this issue https://github.com/flutter/flutter/issues/131350, it is here lifted out to its own issue.


## Other known DropdownMenu Issues

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


## Images

## Example code

Add here


## Used Flutter version

Channel master, 3.13.0-15.0.pre.16

<details>
  <summary>Flutter doctor</summary>

```
flutter doctor -v
[✓] Flutter (Channel master, 3.13.0-15.0.pre.16, on macOS 13.4.1 22F770820d darwin-arm64,
    locale en-US)
    • Flutter version 3.13.0-15.0.pre.16 on channel master at
    • Framework revision fcd5a6c478 (3 hours ago), 2023-08-01 06:06:40 -0400
    • Engine revision 25b9d1088d
    • Dart version 3.2.0 (build 3.2.0-19.0.dev)
    • DevTools version 2.25.0
    • If those were intentional, you can disregard the above warnings; however it is
      recommended to use "git" directly to perform update checks and upgrades.

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
