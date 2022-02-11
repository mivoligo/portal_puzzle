import 'package:flutter/material.dart';
import 'package:portal_puzzle/app_title.dart';

import 'game_board.dart';

class MediumLayout extends StatelessWidget {
  const MediumLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppTitle(),
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
