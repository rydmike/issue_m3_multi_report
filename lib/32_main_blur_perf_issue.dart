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
// FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// This issue reported here: https://github.com/flutter/flutter/issues/132735

void main() {
  runApp(const IssueDemoApp());
}

class IssueDemoApp extends StatelessWidget {
  const IssueDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: true,
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _random = math.Random();
  bool blurAppBar = true;
  bool blurBottomNav = true;

  @override
  Widget build(BuildContext context) {
    final double topSliverPadding =
        MediaQuery.paddingOf(context).top + kMinInteractiveDimensionCupertino;

    debugPrint('topSliverPadding = $topSliverPadding');
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor:
            CupertinoColors.white.withAlpha(blurBottomNav ? 0x99 : 0xFF),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bars),
            label: 'Standard',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.rectangle_fill),
            label: 'Large',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return CupertinoPageScaffold(
              navigationBar: index == 0
                  ? CupertinoNavigationBar(
                      backgroundColor: CupertinoColors.white
                          .withAlpha(blurAppBar ? 0x99 : 0xFF),
                      leading: CupertinoButton(
                        child: blurAppBar
                            ? const Icon(CupertinoIcons.viewfinder_circle_fill)
                            : const Icon(CupertinoIcons.viewfinder_circle),
                        onPressed: () {
                          setState(() {
                            blurAppBar = !blurAppBar;
                          });
                        },
                      ),
                      middle: blurAppBar
                          ? const Text('Blur Standard NavBar')
                          : const Text('No Blur Standard NavBar'),
                      trailing: CupertinoButton(
                        child: blurBottomNav
                            ? const Icon(CupertinoIcons.circle_grid_hex_fill)
                            : const Icon(CupertinoIcons.circle_grid_hex),
                        onPressed: () {
                          setState(() {
                            blurBottomNav = !blurBottomNav;
                          });
                        },
                      ),
                    )
                  : null,
              child: CustomScrollView(
                // A list of sliver widgets.
                slivers: <Widget>[
                  if (index != 0)
                    CupertinoSliverNavigationBar(
                      backgroundColor: CupertinoColors.white
                          .withAlpha(blurAppBar ? 0x75 : 0xFF),
                      leading: CupertinoButton(
                        child: blurAppBar
                            ? const Icon(CupertinoIcons.viewfinder_circle_fill)
                            : const Icon(CupertinoIcons.viewfinder_circle),
                        onPressed: () {
                          setState(() {
                            blurAppBar = !blurAppBar;
                          });
                        },
                      ),
                      largeTitle: blurAppBar
                          ? const Text('Blur Large NavBar')
                          : const Text('No Blur Large NavBar'),
                      trailing: CupertinoButton(
                        child: blurBottomNav
                            ? const Icon(CupertinoIcons.circle_grid_hex_fill)
                            : const Icon(CupertinoIcons.circle_grid_hex),
                        onPressed: () {
                          setState(() {
                            blurBottomNav = !blurBottomNav;
                          });
                        },
                      ),
                    ),
                  if (index == 0 && blurAppBar)
                    SliverToBoxAdapter(
                      child: SizedBox(height: topSliverPadding),
                    ),
                  SliverList.builder(
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: SizedBox(
                        height: 50,
                        child: ColoredBox(
                          color: Colors.primaries[_random.nextInt(17)].shade300,
                          child: Center(
                            child: Text(index.toString()),
                          ),
                        ),
                      ),
                    ),
                    itemCount: 500,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
