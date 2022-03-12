import 'package:flutter/material.dart';

import '../constants.dart' as k;
import 'widgets.dart';

class InfoButton extends StatelessWidget {
  const InfoButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FancyButton(
      label: '?',
      surfaceColor: k.lightSlate,
      sideColor: k.slate,
      textColor: k.darkSlate,
      onPressed: () => showAboutDialog(context: context),
    );
  }
}
