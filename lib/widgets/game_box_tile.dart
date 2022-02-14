import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class GameBoxTile extends StatelessWidget {
  const GameBoxTile({
    Key? key,
    required this.box,
    required this.text,
    required this.boardSize,
  }) : super(key: key);

  final GameBox box;
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
          ),
        ),
      ),
    );
  }
}
