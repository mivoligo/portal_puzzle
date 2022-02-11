import 'package:flutter/material.dart';
import 'package:portal_puzzle/app_title.dart';

import 'difficulty_selector.dart';
import 'game_board.dart';
import 'hero_button.dart';

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
                const Text(
                  '133 moves',
                  style: TextStyle(fontSize: 24),
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
