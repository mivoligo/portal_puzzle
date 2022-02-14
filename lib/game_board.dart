import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/models.dart';

class GameBoxWidget extends StatelessWidget {
  const GameBoxWidget({
    Key? key,
    required this.box,
    required this.text,
    required this.boardSize,
  }) : super(key: key);

  final GameBoxModel box;
  final String text;
  final double boardSize;

  @override
  Widget build(BuildContext context) {
    final gridSize = context.watch<GameModel>().gridSize;
    final gameBoxRect = box.getRect(boardSize: boardSize, gridSize: gridSize);
    return Positioned(
      left: gameBoxRect.left,
      top: gameBoxRect.top,
      width: gameBoxRect.width,
      height: gameBoxRect.height,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Colors.orange,
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
    );
  }
}

class GameBoard extends StatefulWidget {
  const GameBoard({Key? key, required this.parentSize}) : super(key: key);

  final Size parentSize;

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  GameBoxModel? tappedBox;
  late Offset tappedLoc;
  late List<GameBoxModel> tappedRow;
  late List<GameBoxModel> tappedColumn;

  @override
  Widget build(BuildContext context) {
    final gridSize = context.watch<GameModel>().gridSize;
    final boxes = context.watch<GameBoardModel>().boxes;
    Size parentSize = widget.parentSize;
    double boardSize = parentSize.shortestSide;
    return Center(
      child: SizedBox(
        width: boardSize,
        height: boardSize,
        child: GestureDetector(
          onPanDown: (details) {},
          onPanStart: (details) {
            tappedBox = context.read<GameBoardModel>().getTappedBox(
                  boardSize: boardSize,
                  globalCoords: details.localPosition,
                  gridSize: gridSize,
                );
            tappedLoc = details.localPosition;
            tappedRow =
                context.read<GameBoardModel>().getRowMatesForBox(tappedBox!);
            tappedColumn =
                context.read<GameBoardModel>().getColumnMatesForBox(tappedBox!);
          },
          onPanUpdate: (details) {
            Offset dragOffset = details.localPosition - tappedLoc;
            setState(() {
              if (tappedBox != null) {
                if (dragOffset.dx.abs() > dragOffset.dy.abs()) {
                  for (GameBoxModel box in tappedRow) {
                    box.currentLocation = box.startLocation +
                        Offset(
                          dragOffset.dx / boardSize * gridSize,
                          0,
                        );
                    if (box.currentLocation.dx <= -0.5) {
                      box.currentLocation = Offset(
                        box.startLocation.dx +
                            gridSize +
                            dragOffset.dx / boardSize * gridSize,
                        box.currentLocation.dy,
                      );
                    }
                    if (box.currentLocation.dx > gridSize - 0.5) {
                      box.currentLocation = Offset(
                        box.startLocation.dx -
                            gridSize +
                            dragOffset.dx / boardSize * gridSize,
                        box.currentLocation.dy,
                      );
                    }
                  }
                } else {
                  for (GameBoxModel box in tappedColumn) {
                    box.currentLocation = box.startLocation +
                        Offset(
                          0,
                          dragOffset.dy / boardSize * gridSize,
                        );
                    if (box.currentLocation.dy <= -0.5) {
                      box.currentLocation = Offset(
                        box.currentLocation.dx,
                        box.startLocation.dy +
                            gridSize +
                            dragOffset.dy / boardSize * gridSize,
                      );
                    }
                    if (box.currentLocation.dy > gridSize - 0.5) {
                      box.currentLocation = Offset(
                        box.currentLocation.dx,
                        box.startLocation.dy -
                            gridSize +
                            dragOffset.dy / boardSize * gridSize,
                      );
                    }
                  }
                }
              }
            });
          },
          onPanEnd: (detail) {
            context.read<GameBoardModel>().snapBoxes();
            context.read<GameBoardModel>().updateGameBoxesLocation();
            context.read<GameModel>().addMove();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                color: Colors.lightBlue,
              ),
              ...boxes.map(
                (box) {
                  return GameBoxWidget(
                    box: box,
                    text: '${boxes.indexOf(box) + 1}',
                    boardSize: boardSize,
                  );
                },
              ).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
