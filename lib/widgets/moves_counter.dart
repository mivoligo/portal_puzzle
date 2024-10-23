import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class MovesCounter extends StatelessWidget {
  const MovesCounter({
    super.key,
    this.isLarge = false,
  });

  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    final movesCount = context.select<GameModel, int>(
      (model) => model.numOfMoves,
    );
    return TweenAnimationBuilder(
        tween: IntTween(begin: movesCount, end: movesCount),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutQuint,
        builder: (_, value, __) {
          return Text(
            'Moves: $value',
            style: isLarge
                ? const TextStyle(fontSize: 32)
                : const TextStyle(fontSize: 24),
          );
        });
  }
}
