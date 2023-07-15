## (Regression) Scrolling away open `Tooltip` in a ListView causes a crash

When scrolling away a `Tooltip` that has been triggered in a `ListView`, an application will crash.

This issue is a **regression**, it happens on latest **beta, 3.13.0-0.1.pre** and **master, 3.13.0-3.0.pre.8** channels, but **not** on Flutter **stable 3.10.6**.

A reproduction sample app is provided further below. 

Use the sample app, preferably as a desktop build, because on desktop moving the pointer over Tooltips triggers them directly when hovering over them in the `ListView` in the app. Scroll quickly with a mouse wheel or trackpad gesture over the `Text` items with `Tooltip`s. Tooltips will be triggered and if opened Tooltips are scrolled away quickly, the app will crash.


## Expected results

Expect to be able to scroll triggered Tooltips without crashing the app. Like shown below, recorded with **Flutter stable 3.10.6**.

VIDEO



## Actual results

When scrolling the app quickly on **beta, 3.13.0-0.1.pre** or **master, 3.13.0-3.0.pre.8**, with Tooltips triggered, the application crashes instantly.

VIDEO



## The Elusive Nature of this Issue

Finding the trigger for this issue was **very** elusive. I noticed it in a list view that displays samples of pretty much every Material UI widget and different versions of them. So something went wrong in a view with about +100 different UI widgets. When scrolling this list view back and forth quickly on the **master** or **beta** channel, the app would crash in what appeared to be a totally random manner.

