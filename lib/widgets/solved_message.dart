import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/models.dart';

class SolvedMessage extends StatelessWidget {
  const SolvedMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final numberOfMoves = context.select<GameModel, int>(
      (model) => model.numOfMoves,
    );
    return Text(
      'Congrats! Solved in $numberOfMoves moves.',
      style: const TextStyle(
        fontSize: 24,
        color: darkViolet,
      ),
      textAlign: TextAlign.center,
    );
  }
}
