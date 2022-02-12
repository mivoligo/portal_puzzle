import 'package:flutter/material.dart';

import 'game_board.dart';
import 'widgets/widgets.dart';

class MediumLayout extends StatelessWidget {
  const MediumLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  AppTitle(),
                  DifficultySelector(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  MovesCounter(isLarge: true),
                  ShuffleButton(),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (_, constraints) {
                  return GameBoard(parentSize: constraints.biggest * 0.8);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
