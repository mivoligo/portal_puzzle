import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/models.dart';
import 'widgets.dart';

class TryAgainButton extends StatelessWidget {
  const TryAgainButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HeroButton(
      isSmall: false,
      label: 'Play Again',
      iconData: Icons.play_arrow,
      onPressed: context.read<GameModel>().resetGame,
      surfaceColor: lightRed,
      sideColor: red,
      textColor: darkRed,
    );
  }
}
