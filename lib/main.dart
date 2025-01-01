// Posted as issue: https://github.com/flutter/flutter/issues/160963

import 'dart:ui';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(const IssueApp());

class IssueApp extends StatelessWidget {
  const IssueApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        // theme: AppTheme.light,
        theme: ThemeData(
          bottomSheetTheme: const BottomSheetThemeData(
            clipBehavior: Clip.none,
          ),
        ),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.light,
        home: const Home(),
      );
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(
            children: List.generate(
              15,
              (int index) => Text(
                'This should be blurred',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.dark_mode),
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: true,
            barrierColor: Colors.black.withAlpha(128),
            backgroundColor: Colors.transparent,
            useRootNavigator: true,
            builder: (BuildContext context) => Container(
              color: Colors.transparent,
              child: DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.5,
                minChildSize: 0.25,
                maxChildSize: 0.9,
                snap: true,
                snapSizes: const [0.25, 0.5, 0.75, 0.9],
                builder:
                    (BuildContext context, ScrollController scrollController) =>
                        Container(
                  color: Colors.transparent,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: SafeArea(
                      child: Container(
                        decoration: const BoxDecoration(
                          // Use transparent color to see
                          // blur is for entire page and clip will clip it to
                          // the shape of the sheet.
                          color: Colors.transparent,
                          // Original decoration color, we cannot see that it
                          // is blurred, but it is.
                          // ColorScheme.of(context).onSurface,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index) =>
                              ListTile(
                            title: Text(
                              'Item $index',
                              style: TextTheme.of(context)
                                  .titleMedium!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade package to version 8.1.0.
///
/// Use in [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
///     :
/// );
abstract final class AppTheme {
  // The defined light theme.
  static ThemeData light = FlexThemeData.light(
    scheme: FlexScheme.brandBlue,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 2,
    appBarOpacity: 0.93,
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnLevel: 8,
      useM2StyleDividerInM3: true,
      splashType: FlexSplashType.instantSplash,
      adaptiveElevationShadowsBack: FlexAdaptive.all(),
      defaultRadius: 10.0,
      elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
      elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
      outlinedButtonOutlineSchemeColor: SchemeColor.primary,
      toggleButtonsBorderSchemeColor: SchemeColor.primary,
      segmentedButtonSchemeColor: SchemeColor.primary,
      segmentedButtonBorderSchemeColor: SchemeColor.primary,
      switchAdaptiveCupertinoLike: FlexAdaptive.all(),
      unselectedToggleIsColored: true,
      sliderValueTinted: true,
      sliderTrackHeight: 6,
      inputDecoratorSchemeColor: SchemeColor.primary,
      inputDecoratorIsFilled: true,
      inputDecoratorIsDense: true,
      inputDecoratorBackgroundAlpha: 31,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedHasBorder: false,
      inputDecoratorFocusedBorderWidth: 1.5,
      inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
      listTileSelectedSchemeColor: SchemeColor.primary,
      listTileContentPadding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      listTileMinVerticalPadding: 6.0,
      fabUseShape: true,
      fabAlwaysCircular: true,
      fabSchemeColor: SchemeColor.tertiary,
      chipSchemeColor: SchemeColor.surfaceContainerLow,
      chipRadius: 40.0,
      chipFontSize: 13,
      chipIconSize: 16,
      chipPadding: EdgeInsetsDirectional.fromSTEB(6, 6, 6, 6),
      cardRadius: 12.0,
      popupMenuRadius: 6.0,
      popupMenuElevation: 4.0,
      alignedDropdown: true,
      dialogBackgroundSchemeColor: SchemeColor.surfaceContainer,
      dialogElevation: 10.0,
      dialogRadius: 20.0,
      datePickerHeaderBackgroundSchemeColor:
          SchemeColor.surfaceContainerHighest,
      datePickerDividerSchemeColor: SchemeColor.transparent,
      appBarCenterTitle: true,
      tabBarUnselectedItemOpacity: 0.64,
      tabBarIndicatorSchemeColor: SchemeColor.secondary,
      tabBarIndicatorWeight: 4,
      tabBarIndicatorTopRadius: 4,
      tabBarDividerColor: Color(0x00000000),
      drawerElevation: 2.0,
      drawerBackgroundSchemeColor: SchemeColor.surfaceContainer,
      drawerIndicatorRadius: 20.0,
      drawerIndicatorSchemeColor: SchemeColor.primary,
      drawerSelectedItemSchemeColor: SchemeColor.onPrimary,
      bottomNavigationBarMutedUnselectedLabel: false,
      bottomNavigationBarMutedUnselectedIcon: false,
      menuRadius: 6.0,
      menuElevation: 4.0,
      menuBarRadius: 0.0,
      menuBarElevation: 0.0,
      menuBarShadowColor: Color(0x00000000),
      searchBarElevation: 1.0,
      searchViewElevation: 1.0,
      searchUseGlobalShape: true,
      navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
      navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
      navigationBarIndicatorSchemeColor: SchemeColor.primary,
      navigationBarIndicatorRadius: 14.0,
      navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
      navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
      navigationRailUseIndicator: true,
      navigationRailIndicatorSchemeColor: SchemeColor.primary,
      navigationRailIndicatorOpacity: 1.00,
      navigationRailIndicatorRadius: 14.0,
      navigationRailBackgroundSchemeColor: SchemeColor.surfaceContainer,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    keyColors: const FlexKeyColors(
      useSecondary: true,
      useTertiary: true,
      keepPrimary: true,
    ),
    tones: FlexSchemeVariant.chroma
        .tones(Brightness.light)
        .higherContrastFixed()
        .monochromeSurfaces()
        .surfacesUseBW(),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
  // The defined dark theme.
  static ThemeData dark = FlexThemeData.dark(
    scheme: FlexScheme.brandBlue,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 2,
    appBarOpacity: 0.93,
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnLevel: 10,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      splashType: FlexSplashType.instantSplash,
      adaptiveElevationShadowsBack: FlexAdaptive.all(),
      defaultRadius: 10.0,
      elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
      elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
      outlinedButtonOutlineSchemeColor: SchemeColor.primary,
      toggleButtonsBorderSchemeColor: SchemeColor.primary,
      segmentedButtonSchemeColor: SchemeColor.primary,
      segmentedButtonBorderSchemeColor: SchemeColor.primary,
      switchAdaptiveCupertinoLike: FlexAdaptive.all(),
      unselectedToggleIsColored: true,
      sliderValueTinted: true,
      sliderTrackHeight: 6,
      inputDecoratorSchemeColor: SchemeColor.primary,
      inputDecoratorIsFilled: true,
      inputDecoratorIsDense: true,
      inputDecoratorBackgroundAlpha: 43,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedHasBorder: false,
      inputDecoratorFocusedBorderWidth: 1.5,
      inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
      listTileSelectedSchemeColor: SchemeColor.primary,
      listTileContentPadding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      listTileMinVerticalPadding: 6.0,
      fabUseShape: true,
      fabAlwaysCircular: true,
      fabSchemeColor: SchemeColor.tertiary,
      chipSchemeColor: SchemeColor.surfaceContainerLow,
      chipRadius: 40.0,
      chipFontSize: 13,
      chipIconSize: 16,
      chipPadding: EdgeInsetsDirectional.fromSTEB(6, 6, 6, 6),
      cardRadius: 12.0,
      popupMenuRadius: 6.0,
      popupMenuElevation: 4.0,
      alignedDropdown: true,
      dialogElevation: 10.0,
      dialogRadius: 20.0,
      datePickerHeaderBackgroundSchemeColor:
          SchemeColor.surfaceContainerHighest,
      datePickerDividerSchemeColor: SchemeColor.transparent,
      appBarCenterTitle: true,
      tabBarUnselectedItemOpacity: 0.74,
      tabBarIndicatorWeight: 4,
      tabBarIndicatorTopRadius: 4,
      tabBarDividerColor: Color(0x00000000),
      drawerElevation: 2.0,
      drawerBackgroundSchemeColor: SchemeColor.surfaceContainer,
      drawerIndicatorRadius: 20.0,
      drawerIndicatorSchemeColor: SchemeColor.primary,
      drawerSelectedItemSchemeColor: SchemeColor.onPrimary,
      bottomNavigationBarMutedUnselectedLabel: false,
      bottomNavigationBarMutedUnselectedIcon: false,
      menuRadius: 6.0,
      menuElevation: 4.0,
      menuBarRadius: 0.0,
      menuBarElevation: 0.0,
      menuBarShadowColor: Color(0x00000000),
      searchBarElevation: 1.0,
      searchViewElevation: 1.0,
      searchUseGlobalShape: true,
      navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
      navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
      navigationBarIndicatorSchemeColor: SchemeColor.primary,
      navigationBarIndicatorRadius: 14.0,
      navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
      navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
      navigationRailUseIndicator: true,
      navigationRailIndicatorSchemeColor: SchemeColor.primary,
      navigationRailIndicatorOpacity: 1.00,
      navigationRailIndicatorRadius: 14.0,
      navigationRailBackgroundSchemeColor: SchemeColor.surfaceContainer,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    keyColors: const FlexKeyColors(
      useSecondary: true,
      useTertiary: true,
    ),
    tones:
        FlexSchemeVariant.chroma.tones(Brightness.dark).higherContrastFixed(),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}
