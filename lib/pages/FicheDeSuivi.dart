import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naningana/components/afficherMessageInfo.dart';
import 'package:naningana/services/firestoreService.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FicheDeSuivi(),
    );
  }
}

class FicheDeSuivi extends StatefulWidget {
  @override
  _FicheDeSuiviState createState() => _FicheDeSuiviState();
}

class _FicheDeSuiviState extends State<FicheDeSuivi> {
  final Map<String, String?> _answers = {};
  int _currentQuestionIndex = 0;
  int _currentCategoryIndex = 0;
  bool isValidateVisible = false;
  bool isButtonVisible = true;
  FirestoreService fire = FirestoreService();

  final List<Map<String, dynamic>> questions = [
    {
      "label": "Santé physique",
      "questions": [
        {
          "question": "La personne âgée se déplace-t-elle ?",
          "assertions": ["Oui", "Non", "Avec soutien"],
        },
        {
          "question": "Il y a-t-il la coordination dans ses gestes ?",
          "assertions": ["Oui", "Non"],
        },
        {
          "question": "A-t-elle des vertiges en position debout ?",
          "assertions": ["Oui", "Non"],
        },
        {
          "question": "Fait-elle de l'insomnie ?",
          "assertions": ["Oui", "Non"],
        },
        {
          "question": "Est-elle forte ?",
          "assertions": ["Oui", "Non"],
        },
        {
          "question": "A-t-elle des douleurs connues permanentes ?",
          "assertions": ["Oui", "Non"],
        },
      ],
    },
    {
      "label": "Santé cognitive",
      "questions": [
        {
          "question": "Comment est l'état de sa mémoire ?",
          "assertions": ["bon", "moyen", "pas du tout"],
        },
        {
          "question": "Quant elle fait quelque chose, est-elle concentrée ?",
          "assertions": ["Oui", "Non"],
        },
        {
          "question": "Reconnaît-elle des couleurs facilement ?",
          "assertions": ["bon", "moyen", "pas du tout"],
        },
        {
          "question": "Est-elle confuse ?",
          "assertions": ["Oui", "Non"],
        },
        {
          "question": "Est-elle capable de suivre les instructions ?",
          "assertions": ["bon", "moyen", "pas du tout"],
        },
        {
          "question": "Est-elle motivée face au jeu ?",
          "assertions": ["Oui", "Non"],
        },
        {
          "question": "S'engage-t-elle à poursuivre le jeu ?",
          "assertions": ["Oui", "Non"],
        },
      ],
    },
    {
      "label": "Santé sociale",
      "questions": [
        {
          "question": "Elle vit seule ou entourée ?",
          "assertions": ["Oui", "Non"],
        },
        {
          "question": "Communique-t-elle?",
          "assertions": ["Oui", "Non"],
        },
        {
          "question": "Comment est l'état de son humeur ?",
          "assertions": ["Nerveuse", "Joyeuse"],
        },
        {
          "question": "Comment se présente son bien-être ?",
          "assertions": ["bon", "moyen", "pas du tout"],
        },
      ],
    },
  ];

  final Duration initialDelay = Duration(seconds: 1);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _nextQuestion() {
    var currentQuestion = _getCurrentQuestions()[_currentQuestionIndex];

    if (_answers[currentQuestion['question']] == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Réponse requise",
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            content: const Text(
              "Veuillez répondre à la question avant de continuer.",
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      if (_currentQuestionIndex < _getCurrentQuestions().length - 1) {
        setState(() {
          _currentQuestionIndex++;
        });
      } else if (_currentCategoryIndex < questions.length - 1) {
        setState(() {
          _currentCategoryIndex++;
          _currentQuestionIndex = 0;
        });
      } else {
        setState(() {
          isValidateVisible = true;
          isButtonVisible = false;
        });
      }
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    } else if (_currentCategoryIndex > 0) {
      setState(() {
        _currentCategoryIndex--;
        _currentQuestionIndex =
            _getCurrentQuestions().length - 1;
      });
    }
  }

  List<dynamic> _getCurrentQuestions() {
    return questions[_currentCategoryIndex]['questions'];
  }

  Future<void> _submitAnswers() async {
    try {
      String userId = _auth.currentUser!.uid;
      await _firestore
          .collection('questionnaire')
          .doc(userId)
          .set(_answers);
      afficherMessageInfo(
        context,
        "Réponses enregistrées avec succès !",
        Colors.green,
        Colors.white,
      );
      Navigator.pushNamed(context, '/home_page');
    } catch (e) {
      afficherMessageInfo(
        context,
        "Erreur lors de l'enregistrement des réponses.",
        Colors.red,
        Colors.white,
      );
      print("Erreur: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentCategory = questions[_currentCategoryIndex];
    var currentQuestion = currentCategory['questions'][_currentQuestionIndex];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Center(
                      child: Text(
                        "Veuillez répondre aux",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Center(
                      child: Text(
                        "questions suivantes",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        color: Colors.blue.withOpacity(0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          currentCategory['label'],
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    DelayedDisplay(
                      delay: initialDelay,
                      child: Text(
                        currentQuestion['question'],
                        style: const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 18),
                    ...List<String>.from(currentQuestion['assertions']).map(
                          (assertion) {
                        return DelayedDisplay(
                          delay: initialDelay,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: RadioListTile(
                              title: Text(
                                assertion,
                                style: const TextStyle(color: Colors.black),
                              ),
                              value: assertion,
                              groupValue: _answers[currentQuestion['question']],
                              onChanged: (value) {
                                setState(() {
                                  _answers[currentQuestion['question']] = value;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ).toList(),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Visibility(
                          visible: isButtonVisible,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: _previousQuestion,
                            child: const Text("Retour"),
                          ),
                        ),
                        Visibility(
                          visible: isButtonVisible,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: _nextQuestion,
                            child: const Text("Suivant"),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: isValidateVisible,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                          ),
                          onPressed: _submitAnswers,
                          child: const Text(
                            "Envoyer les résultats",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
