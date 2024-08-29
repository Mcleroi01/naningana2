import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ColorGame(),
    );
  }
}

class ColorGame extends StatefulWidget {
  @override
  _ColorGameState createState() => _ColorGameState();
}

class _ColorGameState extends State<ColorGame> {
  int _currentInstructionIndex = 0;
  final List<Color> _availableColors = [Colors.red, Colors.blue, Colors.yellow];
  final List<Map<String, dynamic>> _instructions = [];
  final Random _random = Random();

  Timer? _globalTimer;
  int _globalTimeLeft = 180; // 3 minutes = 180 seconds

  Timer? _instructionTimer;
  int _instructionTimeLeft = 0;

  @override
  void initState() {
    super.initState();
    _generateInstructions();
    _startGame();
  }

  @override
  void dispose() {
    _globalTimer?.cancel();
    _instructionTimer?.cancel();
    super.dispose();
  }

  // Générer des instructions aléatoires pour chaque bloc
  void _generateInstructions() {
    for (int i = 0; i < 18; i++) {
      _instructions.add({
        "bloc": i + 1,
        "color": _availableColors[_random.nextInt(_availableColors.length)],
        "instruction": "Pose-toi sur le bloc ${i + 1} et fais une action !",
      });
    }
    _instructionTimeLeft = (_globalTimeLeft / _instructions.length).floor();
  }

  void _startGame() {
    _startGlobalTimer();
    _startInstructionTimer();
  }

  void _startGlobalTimer() {
    _globalTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_globalTimeLeft > 0) {
        setState(() {
          _globalTimeLeft--;
        });
      } else {
        _endGame();
      }
    });
  }

  void _startInstructionTimer() {
    _instructionTimer?.cancel();
    _instructionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_instructionTimeLeft > 0) {
        setState(() {
          _instructionTimeLeft--;
        });
      } else {
        _nextInstruction();
      }
    });
  }

  void _nextInstruction() {
    if (_currentInstructionIndex < _instructions.length - 1) {
      setState(() {
        _currentInstructionIndex++;
        _instructionTimeLeft = (_globalTimeLeft / (_instructions.length - _currentInstructionIndex)).floor();
      });
      _startInstructionTimer();
    } else {
      _endGame();
    }
  }

  void _endGame() {
    _globalTimer?.cancel();
    _instructionTimer?.cancel();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Fin du jeu"),
        content: Text("Le jeu est terminé !"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: Text("Rejouer"),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      _currentInstructionIndex = 0;
      _globalTimeLeft = 180;
      _generateInstructions();
      _startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final instruction = _instructions[_currentInstructionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Jeu de Couleurs"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Affichage de l'instruction actuelle
            Text(
              instruction["instruction"],
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            // Timer global
            Text(
              "Temps restant: ${_globalTimeLeft ~/ 60}:${(_globalTimeLeft % 60).toString().padLeft(2, '0')}",
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
            SizedBox(height: 20),
            // Timer de l'instruction
            Text(
              "Temps pour cette instruction: $_instructionTimeLeft sec",
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
            SizedBox(height: 20),
            // Grille de blocs
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6, // 6 blocs par ligne
              ),
              itemCount: 18, // 3 lignes * 6 blocs = 18 blocs
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(4),
                  color: index == instruction["bloc"] - 1 ? instruction["color"] : Colors.grey,
                  height: 50,
                  width: 50,
                  child: Center(
                    child: Text((index + 1).toString()),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            // Boutons "Précédent" et "Suivant"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _currentInstructionIndex > 0 ? () {
                    setState(() {
                      _currentInstructionIndex--;
                      _instructionTimeLeft = (_globalTimeLeft / (_instructions.length - _currentInstructionIndex)).floor();
                      _startInstructionTimer();
                    });
                  } : null,
                  child: Text("Précédent"),
                ),
                ElevatedButton(
                  onPressed: _nextInstruction,
                  child: Text("Suivant"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