The stack trace was impossible to figure out (for me at least, a sample from the reproduction app's crash is also provided) and only pointed to the main list view with all the widgets. I needed to move the view to a separate app and start stripping away pieces from it until it no longer crashed.

After moving the same widget showcase sample view to a stand-alone app, and removing all 3rd-party dependencies, the trigger for the issue was still elusive. Stripping down the list of most widgets did not seem to help, sometimes it worked for a while, but suddenly crashed at what seemed to be totally random when scrolling.

It was more by accident that I discovered that when I removed the widgets that contained `Tooltip` wrappers, the issue went away. The elusiveness was, caused by the fact that the list only contained a few widgets with Tooltips, and only occasionally while scrolling the list, did my mouse happen to hit one of them and trigger the Tooltip, and not always did I scroll fast enough to scroll it out of view when that happened, to trigger the crash.

After discovering the trigger, writing a minimal reproduction sample app that triggers it at once was of course trivial. 


## Cause of Regression

After determining the crash was caused by `Tooltip`, I also recalled the recent [PR #127728 Migrate Tooltip to use OverlayPortal](https://github.com/flutter/flutter/pull/127728), that has a timing that fits and also changes not yet merged to the **stable** channel. Most likely the PR is the cause, or some of the other smaller additional changes done to `tooltip.dart` after the main migration to using `OverlayPortal`.

I have not investigated if it is a fundamental issue with the `OverlayPortal`, or just caused by the way `Tooltip` uses it. Potentially there could be other widgets using `OverlayPortal` that might have similar issues if they are open and scrolled away in a list. The issue might also be contained to `Tooltip` and could be related to auto close duration triggering removal of the tooltip overlay, after the `Tooltip` has already been scrolled out of view and no longer exists. I leave it to the capable hands of `OverlayPortal` and `Tooltip` modifications author @LongCatIsLooong to ponder this further.


## Issue sample code

<details>
<summary>Code sample</summary>


```dart
import 'package:flutter/material.dart';

void main() => runApp(const IssueApp());

class IssueApp extends StatelessWidget {
  const IssueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RenderTheater Crash',
      themeMode: ThemeMode.system,
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RenderTheater Crash')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: List.generate(
          40,
          (index) => Tooltip(
            message: 'A text $index line with a ToolTip',
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Text with tooltip number $index'),
            ),
          ),
        ),
      ),
    );
  }
}

```

</details>


## Issue log code

<details>
<summary>Crash log</summary>


```console
The following assertion was thrown during performLayout():
A _RenderTheater was mutated in RenderSliverList.performLayout.

The RenderObject was mutated when none of its ancestors is actively performing layout.
The RenderObject being mutated was: _RenderTheater#3354b NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
  needs compositing
  parentData: <none> (can use size)
  constraints: BoxConstraints(w=495.0, h=677.0)
  size: Size(495.0, 677.0)
  skipCount: 0
  textDirection: ltr
The RenderObject that was mutating the said _RenderTheater was: RenderSliverList#64366 relayoutBoundary=up2 NEEDS-LAYOUT NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
  needs compositing
  parentData: paintOffset=Offset(16.0, 0.0) (can use size)
  constraints: SliverConstraints(AxisDirection.down, GrowthDirection.forward, ScrollDirection.idle, scrollOffset: 526.0, remainingPaintExtent: 621.0, crossAxisExtent: 463.0, crossAxisDirection: AxisDirection.right, viewportMainAxisExtent: 621.0, remainingCacheExtent: 1121.0, cacheOrigin: -250.0)
  geometry: SliverGeometry(scrollExtent: 2080.0, paintExtent: 621.0, maxPaintExtent: 2080.0, hasVisualOverflow: true, cacheExtent: 871.0)
  currently live children: 5 to 26
The relevant error-causing widget was: 
  ListView ListView:file:///Users/rydmike/dev/code/issue_render_theater/lib/main.dart:30:13
When the exception was thrown, this was the stack: 
#0      RenderObject._debugCanPerformMutations.<anonymous closure> (package:flutter/src/rendering/object.dart:1926:9)
#1      RenderObject._debugCanPerformMutations (package:flutter/src/rendering/object.dart:1987:6)
#2      RenderObject.markNeedsLayout (package:flutter/src/rendering/object.dart:2197:12)
#3      RenderBox.markNeedsLayout (package:flutter/src/rendering/box.dart:2372:11)
#4      _RenderTheater.markNeedsLayout (package:flutter/src/widgets/overlay.dart:1016:11)
#5      RenderObject.dropChild (package:flutter/src/rendering/object.dart:1775:5)
#6      _RenderTheater._dropDeferredLayoutBoxChild (package:flutter/src/widgets/overlay.dart:944:5)
#7      _OverlayEntryLocation._deactivate (package:flutter/src/widgets/overlay.dart:1713:14)
#8      _OverlayPortalElement.deactivate (package:flutter/src/widgets/overlay.dart:1910:55)
#9      _InactiveElements._deactivateRecursively (package:flutter/src/widgets/framework.dart:1970:13)
#10     ComponentElement.visitChildren (package:flutter/src/widgets/framework.dart:5350:14)
#11     _InactiveElements._deactivateRecursively (package:flutter/src/widgets/framework.dart:1972:13)
#12     ComponentElement.visitChildren (package:flutter/src/widgets/framework.dart:5350:14)
#13     _InactiveElements._deactivateRecursively (package:flutter/src/widgets/framework.dart:1972:13)
#14     SingleChildRenderObjectElement.visitChildren (package:flutter/src/widgets/framework.dart:6421:14)
#15     _InactiveElements._deactivateRecursively (package:flutter/src/widgets/framework.dart:1972:13)
#16     SingleChildRenderObjectElement.visitChildren (package:flutter/src/widgets/framework.dart:6421:14)
#17     _InactiveElements._deactivateRecursively (package:flutter/src/widgets/framework.dart:1972:13)
#18     ComponentElement.visitChildren (package:flutter/src/widgets/framework.dart:5350:14)
#19     _InactiveElements._deactivateRecursively (package:flutter/src/widgets/framework.dart:1972:13)
#20     ComponentElement.visitChildren (package:flutter/src/widgets/framework.dart:5350:14)
#21     _InactiveElements._deactivateRecursively (package:flutter/src/widgets/framework.dart:1972:13)
#22     ComponentElement.visitChildren (package:flutter/src/widgets/framework.dart:5350:14)
#23     _InactiveElements._deactivateRecursively (package:flutter/src/widgets/framework.dart:1972:13)
#24     ComponentElement.visitChildren (package:flutter/src/widgets/framework.dart:5350:14)
#25     _InactiveElements._deactivateRecursively (package:flutter/src/widgets/framework.dart:1972:13)
#26     ComponentElement.visitChildren (package:flutter/src/widgets/framework.dart:5350:14)
#27     _InactiveElements._deactivateRecursively (package:flutter/src/widgets/framework.dart:1972:13)
#28     _InactiveElements.add (package:flutter/src/widgets/framework.dart:1984:7)
#29     Element.deactivateChild (package:flutter/src/widgets/framework.dart:4225:30)
#30     Element.updateChild (package:flutter/src/widgets/framework.dart:3631:9)
#31     SliverMultiBoxAdaptorElement.updateChild (package:flutter/src/widgets/sliver.dart:857:37)
#32     SliverMultiBoxAdaptorElement.removeChild.<anonymous closure> (package:flutter/src/widgets/sliver.dart:884:33)
#33     BuildOwner.buildScope (package:flutter/src/widgets/framework.dart:2720:19)
#34     SliverMultiBoxAdaptorElement.removeChild (package:flutter/src/widgets/sliver.dart:880:12)
#35     RenderSliverMultiBoxAdaptor._destroyOrCacheChild (package:flutter/src/rendering/sliver_multi_box_adaptor.dart:367:21)
#36     RenderSliverMultiBoxAdaptor.collectGarbage.<anonymous closure> (package:flutter/src/rendering/sliver_multi_box_adaptor.dart:513:9)
#37     RenderObject.invokeLayoutCallback.<anonymous closure> (package:flutter/src/rendering/object.dart:2602:59)
#38     PipelineOwner._enableMutationsToDirtySubtrees (package:flutter/src/rendering/object.dart:1057:15)
#39     RenderObject.invokeLayoutCallback (package:flutter/src/rendering/object.dart:2602:14)
#40     RenderSliverMultiBoxAdaptor.collectGarbage (package:flutter/src/rendering/sliver_multi_box_adaptor.dart:511:5)
#41     RenderSliverList.performLayout (package:flutter/src/rendering/sliver_list.dart:301:5)
#42     RenderObject.layout (package:flutter/src/rendering/object.dart:2491:7)
#43     RenderSliverEdgeInsetsPadding.performLayout (package:flutter/src/rendering/sliver_padding.dart:139:12)
#44     RenderSliverPadding.performLayout (package:flutter/src/rendering/sliver_padding.dart:361:11)
#45     RenderObject.layout (package:flutter/src/rendering/object.dart:2491:7)
#46     RenderViewportBase.layoutChildSequence (package:flutter/src/rendering/viewport.dart:534:13)
#47     RenderViewport._attemptLayout (package:flutter/src/rendering/viewport.dart:1512:12)
#48     RenderViewport.performLayout (package:flutter/src/rendering/viewport.dart:1421:20)
#49     RenderObject._layoutWithoutResize (package:flutter/src/rendering/object.dart:2330:7)
#50     PipelineOwner.flushLayout (package:flutter/src/rendering/object.dart:1011:18)
#51     RendererBinding.drawFrame (package:flutter/src/rendering/binding.dart:494:19)
#52     WidgetsBinding.drawFrame (package:flutter/src/widgets/binding.dart:926:13)
#53     RendererBinding._handlePersistentFrameCallback (package:flutter/src/rendering/binding.dart:360:5)
#54     SchedulerBinding._invokeFrameCallback (package:flutter/src/scheduler/binding.dart:1297:15)
#55     SchedulerBinding.handleDrawFrame (package:flutter/src/scheduler/binding.dart:1227:9)
#56     SchedulerBinding._handleDrawFrame (package:flutter/src/scheduler/binding.dart:1085:5)
#57     _invoke (dart:ui/hooks.dart:170:13)
#58     PlatformDispatcher._drawFrame (dart:ui/platform_dispatcher.dart:401:5)
#59     _drawFrame (dart:ui/hooks.dart:140:31)
The following RenderObject was being processed when the exception was fired: RenderSliverList#64366 relayoutBoundary=up2 NEEDS-LAYOUT NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
...  needs compositing
...  parentData: paintOffset=Offset(16.0, 0.0) (can use size)
...  constraints: SliverConstraints(AxisDirection.down, GrowthDirection.forward, ScrollDirection.idle, scrollOffset: 526.0, remainingPaintExtent: 621.0, crossAxisExtent: 463.0, crossAxisDirection: AxisDirection.right, viewportMainAxisExtent: 621.0, remainingCacheExtent: 1121.0, cacheOrigin: -250.0)
...  geometry: SliverGeometry(scrollExtent: 2080.0, paintExtent: 621.0, maxPaintExtent: 2080.0, hasVisualOverflow: true, cacheExtent: 871.0)
...    scrollExtent: 2080.0
...    paintExtent: 621.0
...    maxPaintExtent: 2080.0
...    hasVisualOverflow: true
...    cacheExtent: 871.0
...  currently live children: 5 to 26
RenderObject: RenderSliverList#64366 relayoutBoundary=up2 NEEDS-LAYOUT NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
  needs compositing
  parentData: paintOffset=Offset(16.0, 0.0) (can use size)
  constraints: SliverConstraints(AxisDirection.down, GrowthDirection.forward, ScrollDirection.idle, scrollOffset: 526.0, remainingPaintExtent: 621.0, crossAxisExtent: 463.0, crossAxisDirection: AxisDirection.right, viewportMainAxisExtent: 621.0, remainingCacheExtent: 1121.0, cacheOrigin: -250.0)
  geometry: SliverGeometry(scrollExtent: 2080.0, paintExtent: 621.0, maxPaintExtent: 2080.0, hasVisualOverflow: true, cacheExtent: 871.0)
    scrollExtent: 2080.0
    paintExtent: 621.0
    maxPaintExtent: 2080.0
    hasVisualOverflow: true
    cacheExtent: 871.0
```

</details>

## Used Flutter version

Channel master, 3.13.0-3.0.pre.88

<details>
  <summary>Flutter doctor</summary>

```
[✓] Flutter (Channel master, 3.13.0-3.0.pre.88, on macOS 13.4.1 22F82 darwin-arm64, locale en-US)
    • Flutter version 3.13.0-3.0.pre.88 on channel master at /master
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision f842ed9165 (4 hours ago), 2023-07-15 09:18:23 -0700
    • Engine revision 403866d161
    • Dart version 3.1.0 (build 3.1.0-312.0.dev)
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
    • macOS (desktop) • macos  • darwin-arm64   • macOS 13.4.1 22F82 darwin-arm64
    • Chrome (web)    • chrome • web-javascript • Google Chrome 114.0.5735.198

[✓] Network resources
    • All expected network resources are available.

```

</details>
