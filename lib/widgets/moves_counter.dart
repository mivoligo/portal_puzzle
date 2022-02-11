import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_model.dart';

class MovesCounter extends StatelessWidget {
  const MovesCounter({
    Key? key,
    // required this.movesCount,
    this.isLarge = false,
  }) : super(key: key);

  // final int movesCount;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    final movesCount = context.select<GameModel, int>(
      (model) => model.numOfMoves,
    );
    return Text(
      'Moves: $movesCount',
      style: isLarge
          ? const TextStyle(fontSize: 32)
          : const TextStyle(fontSize: 24),
    );
  }
}
