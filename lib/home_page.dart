import 'package:flutter/material.dart';
import 'package:portal_puzzle/constants.dart';
import 'package:portal_puzzle/large_layout.dart';
import 'package:portal_puzzle/medium_layout.dart';
import 'package:portal_puzzle/small_layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
