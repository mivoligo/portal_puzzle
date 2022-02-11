import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../game_model.dart';
import 'widgets.dart';

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HeroButton(
      label: 'Shuffle',
      onPressed: context.read<GameModel>().resetGame,
    );
  }
}
