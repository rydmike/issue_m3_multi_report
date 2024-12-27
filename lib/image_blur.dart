import 'dart:ui';

import 'package:flutter/material.dart';

class ThemeImage extends StatefulWidget {
  const ThemeImage({
    super.key,
  });

  @override
  State<ThemeImage> createState() => _ThemeImageState();
}

class _ThemeImageState extends State<ThemeImage> {
  bool soldout = false;

  static const double _shapeRadius = 50.0;
  static const double _imagePadding = 40.0;
  static const double _imageHeight = 500.0;

  @override
  Widget build(BuildContext context) {
    final double opacity = soldout ? 0.5 : 1.0;
    TextStyle style = TextStyle(color: Colors.white.withValues(alpha: opacity));
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Sold out'),
          value: soldout,
          onChanged: (bool value) {
            setState(() {
              soldout = value;
            });
          },
        ),
        SizedBox(
          height: _imageHeight,
          child: Padding(
            padding: const EdgeInsets.all(_imagePadding),
            child: Stack(
              children: [
                Material(
                  color: Colors.transparent,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_shapeRadius),
                  ),
                  child: Ink.image(
                    image: const AssetImage('assets/images/AleLaavu.jpeg'),
                    colorFilter: soldout
                        ? const ColorFilter.matrix(<double>[
                            0.2126, 0.7152, 0.0722, 0, 0, // Greyscale filter
                            0.2126, 0.7152, 0.0722, 0, 0, // Greyscale filter
                            0.2126, 0.7152, 0.0722, 0, 0, // Greyscale filter
                            0, 0, 0, 1, 0, // Greyscale filter
                          ])
                        : null,
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_shapeRadius),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                          height: _shapeRadius * 2,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Overview', style: style),
                              Text('Rooms', style: style),
                              Text('Promotion', style: style),
                              Text('Amenities', style: style),
                            ],
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
