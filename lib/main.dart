import 'package:flutter/material.dart';
import 'package:portal_puzzle/game_board.dart';

const gridSize = 4;
const relativeGapSize = 1 / 12;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 100,
            color: Colors.green,
          ),
          Expanded(child: LayoutBuilder(builder: (context, constraints) {
            return GameBoard(
              parentSize: constraints.biggest * 0.8,
            );
          })),
        ],
      ),
    );
  }
}
