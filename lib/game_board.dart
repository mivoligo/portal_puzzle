import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/models.dart';
import 'widgets/widgets.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({
    Key? key,
    required this.parentSize,
  }) : super(key: key);

  final Size parentSize;

  @override
  Widget build(BuildContext context) {
    final gridSize = context.watch<GameModel>().gridSize;
    final boxes = context.watch<GameBoardModel>().boxes;
    double boardSize = parentSize.shortestSide;
    return Center(
      child: SizedBox(
        width: boardSize,
        height: boardSize,
        child: GestureDetector(
          onHorizontalDragStart: (details) {
            context.read<GameBoardModel>().setTappedRow(
                  boardSize: boardSize,
                  gridSize: gridSize,
                  details: details,
                );
          },
          onVerticalDragStart: (details) {
            context.read<GameBoardModel>().setTappedColumn(
                  boardSize: boardSize,
                  gridSize: gridSize,
                  details: details,
                );
          },
          onHorizontalDragUpdate: (details) {
            context
                .read<GameBoardModel>()
                .dragRow(details, gridSize, boardSize);
          },
          onVerticalDragUpdate: (details) {
            context
                .read<GameBoardModel>()
                .dragColumn(details, gridSize, boardSize);
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
