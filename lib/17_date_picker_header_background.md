## (Material3) DatePicker Divider cannot be removed or styled, does not fit with custom header background

When styling the `DatePicker` header background to some other color than default surface color and using M3 mode, the `DatePicker` is left with an extra not needed `Divider` separator that looks out of place.

Run the attached sample to see the issue.

### Expected results

Expect to be able to change the background color of `DatePicker` from default, and for it too have a uniform header color, like so:

| Material 3 | Material 2 |
|------------|------------|
| ![Screenshot 2023-05-12 at 0 22 29](https://github.com/flutter/flutter/assets/39990307/b8adb090-9974-4463-8913-392a16040f86)|            ![Screenshot 2023-05-12 at 0 22 21](https://github.com/flutter/flutter/assets/39990307/30816dbb-9d92-45d2-87f4-1293beae1858)|

### Actual results

Actual result has a `Divider` that looks totally out of place when the header color is not surface colored. Only M3 has the out of place `Divider` when using none default header color, M2 mode does not.

| Material 3 - FAIL | Material 2 - OK|
|------------|------------|
| ![Screenshot 2023-05-12 at 0 21 30](https://github.com/flutter/flutter/assets/39990307/e0bfde06-2973-496b-9ed5-d18846e54fff)            | ![Screenshot 2023-05-12 at 0 21 18](https://github.com/flutter/flutter/assets/39990307/454fd33f-856c-4fc9-b7b3-d1738f442b19) |

### Issue cause

The `Divider` is hard coded to be shown in M3 mode and cannot be modified.

Here:
https://github.com/flutter/flutter/blob/fa117aad283ba930a7a79b472843b19e52f543bd/packages/flutter/lib/src/material/date_picker.dart#L678

And here:

https://github.com/flutter/flutter/blob/fa117aad283ba930a7a79b472843b19e52f543bd/packages/flutter/lib/src/material/date_picker.dart#L689

### Proposal

It needs to be possible to control the `Divider` via **widget** and **theme** properties.

* Divider should use no padding height/width, so it touches the header area. This way, it can, if so desired, also be used as a line between header and calendar area when their colors are different.
* It should be possible to change the color of the `Divider` so it can if desired be removed by making it transparent (expected case above), alternatively make it more or less prominent (below).

| Subtle Divider | Prominent Divider |
|------------|-------------------|
| ![Screenshot 2023-05-12 at 0 24 00](https://github.com/flutter/flutter/assets/39990307/26b9e3d4-5910-4e25-8008-7fe914bfb2ce) |                   ![Screenshot 2023-05-12 at 0 41 42](https://github.com/flutter/flutter/assets/39990307/d19f1167-3a4e-47ff-94cc-5054cb602e6d) |

### Issue sample code

<details>
<summary>Code sample</summary>


```dart

```

</details>

## Used Flutter version

Channel master, 3.11.0-5.0.pre.46

<details>
  <summary>Doctor output</summary>

```console
flutter doctor -v
[✓] Flutter (Channel master, 3.11.0-5.0.pre.46, on macOS 13.2.1 22D68 darwin-arm64, locale en-US)
    • Flutter version 3.11.0-5.0.pre.46 on channel master at /Users/rydmike/fvm/versions/master
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision fa117aad28 (3 hours ago), 2023-05-11 10:28:08 -0700
    • Engine revision f38f46f66e
    • Dart version 3.1.0 (build 3.1.0-94.0.dev)
    • DevTools version 2.23.1
    • If those were intentional, you can disregard the above warnings; however it is recommended to use "git" directly to perform
      update checks and upgrades.

[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.0)
    • Android SDK at /Users/rydmike/Library/Android/sdk
    • Platform android-33, build-tools 33.0.0
    • Java binary at: /Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build 11.0.15+0-b2043.56-8887301)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 14.3)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Build 14E222b
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

[✓] IntelliJ IDEA Community Edition (version 2023.1)
    • IntelliJ at /Applications/IntelliJ IDEA CE.app
    • Flutter plugin version 73.0.4
    • Dart plugin version 231.8109.91

[✓] VS Code (version 1.77.3)
    • VS Code at /Applications/Visual Studio Code.app/Contents
    • Flutter extension version 3.62.0

[✓] Connected device (2 available)
    • macOS (desktop) • macos  • darwin-arm64   • macOS 13.2.1 22D68 darwin-arm64
    • Chrome (web)    • chrome • web-javascript • Google Chrome 113.0.5672.92

[✓] Network resources
    • All expected network resources are available.

```

</details>
