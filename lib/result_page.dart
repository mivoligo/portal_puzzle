import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart' as k;
import 'models/models.dart';
import 'widgets/widgets.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final numberOfMoves =
        context.select<GameModel, int>((model) => model.numOfMoves);
    final backgroundColor =
        context.select<GameModel, Color>((model) => model.backgroundColor);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Great Job!',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 24),
            Text(
              'You needed just $numberOfMoves moves to solve it!',
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 24),
            HeroButton(
              label: 'Play again',
              iconData: Icons.play_arrow,
              onPressed: context.read<GameModel>().resetGame,
              surfaceColor: k.lightRed,
              sideColor: k.red,
              textColor: k.darkRed,
            ),
          ],
        ),
      ),
    );
  }
}
