// Posted as issue: https://github.com/flutter/flutter/issues/160963

import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(const IssueApp());

class IssueApp extends StatelessWidget {
  const IssueApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(
          bottomSheetTheme: const BottomSheetThemeData(
            // Works OK
            // clipBehavior: Clip.none,
            // Does not work, anything else than Clip.none will cause the issue.
            clipBehavior: Clip.antiAlias,
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Hello, STACKED!',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                'Hello, STACKED!',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                'Hello, STACKED!',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ],
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
                        decoration: BoxDecoration(
                          color: ColorScheme.of(context).onSurface,
                          borderRadius: const BorderRadius.only(
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
