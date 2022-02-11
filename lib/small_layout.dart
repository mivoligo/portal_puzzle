import 'package:flutter/material.dart';
import 'package:portal_puzzle/app_title.dart';
import 'package:portal_puzzle/difficulty_selector.dart';
import 'package:portal_puzzle/game_board.dart';
import 'package:portal_puzzle/hero_button.dart';
import 'package:portal_puzzle/moves_counter.dart';

class SmallLayout extends StatelessWidget {
  const SmallLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: AppTitle(),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: DifficultySelector(),
                ),
                const MovesCounter(movesCount: 1337),
                const SizedBox(height: 12),
                GameBoard(parentSize: constraints.biggest * 0.8),
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
