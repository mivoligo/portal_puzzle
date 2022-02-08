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
  GameBox? tappedBox;
  late Offset tappedLoc;
  late List<GameBox> tappedRow;
  late List<GameBox> tappedColumn;

  GameBox? _getTappedBox(Offset globalCoords) {
    for (GameBox box in boxes) {
      if (box.getRect(MediaQuery.of(context).size).contains(globalCoords)) {
        return box;
      }
    }
    return null;
  }

  List<GameBox> _getRowMatesForBox(GameBox box) {
    final rowMates = <GameBox>[];
    for (GameBox rowMateCandidateBox in boxes) {
      if (box.loc.dy == rowMateCandidateBox.loc.dy) {
        rowMates.add(rowMateCandidateBox);
      }
    }
    return rowMates;
  }

  List<GameBox> _getColumnMatesForBox(GameBox box) {
    final columnMates = <GameBox>[];
    for (GameBox columnMateCandidateBox in boxes) {
      if (box.loc.dx == columnMateCandidateBox.loc.dx) {
        columnMates.add(columnMateCandidateBox);
      }
    }
    return columnMates;
  }

  void _snapBoxes() {
    for (GameBox box in boxes) {
      Offset translatedLoc = box.loc + Offset(0.5, 0.5);
      box.loc = Offset(
          translatedLoc.dx.round() - 0.5, translatedLoc.dy.round() - 0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Rect gameBoxRect = GameBox(
      startLoc: Offset.zero,
      loc: Offset.zero,
      color: Colors.black,
    ).getRect(screenSize);

    return Scaffold(
      body: Center(
        child: GestureDetector(
          onPanStart: (details) {
            tappedBox = _getTappedBox(details.globalPosition);
            tappedLoc = details.globalPosition;
            tappedRow = _getRowMatesForBox(tappedBox!);
            tappedColumn = _getColumnMatesForBox(tappedBox!);
          },
          onPanUpdate: (details) {
            Offset dragOffset = details.globalPosition - tappedLoc;
            setState(() {
              if (tappedBox != null) {
                if (dragOffset.dx.abs() > dragOffset.dy.abs()) {
                  for (GameBox box in tappedRow) {
                    box.loc = box.startLoc +
                        Offset(dragOffset.dx / gameBoxRect.width, 0);
                  }
                } else {
                  for (GameBox box in tappedColumn) {
                    box.loc = box.startLoc +
                        Offset(0, dragOffset.dy / gameBoxRect.height);
                  }
                }
              }
            });
          },
          onPanEnd: (detail) {
            setState(() {
              _snapBoxes();
              for (GameBox box in boxes) {
                box.startLoc = box.loc;
              }
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: boxes
                .map(
                  (e) => GameBoxWidget(
                    box: e,
                    text: boxes.indexOf(e).toString(),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class GameBox {
  GameBox({
    required this.startLoc,
    required this.loc,
    required this.color,
  });

  Offset startLoc;
  Offset loc;
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
  for (double y = -1; y <= 1; y++) {
    for (double x = -1; x <= 1; x++) {
      result.add(GameBox(
          startLoc: Offset(x, y), loc: Offset(x, y), color: Colors.red));
    }
  }
  return result;
}
