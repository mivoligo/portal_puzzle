import 'package:flutter/material.dart';

import 'game_board.dart';
import 'widgets/widgets.dart';

class LargeLayout extends StatelessWidget {
  const LargeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          top: 64,
          right: 64,
          child: DifficultySelector(),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(64.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 250,
                    child: AppTitle(isLarge: true),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Difficulty: Medium',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 24),
                  const MovesCounter(
                    movesCount: 1337,
                    isLarge: true,
                  ),
                  const SizedBox(height: 24),
                  HeroButton(
                    label: 'Shuffle',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return GameBoard(parentSize: constraints.biggest * 0.6);
          },
        ),
      ],
    );
  }
}
