import 'package:flutter/material.dart';

const gridSize = 6;
const relativeGapSize = 1 / 12;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    GameBox box = GameBox()
      ..loc = Offset.zero
      ..color = Colors.amber;
    final screenSize = MediaQuery.of(context).size;
    final gameBoxRect = box.getRect(screenSize);
    return Scaffold(
      body: Center(
        child: GestureDetector(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: gameBoxRect.left,
                top: gameBoxRect.top,
                width: gameBoxRect.width,
                height: gameBoxRect.height,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    color: box.color,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GameBox {
  late Offset loc;
  late Color color;

  Rect getRect(Size parentSize) {
    final totalBoxWidth = parentSize.shortestSide / gridSize;
    return Rect.fromCenter(
      center: Offset(parentSize.width / 2 + loc.dx * totalBoxWidth,
          parentSize.height / 2 + loc.dy * totalBoxWidth),
      width: totalBoxWidth,
      height: totalBoxWidth,
    );
  }
}
