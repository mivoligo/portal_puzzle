import 'package:flutter/material.dart';
import 'package:portal_puzzle/app_title.dart';
import 'package:portal_puzzle/difficulty_selector.dart';
import 'package:portal_puzzle/game_board.dart';

class SmallLayout extends StatelessWidget {
  const SmallLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppTitle(),
        Expanded(
          child: Column(
            children: [
              const DifficultySelector(),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  return GameBoard(parentSize: constraints.biggest);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
