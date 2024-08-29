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

  // Add this line
  List<int> _highlightedBlocks = [];

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
    _audioPlayer.dispose();
    super.dispose();
  }

  void _generateInstructions() {
    _instructions.clear(); // Effacer les instructions précédentes

    // Définir les motifs de couleur fixes
    final List<List<Color>> colorPatterns = [
      [Colors.red, Colors.blue, Colors.yellow, Colors.red, Colors.blue, Colors.yellow],
      [Colors.blue, Colors.yellow, Colors.red, Colors.blue, Colors.yellow, Colors.red],
      [Colors.yellow, Colors.red, Colors.blue, Colors.yellow, Colors.red, Colors.blue],

    ];

    // Définir les instructions pour chaque bloc
    final List<Map<String, dynamic>> instructions = [
      {"bloc": 13, "color": Colors.red, "instruction": "PA: Je pose mon pied gauche sur le rouge en dansant", "highlight": [13]},
      {"bloc": 18, "color": Colors.yellow, "instruction": "AD: Je pose mon pied droit sur le jaune en dansant  ", "highlight": [18]},
      {"bloc": 14, "color": Colors.red, "instruction": "PA: Je pose mon 2e pied sur la couleur à  côté et je danse en balançant les bras.", "highlight": [14]},
      {"bloc": 17, "color": Colors.yellow, "instruction": "AD: Je pose mon 2e pied sur la couleur à  côté et je danse en balançant les bras", "highlight": [17]},
      {"bloc": 8, "color": Colors.red, "instruction": "PA: J'avance sur la couleur de mon 2e pied et je tapotte mes cuisses en dansant.   ", "highlight": [8]},
      {"bloc": 12, "color": Colors.yellow, "instruction": "AD: J'avance sur la couleur de mon 2e pied et je tapotte mes cuisses en dansant.   ", "highlight": [12]},
      {"bloc": 7, "color": Colors.red, "instruction": "PA: J'avance sur la couleur qui était à côté de ma jambe droite et je tourne sur moi en balançant mes bras. ", "highlight": [7]},
      {"bloc": 11, "color": Colors.yellow, "instruction": "AD: J'avance sur la couleur qui était à côté de ma jambe droite et je tourne sur moi en balançant mes bras. ", "highlight": [11]},
      {"bloc": 9, "color": Colors.red, "instruction": "PA: Je pose mon pied gauche sur le rouge en dansant", "highlight": [9]},
      {"bloc": 10, "color": Colors.yellow, "instruction": "AD: Je pose mon pied droit sur le jaune en dansant  ", "highlight": [10]},
      {"bloc": 11, "color": Colors.red, "instruction": "PA: Je pose mon 2e pied sur la couleur à  côté et je danse en balançant les bras.", "highlight": [11]},
      {"bloc": 12, "color": Colors.yellow, "instruction": "AD: Je pose mon 2e pied sur la couleur à  côté et je danse en balançant les bras", "highlight": [12]},
      {"bloc": 13, "color": Colors.red, "instruction": "PA: J'avance sur la couleur de mon 2e pied et je tapotte mes cuisses en dansant.   ", "highlight": [13]},
      {"bloc": 14, "color": Colors.yellow, "instruction": "AD: J'avance sur la couleur de mon 2e pied et je tapotte mes cuisses en dansant.   ", "highlight": [14]},
      {"bloc": 15, "color": Colors.red, "instruction": "PA: J'avance sur la couleur qui était à côté de ma jambe droite et je tourne sur moi en balançant mes bras. ", "highlight": [15]},
      {"bloc": 16, "color": Colors.yellow, "instruction": "AD: J'avance sur la couleur qui était à côté de ma jambe droite et je tourne sur moi en balançant mes bras. ", "highlight": [16]}
      // Ajoutez d'autres instructions ici
    ];

    int instructionIndex = 0;

    // Commencer avec la troisième ligne
    for (int i = 2; i >= 0; i--) {
      List<Color> lineColors = colorPatterns[i];
      for (int j = 0; j < lineColors.length; j++) {
        // Vérifiez si l'index d'instruction est valide
        String instructionText = instructionIndex < instructions.length
            ? instructions[instructionIndex]["instruction"]
            : "Pose-toi sur le bloc ${(2 - i) * lineColors.length + j + 1} et fais une action !";

        List<int> highlight = instructionIndex < instructions.length
            ? instructions[instructionIndex]["highlight"]
            : [];

        _instructions.add({
          "bloc": (2 - i) * lineColors.length + j + 1,
          "color": lineColors[j],
          "instruction": instructionText,
          "highlight": highlight
        });

        instructionIndex++;
      }
    }


    print('Instructions générées: $_instructions'); // Débogage : Vérifiez si les instructions sont générées
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
    _instructionTimer = Timer.periodic(Duration(seconds: 10), (timer) {
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
        final currentInstruction = _instructions[_currentInstructionIndex];
        _highlightedBlocks = List<int>.from(currentInstruction["highlight"]);
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
      _generateInstructions(); // Regenerate instructions on game restart
      _startGame();
    });
  }

  void _playMusic() async {
    await _audioPlayer.play(AssetSource('audio/music.mp3'));
  }

  // Method to check if a bloc should be highlighted based on the current instruction
  bool _isBlocHighlighted(int bloc) {
    final instruction = _instructions[_currentInstructionIndex]["instruction"];
    return instruction.contains("bloc $bloc");
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
      backgroundColor: Colors.black12,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black12,
              image: DecorationImage(
                image: NetworkImage(
                    'https://img.freepik.com/free-vector/snake-ladders-game-template-farm-theme_1308-89464.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
              child: Column(
                children: [
                  _header(),
                  SizedBox(height: 30.0),
                  _quiz(instruction),
                  SizedBox(height: 50.0),
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black26
                        ),
                        child: _palleteGame()),
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
        color: Colors.black26,
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
                  child: Icon(Icons.volume_down,color: Colors.lightBlue,),
                ),
              ),
              Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white30, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Center(
                    child: Text(
                      'palet game'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue,
                      ),
                    ),
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
                  child: Icon(Icons.info),
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
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        height: 150.0,
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              instruction["instruction"],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
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
          crossAxisCount: 6, // Par exemple, 6 colonnes
        ),
        itemCount: _instructions.length,
        itemBuilder: (context, index) {
          final instruction = _instructions[index];
          final isHighlighted = _highlightedBlocks.contains(instruction["bloc"]);

          return Container(
            margin: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: instruction["color"],
              borderRadius: BorderRadius.circular(4.0),
              border: isHighlighted
                  ? Border.all(color: Colors.green, width: 4.0) // Bordure rouge pour mise en évidence
                  : null,
            ),
            child: Center(
              child: Text(
                instruction["bloc"].toString(),
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }



  Widget _bottomButtons() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/h');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Icon(Icons.arrow_back,color: Colors.white,),
            ),
          ),
          ElevatedButton(
            onPressed: _nextInstruction,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Icon(Icons.arrow_forward,color: Colors.white,),
            ),
          ),
        ],
      ),
    );
  }
}
