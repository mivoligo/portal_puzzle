import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/models.dart';
import 'widgets/widgets.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({
    Key? key,
    required this.parentSize,
  }) : super(key: key);

  final Size parentSize;

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  double localX = 0;
  double localY = 0;
  bool defaultPosition = true;

  @override
  Widget build(BuildContext context) {
    final gridSize = context.watch<GameModel>().gridSize;
    final boxes = context.watch<GameBoardModel>().boxes;
    double boardSize = widget.parentSize.shortestSide;

    double percentX = (localX / boardSize) * 100;
    double percentY = (localY / boardSize) * 100;

    return Center(
      child: SizedBox(
        width: boardSize,
        height: boardSize,
        child: GestureDetector(
          onHorizontalDragStart: (details) {
            setState(() {
              defaultPosition = false;
            });
            context.read<GameBoardModel>().setTappedRow(
                  boardSize: boardSize,
                  gridSize: gridSize,
                  details: details,
                );
          },
          onVerticalDragStart: (details) {
            setState(() {
              defaultPosition = false;
            });
            context.read<GameBoardModel>().setTappedColumn(
                  boardSize: boardSize,
                  gridSize: gridSize,
                  details: details,
                );
          },
          onHorizontalDragUpdate: (details) {
            setState(() {
              updatePanning(details, boardSize);
            });
            context
                .read<GameBoardModel>()
                .dragRow(details, gridSize, boardSize);
          },
          onVerticalDragUpdate: (details) {
            setState(() {
              updatePanning(details, boardSize);
            });
            context
                .read<GameBoardModel>()
                .dragColumn(details, gridSize, boardSize);
          },
          onHorizontalDragEnd: (detail) {
            setState(() {
              defaultPosition = true;
            });
            context.read<GameBoardModel>().snapBoxes();
            context.read<GameBoardModel>().updateBoxesLocation();
            context.read<GameModel>().addMove();
          },
          onVerticalDragEnd: (detail) {
            setState(() {
              defaultPosition = true;
            });
            context.read<GameBoardModel>().snapBoxes();
            context.read<GameBoardModel>().updateBoxesLocation();
            context.read<GameModel>().addMove();
          },
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(defaultPosition ? 0 : (0.1 * (percentY / 50) - 0.1))
              ..rotateY(defaultPosition ? 0 : (-0.1 * (percentX / 50) + 0.1)),
            alignment: FractionalOffset.center,
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
      ),
    );
  }

  void updatePanning(DragUpdateDetails details, double boardSize) {
    if (details.localPosition.dx > 0 &&
        details.localPosition.dx < boardSize &&
        details.localPosition.dy > 0 &&
        details.localPosition.dy < boardSize) {
      localX = details.localPosition.dx;
      localY = details.localPosition.dy;
    }
  }
}
