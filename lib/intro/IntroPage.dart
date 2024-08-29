import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  late AudioPlayer _audioPlayer;
  int _currentInstructionIndex = 0;
  final List<Color> _availableColors = [Colors.red, Colors.blue, Colors.yellow];
  late List<Map<String, dynamic>> _instructions = [];
  final Random _random = Random();

  Timer? _globalTimer;
  int _globalTimeLeft = 180; // 3 minutes = 180 seconds

  Timer? _instructionTimer;
  int _instructionTimeLeft = 0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _generateInstructions(); // Generate instructions
    _playMusic(); // Play music
    _startGame(); // Start the game
  }

  @override
  void dispose() {
    _globalTimer?.cancel();
    _instructionTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  // Generate instructions with specific color patterns
  void _generateInstructions() {
    _instructions.clear(); // Clear any previous instructions

    // Define fixed color patterns
    final List<List<Color>> colorPatterns = [
      [
        Colors.yellow,
        Colors.red,
        Colors.blue,
        Colors.yellow,
        Colors.red,
        Colors.blue
      ],
      [
        Colors.blue,
        Colors.yellow,
        Colors.red,
        Colors.blue,
        Colors.yellow,
        Colors.red
      ],
      [
        Colors.red,
        Colors.blue,
        Colors.yellow,
        Colors.red,
        Colors.blue,
        Colors.yellow
      ]
    ];

    // Define the instructions for each block
    final List<String> instructions = [
      "PA: Je pose mon pied gauche sur le rouge en dansant.",
      "AD: Je pose mon pied droit sur le jaune en dansant.",
      "AD: Je pose mon 2e pied sur la couleur à côté et je danse en balançant les bras.",
      "AD: Je pose mon 2e pied sur la couleur à côté et je danse en balançant les bras.",
      "AD: J'avance sur la couleur de mon 2e pied et je tapotte mes cuisses en dansant.",
      "AD: J'avance sur la couleur de mon 2e pied et je tapotte mes cuisses en dansant.",
      "AD: J'avance sur la couleur qui était à côté de ma jambe droite et je tourne sur moi en balançant mes bras.",
      "AD: J'avance sur la couleur qui était à côté de ma jambe droite et je tourne sur moi en balançant mes bras.",
      "AD: J'avance sur le rectangle en face.",
      "AD: J'avance sur le rectangle en face.",
      "PA et AD: J'avance sur la couleur occupée à la 3e ligne et je reprends tous les gestes.",
      "AD: J'avance sur la couleur occupée à la 3e ligne et je reprends tous les gestes.",
      "PA  AD: Je regarde mon compagnon et lui dis : 'Grâce à toi, je vis heureux et en paix,' puis nous avançons sur l'étoile et nous nous faisons un câlin.",
      "AD: Je regarde mon compagnon et lui dis : 'Grâce à toi, je vis heureux et en paix,' puis nous avançons sur l'étoile et nous nous faisons un câlin.",
      " AD:  puis nous avançons sur l'étoile et nous nous faisons un câlin.",
      "PA  AD:  puis nous avançons sur l'étoile et nous nous faisons un câlin.",
    ];

    int instructionIndex = 0;

    // Start with the third line
    for (int i = 2; i >= 0; i--) {
      List<Color> lineColors = colorPatterns[i];
      for (int j = 0; j < lineColors.length; j++) {
        _instructions.add({
          "bloc": (2 - i) * lineColors.length + j + 1,
          "color": lineColors[j],
          "instruction": instructionIndex < instructions.length
              ? instructions[instructionIndex]
              : "Pose-toi sur le bloc ${(2 - i) * lineColors.length + j + 1} et fais une action !",
        });

        instructionIndex++;
      }
    }

    _instructionTimeLeft = (_globalTimeLeft / _instructions.length).floor();
    print(
        'Instructions générées: $_instructions'); // Debugging: Verify if instructions are generated
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
        _instructionTimeLeft = (_globalTimeLeft /
                (_instructions.length - _currentInstructionIndex))
            .floor();
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
      _generateInstructions(); // Regenerate instructions on game restart
      _startGame();
    });
  }

  void _playMusic() async {
    await _audioPlayer.play(AssetSource('audio/music.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    // Ensure instructions are available before accessing the index
    if (_instructions.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text('Aucune instruction disponible'),
        ),
      );
    }

    final instruction = _instructions[_currentInstructionIndex];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://img.freepik.com/vecteurs-premium/printemps-ete-fond-paysage-dessin-anime_441769-104.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Column(
                children: [
                  _header(),
                  SizedBox(height: 30.0),
                  _quiz(instruction),
                  SizedBox(height: 50.0),
                  Expanded(
                    child: _palleteGame(),
                  ),
                  _bottomButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.lightBlue[200],
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(50.0),
          bottomLeft: Radius.circular(50.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(color: Colors.white30, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.notification_add),
                ),
              ),
              Container(
                width: 110,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.white30, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.access_time_filled_outlined),
                      Text(
                          "${_globalTimeLeft ~/ 60}:${(_globalTimeLeft % 60).toString().padLeft(2, '0')}"),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(color: Colors.white30, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.settings),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quiz(Map<String, dynamic> instruction) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Instructions",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Text(instruction["instruction"]),
              SizedBox(height: 10.0),
              Container(
                width: 50,
                height: 50,
                color: instruction["color"],
                child: Center(
                  child: Text(
                    instruction["bloc"].toString(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _palleteGame() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
        ),
        itemCount: _instructions.length,
        itemBuilder: (context, index) {
          final instruction = _instructions[index];
          return Container(
            margin: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
                color: instruction["color"],
                borderRadius: BorderRadius.circular(4.0)),
            child: Center(
              child: Text(
                instruction["bloc"].toString(),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _bottomButtons() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            child: Text(
              'Précédent',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: _previousInstruction,
          ),
          ElevatedButton(
            child: Text(
              'Suivant',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: _nextInstruction,
          ),
        ],
      ),
    );
  }

  void _previousInstruction() {
    if (_currentInstructionIndex > 0) {
      setState(() {
        _currentInstructionIndex--;
        _instructionTimeLeft = (_globalTimeLeft /
                (_instructions.length - _currentInstructionIndex))
            .floor();
      });
      _startInstructionTimer();
    }
  }
}
