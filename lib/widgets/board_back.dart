import 'package:flutter/material.dart';

class BoardBack extends StatelessWidget {
  const BoardBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.4,
      heightFactor: 0.4,
      child: Image.asset(
        'assets/images/gift.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
