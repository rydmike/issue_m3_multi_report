## Proposal: Make InputDecorationTheme usage in component themes consistent

The usage of `InputDecorationTheme` in component themes varies widely between component themes. This makes using components that use `InputDecoration` unpredictable and confusing.

The `InputDecoration` is typically used by `TextField`, `TextFormField` and `DropdownButtonFormField` but also by other newer components that have text input fields. Comparing these components we find diverging and conflicting behavior.


### Different and confusing behavior

We now have at least **four** different styles for how `InputDecoration` behaves via `inputDecoratorTheme` in components. 

> Below when referring to `theme.inputDecorationTheme`, it is used as short for `Theme.of(context).inputDecorationTheme`.

#### 1. `SearchBar` - Not inherited, no config

The `SearchBar` removes all influence from  `theme.inputDecorationTheme` decorator and always does its own style. It did not use to do it correctly, but that was the intention. It had to be fixed [(in issue #126623)](https://github.com/flutter/flutter/issues/126623) to do so, since some props from `theme.inputDecorationTheme` leaked through when you customized it and this destroyed the intended design of `SearchBar`.

To offer customization if/when needed, this version could easily be expanded to version 2 below. 

#### 2. `DropdownMenu` - Not inherited, can give own

Does not use global default `theme.inputDecorationTheme` [(issue #131213)](https://github.com/flutter/flutter/issues/131213), but we can give it a custom style via its component theme `DropdownMenuThemeData.inputDecorationTheme`. If we want the same one we used for `theme.inputDecorationTheme`, we need to explicitly assign it in its component `ThemeData.dropdownMenuTheme.inputDecorationTheme` theme as well. 

This version is actually clear and simple to use. It uses its own default, unless otherwise defined, easy and clear.


#### 3. `TimePickerDialog` - Partially inherited, partially own, can give own style

The `TimePickerDialog` has its own default style `InputDecoration`, however, some properties that are null in the default style will get a few values from the overall `theme.inputDecorationTheme`, like e.g. hover color will seep through from global `theme.inputDecorationTheme`.

You can provide a custom style in `TimePickerThemeData.inputDecorationTheme` and it will do a typical null fall through using it:

```dart
    final InputDecorationTheme inputDecorationTheme = timePickerTheme.inputDecorationTheme ?? defaultTheme.inputDecorationTheme;
    InputDecoration inputDecoration = const InputDecoration().applyDefaults(inputDecorationTheme);
```

https://github.com/flutter/flutter/blob/de5b9670ddddeb72bead390dd1078880e86f5dd7/packages/flutter/lib/src/material/time_picker.dart#L2018

If you use a custom `TimePickerThemeData.inputDecorationTheme` you must be aware of that you need to provide some internal style fixes for e.g. `errorStyle` that the picker does internally to its default decorator, for things to look correct. You may also need to provide some override values for property values that will come from the global input decorator (like hover color) if your `TimePickerThemeData.inputDecorationTheme` had null values for them, because if it did, it falls back to defaults for them, that part is basically just decorator default behavior though, but it can be surprising.

#### 4. `DatePickerDialog` - Inherited, cannot override none null values

The `DatePickerDialog` is the newest member to get a `DatePickerThemeData.inputDecorationTheme` via [PR #128950](https://github.com/flutter/flutter/pull/128950), before this, it only inherited it from `theme.inputDecorationTheme`.

The implementation it uses is **very** divergent from all the above styles.

The `merge` implementation in the `InputDatePickerFormField` is **problematic**, it only merges a property from the `datePickerTheme.inputDecorationTheme` style, if has **no** defined a style in `theme.inputDecorationTheme`, basically only if it is **null** there, so we do **not** get the style defined in a property for `datePickerTheme.inputDecorationTheme` if one is already defined in `theme.inputDecorationTheme`. 

When using a very elaborate `theme.inputDecorationTheme`, that defines pretty much all properties it has, this is still then the **only** style we can get, despite the addition of the recent `datePickerTheme.inputDecorationTheme`. This is of course because of how `merge` works, where it only fills in none null fields in `inputTheme` below, and if all the fields in `inputTheme` are none null, the merged `datePickerTheme.inputDecorationTheme` has no impact whatsoever on the desired style, so we cannot change it, regardless of the addition of the `datePickerTheme.inputDecorationTheme`.

This code is from: `https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/input_date_picker_form_field.dart`


```dart
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool useMaterial3 = theme.useMaterial3;
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final DatePickerThemeData datePickerTheme = theme.datePickerTheme;
    final InputDecorationTheme inputTheme = theme.inputDecorationTheme;
    final InputBorder effectiveInputBorder =  datePickerTheme.inputDecorationTheme?.border
      ?? theme.inputDecorationTheme.border
      ?? (useMaterial3 ? const OutlineInputBorder() : const UnderlineInputBorder());

    return TextFormField(
      decoration: InputDecoration(
        hintText: widget.fieldHintText ?? localizations.dateHelpText,
        labelText: widget.fieldLabelText ?? localizations.dateInputLabel,
      ).applyDefaults(inputTheme
        .merge(datePickerTheme.inputDecorationTheme)
        .copyWith(border: effectiveInputBorder),
      ),
      validator: _validateDate,
      keyboardType: widget.keyboardType ?? TextInputType.datetime,
      onSaved: _handleSaved,
      onFieldSubmitted: _handleSubmitted,
      autofocus: widget.autofocus,
      controller: _controller,
    );
  } 
```

https://github.com/flutter/flutter/blob/de5b9670ddddeb72bead390dd1078880e86f5dd7/packages/flutter/lib/src/material/input_date_picker_form_field.dart#L262

If the used **merge** was:

```dart
      ).applyDefaults((datePickerTheme.inputDecorationTheme ?? InputDecorationTheme())
        .merge(inputTheme)
        .copyWith(border: effectiveInputBorder),
      ),
```

At least then we get `datePickerTheme.inputDecorationTheme` props where given, that are and back-filled with the `inputTheme = theme.inputDecorationTheme` property values, which would be more in line with what is expected and be more useful.

When you have already made a **VERY** custom `theme.inputDecorationTheme` then pretty much every property in it is no longer null, you can then not provide any other values via `DatePickerTheme.inputDecorationTheme` with current implementation. This not only makes this implementation **very divergent** compared to others styles, it is also a fairly pointless property.


## Proposal

Consider harmonizing the different behavior of how `InputDecoration` is inherited and used in component themes that are not pure `TextField` input derivatives. 

Current diverging styles and behaviors are very difficult to predict and reason about. Plus one of them does not even provide the needed independent from  `theme.inputDecorationTheme` styling capabilities.

It feels like the simplest one, the `DropdownMenu` approach is the one that is the easiest to reason about and provides good and expected behavior.

If a widget already depends on the inherited InputDecoratorTheme from ThemeData, to some degree, it can of course still do so, but it imo it is cleaner if that style is then just completely ignored if you give it an own `InputDecoratorTheme` as a part of its component theme or even as a widget property.

This also fits well with how other properties generally work in components and component themes.


## Used Flutter version

Channel master, 3.13.0-15.0.pre.16

<details>
  <summary>Flutter doctor</summary>

```
flutter doctor -v
[✓] Flutter (Channel master, 3.13.0-15.0.pre.16, on macOS 13.4.1 22F770820d darwin-arm64,
    locale en-US)
    • Flutter version 3.13.0-15.0.pre.16 on channel master at
      /Users/rydmike/fvm/versions/master
    ! Warning: `dart` on your path resolves to
      /opt/homebrew/Cellar/dart/2.17.5/libexec/bin/dart, which is not inside your current
      Flutter SDK checkout at /Users/rydmike/fvm/versions/master. Consider adding
      /Users/rydmike/fvm/versions/master/bin to the front of your path.
    • Upstream repository https://github.com/flutter/flutter.git
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
