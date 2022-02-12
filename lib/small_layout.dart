import 'package:flutter/material.dart';

import 'game_board.dart';
import 'widgets/widgets.dart';

class SmallLayout extends StatelessWidget {
  const SmallLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: AppTitle(),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: DifficultySelector(),
            ),
            const MovesCounter(),
            const SizedBox(height: 12),
            Expanded(
              child: LayoutBuilder(
                builder: (_, constraints) =>
                    GameBoard(parentSize: constraints.biggest * 0.8),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: ShuffleButton(),
            ),
          ],
        ),
      ],
    );
  }
}
