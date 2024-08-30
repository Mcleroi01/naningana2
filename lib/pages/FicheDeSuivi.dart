import 'package:flutter/material.dart';
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
          "question": "A-t-elle des douleurs connues permanentes  ?",
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
          "question": "Quant elle fait quelque chose,est-elle concentrée ?",
          "assertions": ["Oui", "Non"],
        },
        {
          "question": "Reconnaît-elle des couleurs facilement ?",
          "assertions": ["bon", "moyen", "pas du tout"],
        },
        {
          "question": " Est-elle confuse ?",
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
          "assertions": ["Neurveuse", "Joyeuse"],
        },
        {
          "question": "Comment se présente son bien-être ?",
          "assertions":["bon", "moyen", "pas du tout"],
        },
      ],
    },
  ];

  void _nextQuestion() {
    if (_currentQuestionIndex < _getCurrentQuestions().length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else if (_currentCategoryIndex < questions.length - 1) {
      setState(() {
        _currentCategoryIndex++;
        _currentQuestionIndex = 0; // Réinitialiser à la première question de la nouvelle catégorie
      });
    } else {
      // Soumettre les réponses ou naviguer vers une autre page
      setState(() {
        isValidateVisible = true;
      });
      print("Mes choix____________________________________ $_answers");
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
        _currentQuestionIndex = _getCurrentQuestions().length - 1; // Aller à la dernière question de la catégorie précédente
      });
    }
  }

  List<dynamic> _getCurrentQuestions() {
    return questions[_currentCategoryIndex]['questions'];
  }

  @override
  Widget build(BuildContext context) {
    var currentCategory = questions[_currentCategoryIndex];
    var currentQuestion = currentCategory['questions'][_currentQuestionIndex];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        const Center(
                          child: Text("Veuillez remplir",
                            style: TextStyle(
                                color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold
                            ),),
                        ),
                        const Center(
                          child: Text("le fiche de suivi ci-dessous",
                            style: TextStyle(
                                color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold
                            ),),
                        ),
                        const SizedBox(height: 50,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    color: Colors.blue
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    color: Colors.green
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    color: Colors.orangeAccent
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50,),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            color: Colors.blue.withOpacity(0.1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              currentCategory['label'],
                              style: const TextStyle(fontSize: 18,
                                  fontWeight: FontWeight.bold,color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          currentQuestion['question'],
                          style: const TextStyle(fontSize: 18,color: Colors.black),
                        ),
                        const SizedBox(height: 18),
                        ...List<String>.from(currentQuestion['assertions']).map((assertion) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: RadioListTile(
                              title: Text(assertion,
                                style: const TextStyle(
                                    color: Colors.black
                                ),),
                              value: assertion,
                              groupValue: _answers[currentQuestion['question']],
                              onChanged: (value) {
                                setState(() {
                                  _answers[currentQuestion['question']] = value;
                                });
                              },
                            ),
                          );
                        }).toList(),

                        const SizedBox(height: 50,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Visibility(
                              visible: isButtonVisible,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orangeAccent,
                                  foregroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                ),
                                onPressed: _previousQuestion,
                                child: const Text("Retour",
                                    style: TextStyle(
                                        fontSize: 16
                                    )),
                              ),
                            ),
                            Visibility(
                              visible: isButtonVisible,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                ),
                                onPressed: _nextQuestion,
                                child: const Text("Suivant",style: TextStyle(
                                    fontSize: 16
                                ),),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15,),
                        SizedBox(
                          width: double.infinity,
                          child: Visibility(
                            visible: isValidateVisible,
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                ),
                                onPressed: (){
                                  fire.createFiche(_answers);
                                  Navigator.pushNamed(context, '/intro_page');
                                  fire.getDocumentIds();
                                },
                                child: const Text("Envoyer les résultats",style: TextStyle(
                                    fontSize: 16
                                ),),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}