## Issue: Cannot theme progress indicators, many properties missing

The `ProgressIndicatorThemeData` is missing many key properties from `LinearProgressIndicator` and `CircularProgressIndicator` making it impossible to theme their styles.

## Expect

Expect to be able to style the `LinearProgressIndicator` and `CircularProgressIndicator` with their `ProgressIndicatorThemeData` by also adding styles for properties:

- `borderRadius` The border radius of both the indicator and the linear track on a `LinearProgressIndicator`. https://github.com/flutter/flutter/blob/5d2c9d0933b9946d2eff8477edaceb9c91f61998/packages/flutter/lib/src/material/progress_indicator.dart#L291
- `strokeWidth`  The width of the line used to draw the circle on a `CircularProgressIndicator`. https://github.com/flutter/flutter/blob/5d2c9d0933b9946d2eff8477edaceb9c91f61998/packages/flutter/lib/src/material/progress_indicator.dart#L564
- `strokeAlign` The relative position of the stroke on a `CircularProgressIndicator`. https://github.com/flutter/flutter/blob/5d2c9d0933b9946d2eff8477edaceb9c91f61998/packages/flutter/lib/src/material/progress_indicator.dart#L565
- `strokeCap` The progress indicator's line ending on a `CircularProgressIndicator`. https://github.com/flutter/flutter/blob/5d2c9d0933b9946d2eff8477edaceb9c91f61998/packages/flutter/lib/src/material/progress_indicator.dart#L568

### Actual

The newer `LinearProgressIndicator` and `CircularProgressIndicator` properties listed above that were added in their enhancements, e.g. in [PR #122664](https://github.com/flutter/flutter/pull/122664) were forgotten or neglected to be added to `ProgressIndicatorThemeData` and are now missing, this is causing theming issues. 

The properties cannot be found in the latest version of `ProgressIndicatorThemeData`: 

https://github.com/flutter/flutter/blob/5d2c9d0933b9946d2eff8477edaceb9c91f61998/packages/flutter/lib/src/material/progress_indicator_theme.dart#L32C5-L32C5

Therefore, we cannot theme the `LinearProgressIndicator` and `CircularProgressIndicator` to their desired style.


## Example code

Code only via provided repo links showing the issue.


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
