import 'package:flutter/material.dart';
import 'package:portal_puzzle/constants.dart' as k;

import 'package:provider/provider.dart';

import '../models/models.dart';
import 'widgets.dart';

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HeroButton(
      label: 'Shuffle',
      surfaceColor: k.lightRed,
      sideColor: k.red,
      textColor: k.darkRed,
      iconData: Icons.refresh,
      isSmall: false,
      onPressed: context.read<GameModel>().shuffle,
    );
  }
}
