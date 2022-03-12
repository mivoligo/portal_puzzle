import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
        context: context,
        builder: (context) => const _InfoDialog(),
      ),
    );
  }
}

class _InfoDialog extends StatelessWidget {
  const _InfoDialog({Key? key}) : super(key: key);

  Future<void> openSimpleLink(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(16),
      title: const Center(child: Text(k.appName)),
      children: [
        const Center(
          child: Text(
            'In the digital world you don\'t have to be limited by an analog box',
            style: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'How to play',
          style: TextStyle(fontSize: 18),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('1. Press the Play button.'),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('2. Wait until the shuffling ends.'),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
              '3. Move the tiles horizontally or vertically until you find the solution.'),
        ),
        SizedBox(
          width: 200,
          height: 200,
          child: Image.asset('assets/images/game-play-min.gif'),
        ),
        const SizedBox(height: 16),
        const Text(
          'Tips & Tricks',
          style: TextStyle(fontSize: 18),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
              'You can select a difficulty. Maybe start from the Easy one.'),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'You can use your keyboard to control everything.\n'
            'To see the keyboard shortcuts, press the space bar at any time.',
            style: TextStyle(height: 1.5),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'About the app',
          style: TextStyle(fontSize: 18),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Portal Puzzle was created as a project for the Flutter Puzzle Hack.\n'
            'The classic 15 slide puzzle is fun until you figure out (or see on internet) how to easily solve it every time.\n'
            'When I had a chance to create the puzzle in the digital form,\n'
            'I thought: why not do something which is not a strict copy of the "analog" box with tiles.\n'
            'Why not allow those tiles to move through "portals"... The rest is history (git log).',
            style: TextStyle(height: 1.5),
          ),
        ),
        InkWell(
          hoverColor: Colors.transparent,
          onTap: () =>
              openSimpleLink('https://github.com/mivoligo/portal_puzzle'),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text.rich(
              TextSpan(
                  text: 'Check the project page on github',
                  style: TextStyle(color: k.blue, fontSize: 18),
                  children: [
                    WidgetSpan(
                      child: Icon(Icons.launch, color: k.blue, size: 24),
                    ),
                  ]),
            ),
          ),
        ),
        InkWell(
          hoverColor: Colors.transparent,
          onTap: () => openSimpleLink(
              'https://github.com/mivoligo/portal_puzzle/issues'),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text.rich(
              TextSpan(
                  text: 'Report problem in the app',
                  style: TextStyle(color: k.blue, fontSize: 18),
                  children: [
                    WidgetSpan(
                      child: Icon(Icons.launch, color: k.blue, size: 24),
                    ),
                  ]),
            ),
          ),
        ),
      ],
    );
  }
}
