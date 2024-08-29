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
      [
        Colors.red,
        Colors.blue,
        Colors.yellow,
        Colors.red,
        Colors.blue,
        Colors.yellow
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
        Colors.yellow,
        Colors.red,
        Colors.blue,
        Colors.yellow,
        Colors.red,
        Colors.blue
      ],
    ];

    // Définir les instructions pour chaque bloc
    final List<Map<String, dynamic>> instructions = [
      {
        "bloc": 13,
        "color": Colors.red,
        "instruction": "PA: Je pose mon pied gauche sur le rouge en dansant",
        "highlight": [13],
        "image":
            "https://i.pinimg.com/originals/57/e2/09/57e209296e586933febadf06e271a3d3.gif"
      },
      {
        "bloc": 18,
        "color": Colors.yellow,
        "instruction": "AD: Je pose mon pied droit sur le jaune en dansant  ",
        "highlight": [18],
        "image":
            "https://i.gifer.com/3sjq.gif"
      },
      {
        "bloc": 14,
        "color": Colors.red,
        "instruction":
            "PA: Je pose mon 2e pied sur la couleur à  côté et je danse en balançant les bras.",
        "highlight": [14],
        "image":
            "https://www.icegif.com/wp-content/uploads/2022/01/icegif-1456.gif"
      },
      {
        "bloc": 17,
        "color": Colors.yellow,
        "instruction":
            "AD: Je pose mon 2e pied sur la couleur à  côté et je danse en balançant les bras",
        "highlight": [17],
        "image":
            "https://www.icegif.com/wp-content/uploads/2022/01/icegif-1456.gif"
      },
      {
        "bloc": 8,
        "color": Colors.red,
        "instruction":
            "PA: J'avance sur la couleur de mon 2e pied et je tapotte mes cuisses en dansant.   ",
        "highlight": [8],
        "image":
            "https://i.pinimg.com/originals/57/e2/09/57e209296e586933febadf06e271a3d3.gif"
      },
      {
        "bloc": 12,
        "color": Colors.yellow,
        "instruction":
            "AD: J'avance sur la couleur de mon 2e pied et je  tapotte mes cuisses en dansant.   ",
        "highlight": [12],
        "image":
            "https://media1.giphy.com/media/fXgNQdnq8Bo96tcZAT/giphy.gif?cid=6c09b952aftcmbssi9tnh2fpu9wjdg3hxyz0pc619h6f486s&amp;ep=v1_internal_gif_by_id&amp;rid=giphy.gif&amp;ct=s"
      },
      {
        "bloc": 7,
        "color": Colors.red,
        "instruction":
            "PA: J'avance sur la couleur qui était à côté de ma jambe droite et je tourne sur moi en balançant mes bras. ",
        "highlight": [7],
        "image":
            "https://i.pinimg.com/originals/57/e2/09/57e209296e586933febadf06e271a3d3.gif"
      },
      {
        "bloc": 11,
        "color": Colors.yellow,
        "instruction":
            "AD: J'avance sur la couleur qui était à côté de ma jambe droite et je tourne sur moi en balançant mes bras. ",
        "highlight": [11],
        "image":
            "https://i.pinimg.com/originals/57/e2/09/57e209296e586933febadf06e271a3d3.gif"
      },
      {
        "bloc": 9,
        "color": Colors.red,
        "instruction": "PA: Je pose mon pied gauche sur le rouge en dansant",
        "highlight": [9],
        "image":
            "https://i.pinimg.com/originals/57/e2/09/57e209296e586933febadf06e271a3d3.gif"
      },
      {
        "bloc": 10,
        "color": Colors.yellow,
        "instruction": "AD: Je pose mon pied droit sur le jaune en dansant  ",
        "highlight": [10],
        "image":
            "https://i.pinimg.com/originals/57/e2/09/57e209296e586933febadf06e271a3d3.gif"
      },
      {
        "bloc": 11,
        "color": Colors.red,
        "instruction":
            "PA: Je pose mon 2e pied sur la couleur à  côté et je danse en balançant les bras.",
        "highlight": [11],
        "image":
            "https://www.icegif.com/wp-content/uploads/2022/01/icegif-1456.gif"
      },
      {
        "bloc": 12,
        "color": Colors.yellow,
        "instruction":
            "AD: Je pose mon 2e pied sur la couleur à  côté et je danse en balançant les bras",
        "highlight": [12],
        "image":
            "https://i.pinimg.com/originals/57/e2/09/57e209296e586933febadf06e271a3d3.gif"
      },
      {
        "bloc": 13,
        "color": Colors.red,
        "instruction":
            "PA: J'avance sur la couleur de mon 2e pied et je tapotte mes cuisses en dansant.   ",
        "highlight": [13],
        "image":
            "https://i.pinimg.com/originals/57/e2/09/57e209296e586933febadf06e271a3d3.gif"
      },
      {
        "bloc": 14,
        "color": Colors.yellow,
        "instruction":
            "AD: J'avance sur la couleur de mon 2e pied et je tapotte mes cuisses en dansant.   ",
        "highlight": [14],
        "image":
            "https://i.pinimg.com/originals/57/e2/09/57e209296e586933febadf06e271a3d3.gif"
      },
      {
        "bloc": 15,
        "color": Colors.red,
        "instruction":
            "PA: J'avance sur la couleur qui était à côté de ma jambe droite et je tourne sur moi en balançant mes bras. ",
        "highlight": [15],
        "image":
            "https://i.pinimg.com/originals/57/e2/09/57e209296e586933febadf06e271a3d3.gif"
      },
      {
        "bloc": 16,
        "color": Colors.yellow,
        "instruction":
            "AD: J'avance sur la couleur qui était à côté de ma jambe droite et je tourne sur moi en balançant mes bras. ",
        "highlight": [16],
        "image":
            "https://i.pinimg.com/originals/57/e2/09/57e209296e586933febadf06e271a3d3.gif"
      }
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
        String image = instructionIndex < instructions.length
            ? instructions[instructionIndex]["image"]
            : "";

        _instructions.add({
          "bloc": (2 - i) * lineColors.length + j + 1,
          "color": lineColors[j],
          "instruction": instructionText,
          "highlight": highlight,
          "image": image // Ajoutez l'URL de l'image ici
        });

        instructionIndex++;
      }
    }

    print(
        'Instructions générées: $_instructions'); // Débogage : Vérifiez si les instructions sont générées
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
        content: Column(
          children: [
            Text("Le jeu est terminé !"),
          ],
        ),
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
                  SizedBox(
                    height: 50,
                  ),
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(color: Colors.black26),
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
                  child: Icon(
                    Icons.volume_down,
                    color: Colors.lightBlue,
                  ),
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
                  child: Icon(
                    Icons.info,
                    color: Colors.lightBlue,
                  ),
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
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Afficher l'image associée à l'instruction
            if (instruction["image"] != null && instruction["image"].isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Image.network(
                  instruction["image"],
                  height: 50.0, // Ajustez la hauteur de l'image
                  width: 50.0, // Ajustez la largeur de l'image
                  fit: BoxFit.cover, // Ajuste l'image pour couvrir le conteneur
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    }
                  },
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return Center(
                      child: Icon(Icons.error, color: Colors.red, size: 40.0),
                    );
                  },
                ),
              ),
            // Afficher le texte de l'instruction
            Padding(
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
          ],
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
          final isHighlighted =
              _highlightedBlocks.contains(instruction["bloc"]);

          return Container(
            margin: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: instruction["color"],
              borderRadius: BorderRadius.circular(4.0),
              border: isHighlighted
                  ? Border.all(
                      color: Colors.green,
                      width: 4.0) // Bordure rouge pour mise en évidence
                  : null,
            ),
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

  Widget _imageGrid() {
    return ListView.builder(
      itemCount: _instructions.length,
      itemBuilder: (context, index) {
        final instruction = _instructions[index];

        return ListTile(
          leading: Image.network(instruction["image"], width: 50, height: 50),
          // Affichage de l'image
          title: Text(instruction["instruction"]),
        );
      },
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
              _endGame();
              Navigator.pushNamed(context, '/home_page');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Icon(
                Icons.output_sharp,
                color: Colors.white,
              ),
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
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
