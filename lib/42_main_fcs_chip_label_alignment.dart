import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final TextStyle customChipTextStyle = GoogleFonts.leagueScript().copyWith(
  fontSize: 40,
  // Comment the two lines below to visually test the difference
  leadingDistribution: TextLeadingDistribution.even,
  textBaseline: TextBaseline.alphabetic,
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FlexThemeData.dark(
      scheme: FlexScheme.mandyRed,
      typography: Typography.material2021(),
      subThemesData: FlexSubThemesData(
        chipLabelStyle: customChipTextStyle,
      ),
    );

    return MaterialApp(title: 'Flutter Demo', theme: theme, home: MyHomePage());
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextStyle? style = Theme.of(context).chipTheme.labelStyle;
    debugPrint('Style: $style');
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InputChip(
              avatar: Icon(Icons.emoji_emotions_rounded),
              onPressed: () {},
              label: ColoredBox(color: Colors.red, child: Text('My Chip')),
            ),
          ],
        ),
      ),
    );
  }
}
