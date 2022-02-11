import 'package:flutter/material.dart';
import 'package:portal_puzzle/constants.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({
    Key? key,
    this.isLarge = false,
  }) : super(key: key);

  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return Text(
      appName,
      style: isLarge
          ? Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w600,
              )
          : Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
    );
  }
}
