import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/models.dart';
import 'widgets/widgets.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({Key? key, required this.parentSize}) : super(key: key);

  final Size parentSize;

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  GameBox? tappedBox;
  late Offset tappedLoc;
  late List<GameBox> tappedRow;
  late List<GameBox> tappedColumn;

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
          onHorizontalDragStart: (details) {
            tappedLoc = details.localPosition;
            tappedBox = context.read<GameBoardModel>().getTappedBox(
                  boardSize: boardSize,
                  globalCoords: tappedLoc,
                  gridSize: gridSize,
                );
            tappedRow =
                context.read<GameBoardModel>().getRowMatesForBox(tappedBox!);
          },
          onVerticalDragStart: (details) {
            tappedLoc = details.localPosition;
            tappedBox = context.read<GameBoardModel>().getTappedBox(
                  boardSize: boardSize,
                  globalCoords: tappedLoc,
                  gridSize: gridSize,
                );
            tappedColumn =
                context.read<GameBoardModel>().getColumnMatesForBox(tappedBox!);
          },
          onHorizontalDragUpdate: (details) {
            Offset dragOffset = details.localPosition - tappedLoc;
            double translatedX = dragOffset.dx / boardSize * gridSize;
            setState(() {
              for (GameBox box in tappedRow) {
                box.currentLoc = box.startLoc + Offset(translatedX, 0);
                print(box.currentLoc);
                if (box.currentLoc.dx <= -0.5) {
                  box.currentLoc = Offset(
                    box.startLoc.dx + gridSize + translatedX,
                    box.currentLoc.dy,
                  );
                }
                if (box.currentLoc.dx > gridSize - 0.5) {
                  box.currentLoc = Offset(
                    box.startLoc.dx - gridSize + translatedX,
                    box.currentLoc.dy,
                  );
                }
              }
            });
          },
          onVerticalDragUpdate: (details) {
            Offset dragOffset = details.localPosition - tappedLoc;
            double translatedY = dragOffset.dy / boardSize * gridSize;
            setState(() {
              for (GameBox box in tappedColumn) {
                box.currentLoc = box.startLoc + Offset(0, translatedY);
                if (box.currentLoc.dy <= -0.5) {
                  box.currentLoc = Offset(
                    box.currentLoc.dx,
                    box.startLoc.dy + gridSize + translatedY,
                  );
                }
                if (box.currentLoc.dy > gridSize - 0.5) {
                  box.currentLoc = Offset(
                    box.currentLoc.dx,
                    box.startLoc.dy - gridSize + translatedY,
                  );
                }
              }
            });
          },
          onHorizontalDragEnd: (detail) {
            context.read<GameBoardModel>().snapBoxes();
            context.read<GameBoardModel>().updateBoxesLocation();
            context.read<GameModel>().addMove();
          },
          onVerticalDragEnd: (detail) {
            context.read<GameBoardModel>().snapBoxes();
            context.read<GameBoardModel>().updateBoxesLocation();
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
                  return GameBoxTile(
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
