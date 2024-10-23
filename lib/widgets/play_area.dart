import 'package:flutter/material.dart';

import '../models/models.dart';
import 'widgets.dart';

class PlayArea extends StatelessWidget {
  const PlayArea({
    super.key,
    required this.boardSize,
    required this.boxes,
    required this.gridSize,
    required this.status,
    required this.animationController,
  });

  final double boardSize;
  final List<GameBox> boxes;
  final int gridSize;
  final Status status;
  final Animation animationController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0x22FFFFFF),
            borderRadius: BorderRadius.all(
              Radius.circular(boardSize * 0.01),
            ),
          ),
        ),
        ...boxes.map(
          (box) {
            final index = boxes.indexOf(box);
            final gameBoxRect = box.getRect(
              boardSize: boardSize,
              gridSize: gridSize,
            );
            return AnimatedPositioned(
              duration: status != Status.shuffling
                  ? Duration.zero
                  : const Duration(milliseconds: 150),
              left: gameBoxRect.left,
              top: gameBoxRect.top,
              child: AnimatedTile(
                gridSize: gridSize,
                dx: box.currentLoc.dx,
                dy: box.currentLoc.dy,
                animation: animationController,
                child: GameBoxTile(
                  box: box,
                  text: '${index + 1}',
                  boardSize: boardSize,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
