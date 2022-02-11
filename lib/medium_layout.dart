import 'package:flutter/material.dart';

import 'game_board.dart';
import 'widgets/widgets.dart';

class MediumLayout extends StatelessWidget {
  const MediumLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            child: Column(
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
                const MovesCounter(
                  movesCount: 1337,
                  isLarge: true,
                ),
                const SizedBox(height: 12),
                GameBoard(parentSize: constraints.biggest * 0.6),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: HeroButton(
                    label: 'Shuffle',
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
