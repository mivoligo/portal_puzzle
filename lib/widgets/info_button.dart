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
      onPressed: () => showDialog(
          context: context, builder: (context) => const _InfoDialog()),
    );
  }
}

class _InfoDialog extends StatelessWidget {
  const _InfoDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SimpleDialog(
      contentPadding: EdgeInsets.all(16),
      title: Center(child: Text(k.appName)),
      children: [
        Center(
          child: Text(
            'In the digital world you don\'t need to be limited by an analog box',
            style: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          'How to play',
          style: TextStyle(fontSize: 18),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('1. Press the Play button.'),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('2. Wait until the shuffling ends.'),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('3. Move the tiles around until you find the solution.'),
        ),
        SizedBox(height: 16),
        Text(
          'Tips & Tricks',
          style: TextStyle(fontSize: 18),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
              'You can select a difficulty. Maybe start from the Easy one.'),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('You can use your keyboard to control everything.\n'
              'To see the keyboard shortcuts, press the space bar at any time.'),
        ),
        SizedBox(height: 16),
        Text(
          'About the app',
          style: TextStyle(fontSize: 18),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
              'Portal Puzzle was created as a project for the Flutter Puzzle Hack.\n'
              'The classic 15 slide puzzle is fun until you figure out (or see on internet) how to easily solve it every time.\n'
              'When I had a chance to create the puzzle in the digital form,\n'
              'I thought: why not do something which is not a strict copy of the "analog" box with tiles.\n'
              'Why not allow those tiles to move through "portals"... The rest is history (git log).'),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Check the source code.'),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Report problems in the app.'),
        ),
      ],
    );
  }
}
