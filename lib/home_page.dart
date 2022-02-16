import 'package:flutter/material.dart';
import 'package:portal_puzzle/constants.dart';
import 'package:portal_puzzle/large_layout.dart';
import 'package:portal_puzzle/medium_layout.dart';
import 'package:portal_puzzle/models/models.dart';
import 'package:portal_puzzle/small_layout.dart';
import 'package:provider/provider.dart';

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
    return Scaffold(
      body: LayoutBuilder(
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
    );
  }
}
