import 'package:flutter/material.dart';

import 'game_board.dart';

class LargeLayout extends StatelessWidget {
  const LargeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Big layout'),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return GameBoard(parentSize: constraints.biggest);
            },
          ),
        ),
      ],
    );
    ;
  }
}
