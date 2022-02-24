import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart' as k;
import '../models/models.dart';
import 'widgets.dart';

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({Key? key, required this.onPressed}) : super(key: key);

  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final status = context.select<GameModel, Status>((model) => model.status);
    String label() {
      switch (status) {
        case Status.initial:
        case Status.finished:
          return 'Start!';
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

    return SizedBox(
      width: 150,
      child: HeroButton(
        label: label(),
        surfaceColor: k.lightRed,
        sideColor: k.red,
        textColor: k.darkRed,
        iconData: iconData(),
        isSmall: false,
        isSelected: status == Status.shuffling,
        onPressed: () async {
          context.read<GameModel>().shuffle();
          await onPressed();
          context.read<GameModel>().markPlayable();
        },
      ),
    );
  }
}
