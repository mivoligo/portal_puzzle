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
  final boxes = _generateGameBoxes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          child: Stack(
            alignment: Alignment.center,
            children: boxes
                .map((e) => GameBoxWidget(
                      box: e,
                      text: boxes.indexOf(e).toString(),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class GameBox {
  GameBox({
    required this.loc,
    required this.color,
  });

  final Offset loc;

  final Color color;

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

class GameBoxWidget extends StatelessWidget {
  const GameBoxWidget({
    Key? key,
    required this.box,
    required this.text,
  }) : super(key: key);

  final GameBox box;
  final String text;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final gameBoxRect = box.getRect(screenSize);
    return Positioned(
      left: gameBoxRect.left,
      top: gameBoxRect.top,
      width: gameBoxRect.width,
      height: gameBoxRect.height,
      child: Padding(
        padding: EdgeInsets.all(gameBoxRect.width * relativeGapSize / 2),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: box.color,
          ),
          child: Center(child: Text(text)),
        ),
      ),
    );
  }
}

List<GameBox> _generateGameBoxes() {
  final result = <GameBox>[];
  for (double x = -2.5; x <= 2.5; x++) {
    for (double y = -2.5; y <= 2.5; y++) {
      result.add(GameBox(loc: Offset(x, y), color: Colors.red));
    }
  }
  return result;
}
