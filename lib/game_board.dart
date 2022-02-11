import 'package:flutter/material.dart';

const gridSize = 3;
const relativeGapSize = 0;

class GameBox {
  GameBox({
    required this.originalLoc,
    required this.startLoc,
    required this.loc,
    required this.color,
  });

  Offset originalLoc;
  Offset startLoc;
  Offset loc;
  Color color;

  Rect getRect(Size parentSize) {
    final totalBoxWidth = parentSize.shortestSide / gridSize;
    return Rect.fromLTWH(
      loc.dx * totalBoxWidth,
      loc.dy * totalBoxWidth,
      totalBoxWidth,
      totalBoxWidth,
    );
  }
}

class GameBoxWidget extends StatelessWidget {
  const GameBoxWidget({
    Key? key,
    required this.box,
    required this.text,
    required this.parentSize,
  }) : super(key: key);

  final GameBox box;
  final String text;
  final Size parentSize;

  @override
  Widget build(BuildContext context) {
    final gameBoxRect = box.getRect(parentSize);
    return Positioned(
      left: gameBoxRect.left,
      top: gameBoxRect.top,
      width: gameBoxRect.width,
      height: gameBoxRect.height,
      child: Padding(
        padding: EdgeInsets.all(gameBoxRect.width * relativeGapSize / 2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: box.color,
          ),
          child: Center(
              child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w600,
              fontSize: gameBoxRect.height * 0.6,
            ),
          )),
        ),
      ),
    );
  }
}

List<GameBox> _generateGameBoxes() {
  final result = <GameBox>[];
  for (double y = 0; y < gridSize; y++) {
    for (double x = 0; x < gridSize; x++) {
      result.add(
        GameBox(
          originalLoc: Offset(x, y),
          startLoc: Offset(x, y),
          loc: Offset(x, y),
          color: Colors.red.withAlpha(50),
        ),
      );
    }
  }
  return result;
}

class GameBoard extends StatefulWidget {
  const GameBoard({Key? key, required this.parentSize}) : super(key: key);

  final Size parentSize;

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  final boxes = _generateGameBoxes();
  GameBox? tappedBox;
  late Offset tappedLoc;
  late List<GameBox> tappedRow;
  late List<GameBox> tappedColumn;

  @override
  Widget build(BuildContext context) {
    Size parentSize = widget.parentSize;
    return Center(
      child: SizedBox(
        width: parentSize.shortestSide,
        height: parentSize.shortestSide,
        child: GestureDetector(
          onPanDown: (details) {},
          onPanStart: (details) {
            tappedBox = _getTappedBox(parentSize, details.localPosition);
            tappedLoc = details.localPosition;
            tappedRow = _getRowMatesForBox(tappedBox!);
            tappedColumn = _getColumnMatesForBox(tappedBox!);
          },
          onPanUpdate: (details) {
            Offset dragOffset = details.localPosition - tappedLoc;
            setState(() {
              if (tappedBox != null) {
                if (dragOffset.dx.abs() > dragOffset.dy.abs()) {
                  for (GameBox box in tappedRow) {
                    box.loc = box.startLoc +
                        Offset(
                          dragOffset.dx / parentSize.width * gridSize,
                          0,
                        );
                    if (box.loc.dx <= -0.5) {
                      box.loc = Offset(
                        box.startLoc.dx +
                            gridSize +
                            dragOffset.dx / parentSize.width * gridSize,
                        box.loc.dy,
                      );
                    }
                    if (box.loc.dx > gridSize - 0.5) {
                      box.loc = Offset(
                        box.startLoc.dx -
                            gridSize +
                            dragOffset.dx / parentSize.width * gridSize,
                        box.loc.dy,
                      );
                    }
                  }
                } else {
                  for (GameBox box in tappedColumn) {
                    box.loc = box.startLoc +
                        Offset(
                          0,
                          dragOffset.dy / parentSize.height * gridSize,
                        );
                    if (box.loc.dy <= -0.5) {
                      box.loc = Offset(
                        box.loc.dx,
                        box.startLoc.dy +
                            gridSize +
                            dragOffset.dy / parentSize.height * gridSize,
                      );
                    }
                    if (box.loc.dy > gridSize - 0.5) {
                      box.loc = Offset(
                        box.loc.dx,
                        box.startLoc.dy -
                            gridSize +
                            dragOffset.dy / parentSize.height * gridSize,
                      );
                    }
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
                if (box.loc == box.originalLoc) {
                  box.color = Colors.amber;
                } else {
                  box.color = Colors.red.shade50;
                }
              }
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                color: Colors.lightBlue,
              ),
              ...boxes
                  .map(
                    (box) => GameBoxWidget(
                      box: box,
                      text: '${boxes.indexOf(box) + 1}',
                      parentSize: parentSize,
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  GameBox? _getTappedBox(Size parentSize, Offset globalCoords) {
    for (GameBox box in boxes) {
      if (box.getRect(parentSize).contains(globalCoords)) {
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
      Offset translatedLoc = box.loc + const Offset(1, 1);
      box.loc = Offset(
        translatedLoc.dx.round() - 1,
        translatedLoc.dy.round() - 1,
      );
    }
  }
}
