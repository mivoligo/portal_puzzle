import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'large_layout.dart';
import 'medium_layout.dart';
import 'models/models.dart';
import 'result_page.dart';
import 'small_layout.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final gridSize = context.read<GameModel>().gridSize;
    context.read<GameBoardModel>().generateGameBoxes(gridSize: gridSize);
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.watch<GameModel>().backgroundColor;
    final status = context.select<GameModel, Status>((model) => model.status);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: status == Status.finished
          ? const ResultPage()
          : Scaffold(
              body: AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                color: backgroundColor,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final layoutWidth = constraints.maxWidth;
                    if (layoutWidth < widthSmall) {
                      return const SmallLayout();
                    } else if (layoutWidth < widthMedium) {
                      return const MediumLayout();
                    } else if (layoutWidth < widthLarge) {
                      return const LargeLayout();
                    }
                    return const LargeLayout();
                  },
                ),
              ),
            ),
    );
  }
}
