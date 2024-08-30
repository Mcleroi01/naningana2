// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text('Form with RadioButtons')),
//         body: MyForm(),
//       ),
//     );
//   }
// }
//
// class MyForm extends StatefulWidget {
//   @override
//   _MyFormState createState() => _MyFormState();
// }
//
// class _MyFormState extends State<MyForm> {
//   // Pour les boutons radio à deux choix
//   String? _selectedOption1;
//
//   // Pour les boutons radio à trois choix
//   String? _selectedOption2;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             // RadioButtons à deux choix
//             Text('Santé physique (2 choix):'),
//             Text("La personne agé se deplace-t-elle ?"),
//             ListTile(
//               title: Text('NON'),
//               leading: Radio(
//                 value: 'A',
//                 groupValue: _selectedOption1,
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedOption1 = value;
//                   });
//                 },
//               ),
//             ),
//             ListTile(
//               title: Text('OUI'),
//               leading: Radio<String>(
//                 value: 'B',
//                 groupValue: _selectedOption1,
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedOption1 = value;
//                   });
//                 },
//               ),
//             ),
//
//             ListTile(
//               title: Text('Avec soutient'),
//               leading: Radio<String>(
//                 value: 'C',
//                 groupValue: _selectedOption1,
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedOption1 = value;
//                   });
//                 },
//               ),
//             ),
//             SizedBox(height: 20),
//
//             // RadioButtons à trois choix
//             Text('Choisissez une option (3 choix):'),
//             ListTile(
//               title: Text('Option 1'),
//               leading: Radio<String>(
//                 value: '1',
//                 groupValue: _selectedOption2,
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedOption2 = value;
//                   });
//                 },
//               ),
//             ),
//             ListTile(
//               title: Text('Option 2'),
//               leading: Radio<String>(
//                 value: '2',
//                 groupValue: _selectedOption2,
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedOption2 = value;
//                   });
//                 },
//               ),
//             ),
//             ListTile(
//               title: Text('Option 3'),
//               leading: Radio(
//                 value: '3',
//                 groupValue: _selectedOption2,
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedOption2 = value;
//                   });
//                 },
//               ),
//             ),
//             SizedBox(height: 20),
//
//             ElevatedButton(
//               onPressed: () {
//                 // Afficher les choix sélectionnés
//                 print('Option sélectionnée (2 choix): $_selectedOption1');
//                 print('Option sélectionnée (3 choix): $_selectedOption2');
//               },
//               child: Text('Soumettre'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
//
// class FicheSuiviPage extends StatefulWidget {
//   const FicheSuiviPage({super.key});
//
//   @override
//   State createState() => _EvaluationPage();
// }
//
// class _EvaluationPage extends State<FicheSuiviPage> {
//
//   void nextPreviousQuestion(int step) {
//     int myindex = step + state.currentIndex;
//     var newIndex = state.currentQuestionIndex + step;
//     if (newIndex >= 0 && newIndex <= state.questions.length) {
//       print("index $newIndex");
//       Question? currentQueestion = state.maQuestion;
//       List<Assertions> currentAssertions = state.assertions;
//
//       if (newIndex < state.questions.length) {
//         currentQueestion = state.questions[newIndex].question;
//         currentAssertions = state.questions[newIndex].assertions;
//       }
//
//     }
//
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // action initiale de la page et appel d'un controleur
//       //var ctrl = ref.read(evaluationCtrlProvider.notifier);
//       //ctrl.getReponses();
//
//       //ctrl.getQuestions2();
//       //ctrl.getQuestions(authCtrl.phaseId);
//
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         leading: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: IconButton(
//             onPressed: (){
//             },
//             icon: Icon(Icons.arrow_back_ios_rounded,
//             ),
//             iconSize: 20,
//             color: Colors.white,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 20.0),
//             child: TextButton(
//               onPressed: (){},
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 3.0),
//                     child: Text("Quitter",
//                       style: TextStyle(
//                         color: Colors.white,
//                       ),),
//                   ),
//                   Icon(Icons.arrow_forward,
//                     color: Colors.white,
//                     size: 16.0,),
//                 ],
//               ),
//             ),
//           ),
//         ],
//         toolbarHeight: 70.0,
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.orange,
//         title: Text(
//           'Fiche de suivie',
//           style: TextStyle(
//               color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//
//             _mainContent(context),
//
//           SizedBox(
//             height: 20,
//           ),
//           //,
//         ],
//       ),
//     );
//   }
//
//
//
//   _mainContent(BuildContext context) {
//
//     return Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(height: 18,),
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Align(
//               alignment: Alignment.center,
//               child: SizedBox(
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Card(
//                       color: Colors.black.withOpacity(0.1),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(3.0)
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child:  Container(),
//
//                       ),
//                     ),
//                     SizedBox(width: 40.0,),
//                     //Text("${state.currentIndex}/${state.questions.length}"),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           SizedBox(
//             height: 40.0,
//           ),
//           Align(
//             alignment: Alignment.center,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(5.0),),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text('Quelle maison me batirez-vous',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           //_separateurOu(),
//           SizedBox(
//             height: 20.0,
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(14.0),
//               child: ListView.builder(
//                   padding: EdgeInsets.all(10.0),
//                   shrinkWrap: true,
//                   itemCount: 4,//state.assertions.length,
//                   itemBuilder: (ctx, index) {
//                     //var myAssertion = state.assertions[index].id;
//                     return Card(
//                       shape: RoundedRectangleBorder(
//                           borderRadius:
//                           BorderRadius.all(Radius.circular(5.0))),
//                       child: RadioListTile(
//                           controlAffinity: ListTileControlAffinity.trailing,
//                           activeColor: Colors.orange,
//                           title:    Text("",//Text("${index + 1}." + " ${state.assertions[index].libelle}",
//                             style: TextStyle(
//                               fontWeight: FontWeight.w400,
//                             ),),
//                           value:   "",//myAssertion,
//                           groupValue: "",//selectedValue,
//                           onChanged: (value) {
//                             //ctrl.selectAnswer(value!);
//                             print("valeur selectionnée $value");
//                           }),
//                     );
//                   }),
//             ),
//           ),
//           _myButton(),
//         ]);
//
//   } // end main content
//
//   _myButton() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(right: 6.0, bottom: 8.0),
//           child: Visibility(
//             //visible: state.backButtonVsible,
//             child: FloatingActionButton.extended(
//               icon: Icon(
//                 Icons.arrow_back,
//                 color: Colors.black,
//               ),
//               backgroundColor: Colors.white,
//               foregroundColor: Colors.black,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(5.0))),
//               onPressed: () {}  ,/////////////////////////////////////////ctrl.nextPreviousQuestion(-1),
//               label: Text('retour',
//                 style: TextStyle(
//                     fontSize: 16
//                 ),),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(left: 6.0, bottom: 8.0),
//           child: Visibility(
//             //visible: state.submitVisible,
//             child: FloatingActionButton.extended(
//               heroTag: "btn1",
//               icon: Icon(
//                 Icons.check_circle_outlined,
//                 color: Colors.white,
//               ),
//               backgroundColor: Colors.orange,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(5.0))),
//
//               onPressed: () {},
//               label: Text('valider les résultats',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),),
//
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(left: 6.0, bottom: 8.0),
//           child: Visibility(
//             //visible: state.nextButtonVisible,
//             child: FloatingActionButton.extended(
//               heroTag: "btn2",
//               icon: Icon(Icons.arrow_forward,
//                 color: Colors.white,),
//               backgroundColor: Colors.orange,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(5.0))),
//               onPressed: (){
//                 //ctrl.nextPreviousQuestion(1);
//               },
//               label: Text('suivant',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),),),
//           ),
//         ),
//       ],
//     );
//   }
//
//
// }


//   final Map<String, Map<String, List<String>>> questions = {
//     "santé physique": {
//       "A-t-elle des douleurs connues permanentes?": ["Oui", "Non"],
//       "La personne âgée se déplace?": ["Oui", "Non", "Avec soutien"],
//       "A-t-elle des vertiges en position debout?": ["bon", "moyen", "pas du tout"],
//       "Est-elle confuse?": ["Oui", "Non"],
//       "Est-elle capable de suivre les instructions?": ["bon", "moyen", "pas du tout"],
//       "Est-elle motivée face au jeu?": ["Oui", "Non"],
//       "S'engage-t-elle à poursuivre le jeu?": ["Oui", "Non"],
//     },
//     "santé cognitive": {
//       "Comment est l'état de sa mémoire?": ["bon", "moyen", "pas du tout"],
//       "Quand elle fait quelque chose, est-elle concentrée?": ["Oui", "Non"],
//       "Reconnaît-elle des couleurs facilement?": ["bon", "moyen", "pas du tout"],
//       "Est-elle confuse?": ["Oui", "Non"],
//       "Est-elle capable de suivre les instructions?": ["bon", "moyen", "pas du tout"],
//       "Est-elle motivée face au jeu?": ["Oui", "Non"],
//       "S'engage-t-elle à poursuivre le jeu?": ["Oui", "Non"],
//     },
//     "santé sociale": {
//       "Elle vit seule ou entourée?": ["Oui", "Non"],
//       "Communique-t-elle?": ["Oui", "Non"],
//       "Comment se présente son bien-être?": ["bon", "moyen", "pas du tout"],
//       "Comment est l'état de son humeur?": ["nerveuse", "joyeuse"],
//     },
//   };
//



// import 'package:flutter/material.dart';
//
// class QuizScreen extends StatefulWidget {
//   @override
//   _QuizScreenState createState() => _QuizScreenState();
// }
//
// class _QuizScreenState extends State<QuizScreen> {
//   final  questions = [
//     {
//       "santé sociale": [
//         {
//           "question": "Elle vit seule ou entourée?",
//           "assertions": ["Oui", "Non"],
//         },
//         {
//           "question": "Comment se présente son bien-être?",
//           "assertions":  ["bon", "moyen", "pas du tout"],
//         },
//         {
//           "question": "Comment est l'état de son humeur?",
//           "assertions": ["Oui", "Non"],
//         },
//       ],
//     },
//
//
//     {
//       "santé medecine": [
//         {
//           "question": "A-t-elle des douleurs connues permanentes?",
//           "assertions": ["Oui", "Non"],
//         },
//         {
//           "question": "S'engage-t-elle à poursuivre le jeu",
//           "assertions": ["Oui", "Non"],
//         },
//         {
//           "question": "Est-elle motivée face au jeu?",
//           "assertions": ["Oui", "Non"],
//         },
//       ],
//     },
//
//
//     {
//       "santé cognitive": [
//         {
//           "question": "Est-elle capable de suivre les instructions?",
//           "assertions": ["Oui", "Non"],
//         },
//         {
//           "question": "A-t-elle des douleurs connues permanentes?",
//           "assertions": ["Oui", "Non"],
//         },
//         {
//           "question": "A-t-elle des vertiges en position debout?",
//           "assertions": ["Oui", "Non"],
//         },
//       ],
//     },
//   ];
//
//   int currentQuestionIndex = 0;
//   int score = 0;
//   int selectedAnswerIndex = -1;
//
//   @override
//   void initState() {
//     super.initState();
//     _resetSelectedAnswer();
//   }
//
//   void _resetSelectedAnswer() {
//     selectedAnswerIndex = -1;
//   }
//
//   _selectAnswer(int index) {
//     setState(() {
//       selectedAnswerIndex = index;
//     });
//   }
//
//   void _submitAnswers() {
//     final currentQuestion = questions[currentQuestionIndex];
//     final correctAnswerIndex = currentQuestion['correctAnswer'];
//
//     if (selectedAnswerIndex == correctAnswerIndex) {
//       setState(() {
//         score++;
//       });
//     }
//
//     setState(() {
//       currentQuestionIndex++;
//       _resetSelectedAnswer();
//     });
//
//     if (currentQuestionIndex == questions.length) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Résultat'),
//           content: Text('Votre score final est de $score sur ${questions.length}'),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 setState(() {
//                   currentQuestionIndex = 0;
//                   score = 0;
//                 });
//               },
//               child: Text('Rejouer'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (currentQuestionIndex >= questions.length) return Container();
//
//     final currentQuestion = questions[currentQuestionIndex];
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Quiz App'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       currentQuestion['text'],
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 16),
//                     ...currentQuestion['answers'].asMap().entries.map((entry) {
//                       final index = entry.key;
//                       final answer = entry.value;
//                       return RadioListTile(
//                         title: Text(answer),
//                         value: index,
//                         groupValue: selectedAnswerIndex,
//                         onChanged: (value){
//                           setState(() {
//                             selectedAnswerIndex = index;
//                           });
//                         },
//                       );
//                     }).toList(),
//                   ],
//                 ),
//               ),
//             ),
//             Spacer(),
//             ElevatedButton(
//               onPressed: _submitAnswers,
//               child: Text('Valider'),
//             ),
//             SizedBox(height: 16),
//             Text('Score: $score'),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
//
// class FicheSuivi extends StatefulWidget {
//   @override
//   _FicheSuiviState createState() => _FicheSuiviState();
// }
//
// class _FicheSuiviState extends State<FicheSuivi> {
//   final Map<String, String?> _answers = {};
//
//   final List<Map<String, dynamic>> questions = [
//     {
//       "santé sociale": [
//         {
//           "question": "Elle vit seule ou entourée?",
//           "assertions": ["Oui", "Non"],
//         },
//         {
//           "question": "Comment se présente son bien-être?",
//           "assertions": ["bon", "moyen", "pas du tout"],
//         },
//         {
//           "question": "Comment est l'état de son humeur?",
//           "assertions": ["Oui", "Non"],
//         },
//       ],
//     },
//     {
//       "santé medecine": [
//         {
//           "question": "A-t-elle des douleurs connues permanentes?",
//           "assertions": ["Oui", "Non"],
//         },
//         {
//           "question": "S'engage-t-elle à poursuivre le jeu?",
//           "assertions": ["Oui", "Non"],
//         },
//         {
//           "question": "Est-elle motivée face au jeu?",
//           "assertions": ["Oui", "Non"],
//         },
//       ],
//     },
//     {
//       "santé cognitive": [
//         {
//           "question": "Est-elle capable de suivre les instructions?",
//           "assertions": ["Oui", "Non"],
//         },
//         {
//           "question": "A-t-elle des douleurs connues permanentes?",
//           "assertions": ["Oui", "Non"],
//         },
//         {
//           "question": "A-t-elle des vertiges en position debout?",
//           "assertions": ["Oui", "Non"],
//         },
//       ],
//     },
//   ];
//
//   void _submitAnswers() {
//     print(_answers); // Vous pouvez traiter les réponses ici
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Fiche de suivi"),
//       centerTitle: true,),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding:  EdgeInsets.all(20.0),
//           child: Column(
//             children: questions.expand((category) {
//               return category.entries.map((entry) {
//                 String categoryName = entry.key;
//                 List<dynamic> categoryQuestions = entry.value;
//
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Center(
//                         child: Text(
//                           categoryName,
//                           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),
//                         ),
//                       ),
//                     ),
//                     ...categoryQuestions.map((q) {
//                       String question = q['question'];
//                       List<String> assertions = List<String>.from(q['assertions']);
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Card(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(question,style: const TextStyle(
//                                 color: Colors.black
//                               ),),
//                             ),
//                           ),
//                           ...assertions.map((assertion) {
//                             return Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: Center(
//                                 child: RadioListTile(
//                                   title: Text(assertion),
//                                   value: assertion,
//                                   groupValue: _answers[question],
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _answers[question] = value;
//                                     });
//                                   },
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ],
//                       );
//                     }).toList(),
//                   ],
//                 );
//               }).toList();
//             }).toList(),
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.blue,
//         onPressed: _submitAnswers,
//         child: Icon(Icons.remove_red_eye_outlined),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';



class QuestionnaireScreen extends StatefulWidget {
  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final Map<String, String?> _answers = {};
  int _currentQuestionIndex = 0;
  int currentIndex = 1;

  final List<Map<String, dynamic>> questions = [
    {
      "data": [
        {
          "label": "santé sociale",
          "question": "Elle vit seule ou entourée?",
          "assertions": ["Oui", "Non"],
        },
        {
          "question": "Comment se présente son bien-être?",
          "assertions": ["bon", "moyen", "pas du tout"],
        },
        {
          "question": "Comment est l'état de son humeur?",
          "assertions": ["Oui", "Non"],
        },
      ],
    },
    {
      "data": [
        {
          "label":"santé medecine",
          "question": "A-t-elle des douleurs connues permanentes?",
          "assertions": ["Oui", "Non"],
        },
        {
          "question": "S'engage-t-elle à poursuivre le jeu?",
          "assertions": ["Oui", "Non"],
        },
        {
          "question": "Est-elle motivée face au jeu?",
          "assertions": ["Oui", "Non"],
        },
      ],
    },
    {
       "data":[

        {"label" : "santé cognitive",
          "question": "Est-elle capable de suivre les instructions?",
          "assertions": ["Oui", "Non"],
        },
        {
          "question": "A-t-elle des douleurs connues permanentes?",
          "assertions": ["Oui", "Non"],
        },
        {
          "question": "A-t-elle des vertiges en position debout?",
          "assertions": ["Oui", "Non"],
        },
      ],
    },
  ];

  void _nextQuestion() {
    if (_currentQuestionIndex < _getCurrentCategoryQuestions().length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // Soumettre les réponses ou naviguer vers une autre page
      print(_answers);
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  List<dynamic> _getCurrentCategoryQuestions() {
    for (var category in questions) {
    }
    return questions.expand((category) => category.values.first).toList();
  }

  @override
  Widget build(BuildContext context) {

    var currentQuestion = _getCurrentCategoryQuestions()[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Fiche de suivi",style: TextStyle(
        color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20
      ),),
      ),
      body: Padding(
        padding:  EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 50,),
              Text(
                "${_currentQuestionIndex + 1}. ${currentQuestion['question']}",
                style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
              ...List<String>.from(currentQuestion['assertions']).map((assertion) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RadioListTile(
                      title: Text(assertion, style: const TextStyle(color: Colors.black),),
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
              }).toList(),

              const SizedBox(height: 50,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    ),
                    onPressed: _previousQuestion,
                    child: const Text("retour"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    ),
                    onPressed: _nextQuestion,
                    child: const Text("Suivant"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}