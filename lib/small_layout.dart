import 'package:flutter/material.dart';
import 'package:portal_puzzle/difficulty_selector.dart';
import 'package:portal_puzzle/game_board.dart';

class SmallLayout extends StatelessWidget {
  const SmallLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Small layout'),
        DifficultySelector(),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return GameBoard(parentSize: constraints.biggest);
            },
          ),
        ),
      ],
    );
  }
}
