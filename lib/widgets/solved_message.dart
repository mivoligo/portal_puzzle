import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/models.dart';

class SolvedMessage extends StatelessWidget {
  const SolvedMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final numberOfMoves = context.select<GameModel, int>(
      (model) => model.numOfMoves,
    );
    return TweenAnimationBuilder(
      tween: IntTween(begin: 0, end: numberOfMoves),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutQuint,
      builder: (_, value, __) {
        return Text(
          'Congrats! Solved in\n$value moves.',
          style: const TextStyle(
            fontSize: 24,
            color: darkViolet,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        );
      },
    );
  }
}
