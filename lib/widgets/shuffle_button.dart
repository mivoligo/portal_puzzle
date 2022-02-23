import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart' as k;
import '../models/models.dart';
import 'widgets.dart';

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = context.select<GameModel, Status>((model) => model.status);
    return SizedBox(
      width: 140,
      child: HeroButton(
        label: status == Status.initial ? 'Start!' : 'Shuffle',
        surfaceColor: k.lightRed,
        sideColor: k.red,
        textColor: k.darkRed,
        iconData: status == Status.initial ? Icons.play_arrow : Icons.refresh,
        isSmall: false,
        onPressed: context.read<GameModel>().shuffle,
      ),
    );
  }
}
