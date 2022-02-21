import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';
import 'models/models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portal Puzzle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Rubik',
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<GameModel>(
            create: (_) => GameModel(),
          ),
          ChangeNotifierProvider<GameBoardModel>(
            create: (_) => GameBoardModel(),
          ),
        ],
        child: const HomePage(),
      ),
    );
  }
}
