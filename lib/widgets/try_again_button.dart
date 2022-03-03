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
      label: 'Try Again',
      onPressed: context.read<GameModel>().resetGame,
      surfaceColor: lightRed,
      sideColor: red,
      textColor: darkRed,
    );
  }
}
