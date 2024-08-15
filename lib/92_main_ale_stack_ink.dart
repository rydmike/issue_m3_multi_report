import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(20),
          child: SizedBox(
            width: 280,
            child: Column(
              children: [
                PokeCard(
                  child: ChunkCard(color: Colors.transparent),
                ),
                SizedBox(height: 8),
                ChunkCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PokeCard extends StatelessWidget {
  const PokeCard({required this.child, super.key});
  static final _corner = BorderRadius.circular(20);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.yellow,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: _corner,
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                fit: BoxFit.fitWidth,
                imageUrl:
                    'https://miro.medium.com/v2/resize:fit:1400/format:webp/1*lt8tmPdknVSpx2tcL8HizQ.png',
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Text('Free welcome gift!'),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, bottom: 10),
                child: Text('Activate to enjoy'),
              ),
              child,
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => debugPrint('Poke tapped'),
                borderRadius: _corner,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChunkCard extends StatelessWidget {
  const ChunkCard({super.key, this.color});
  final Color? color;
  static final _corner = BorderRadius.circular(20);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: color,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: _corner,
      ),
      child: InkWell(
        onTap: color == Colors.transparent
            ? null
            : () => debugPrint('Chunk tapped'),
        child: const Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('10 minutes'),
              Text('€12.34'),
            ],
          ),
        ),
      ),
    );
  }
}
