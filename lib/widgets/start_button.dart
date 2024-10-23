import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart' as k;
import '../models/models.dart';
import 'widgets.dart';

class StartButton extends StatelessWidget {
  const StartButton({super.key, required this.onPressed});

  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final status = context.select<GameModel, Status>((model) => model.status);
    String label() {
      switch (status) {
        case Status.initial:
          return 'Play';
        case Status.finished:
          return 'Play Again';
        case Status.shuffling:
          return 'Shuffling';
        case Status.playable:
          return 'Shuffle';
      }
    }

    IconData? iconData() {
      switch (status) {
        case Status.initial:
        case Status.finished:
          return Icons.play_arrow;
        case Status.shuffling:
        case Status.playable:
          return Icons.refresh;
      }
    }

    final gameModel = context.read<GameModel>();
    return FancyButton(
      label: label(),
      surfaceColor: k.lightRose,
      sideColor: k.rose,
      textColor: k.darkRose,
      iconData: iconData(),
      isSmall: false,
      isSelected: status == Status.shuffling,
      onPressed: status == Status.finished
          ? gameModel.resetGame
          : () async {
              gameModel.shuffle();
              await onPressed();
              gameModel.markPlayable();
            },
    );
  }
}
