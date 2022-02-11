import 'package:flutter/material.dart';

import 'game_board.dart';

class MediumLayout extends StatelessWidget {
  const MediumLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Medium layout'),
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
