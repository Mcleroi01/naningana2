import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naningana/components/myTextField.dart';
import 'package:naningana/services/firestoreService.dart';
import '../components/myBytton.dart';
import '../helperFunctions.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _myFormKey = GlobalKey<FormState>();
  final fire = FirestoreService();

  // Controllers pour les utilisateurs individuels
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController guideNameController = TextEditingController();
  final TextEditingController guidePhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Controllers pour les groupes communautaires
  final TextEditingController communityGroupNameController = TextEditingController();
  List<TextEditingController> communityNameControllers = [];
  List<TextEditingController> communityguideNameControllers = [];
  List<TextEditingController> communityguidePhoneControllers = [];
  List<TextEditingController> communityEmailControllers = [];
  List<TextEditingController> communityPasswordControllers = [];
  List<TextEditingController> communityConfirmPasswordControllers = [];
  int communityUserCount = 1;

  bool _isSecret = true;
  String? _registrationType = "individuel";

  // Validation du formulaire
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un email valide';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un nom valide';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  Future<void> register() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.orangeAccent),
      ),
    );

    try {
      if (_registrationType == "individuel") {
        // Vérification des mots de passe
        if (passwordController.text != confirmPasswordController.text) {
          if (mounted) {
            Navigator.pop(context);
            displayMessage("Les mots de passe ne correspondent pas", context);
          }
          return;
        }

        // Création de l'utilisateur individuel
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        String userId = userCredential.user!.uid;

        // Enregistrement de l'utilisateur dans Firestore
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'email': emailController.text,
          'name': nameController.text,
          'guideName': guideNameController.text,
          'guidePhone': guidePhoneController.text,
          'timestamp': DateTime.now(),
        });


        // Redirection vers la page de la fiche médicale pour les utilisateurs individuels
        if (mounted) {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/fiche_page'); // Redirection vers la fiche médicale
        }

      } else if (_registrationType == "communautaire") {
        // Création de plusieurs utilisateurs pour un groupe communautaire
        List<String> userIds = []; // Liste pour stocker les IDs des utilisateurs

        for (int i = 0; i < communityUserCount; i++) {
          // Vérification si les mots de passe correspondent
          if (communityPasswordControllers[i].text != communityConfirmPasswordControllers[i].text) {
            if (mounted) {
              Navigator.pop(context);
              displayMessage("Les mots de passe de l'utilisateur ${i + 1} ne correspondent pas", context);
            }
            return;
          }

          // Création de l'utilisateur pour chaque membre de la communauté
          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: communityEmailControllers[i].text,
            password: communityPasswordControllers[i].text,
          );

          String userId = userCredential.user!.uid;
          userIds.add(userId); // Ajout de l'ID de l'utilisateur à la liste

          // Enregistrement de l'utilisateur dans Firestore
          await FirebaseFirestore.instance.collection('users').doc(userId).set({
            'email': communityEmailControllers[i].text,
            'name': communityNameControllers[i].text,
            'guideName': communityguideNameControllers[i].text,
            'guidePhone': communityguidePhoneControllers[i].text,
            'timestamp': DateTime.now(),
          });
        }

        // Enregistrement du groupe communautaire dans Firestore
        String groupId = await FirebaseFirestore.instance.collection('community_groups').add({
          'groupName': communityGroupNameController.text,
          'timestamp': DateTime.now(),
          'userId': userIds, // ID des utilisateurs du groupe
          //'creatorId': FirebaseAuth.instance.currentUser!.uid, // ID de l'utilisateur qui crée le groupe
        }).then((docRef) => docRef.id);

        // Redirection vers la page de connexion pour les inscriptions communautaires
        if (mounted) {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/login'); // Redirection vers la page de connexion
        }
      }

    } on FirebaseAuthException catch (e) {
      if (mounted) {
        Navigator.pop(context);
        handleAuthError(e, context);
      }
    }
  }



  void _submitForm() {
    if (_myFormKey.currentState!.validate()) {
      register();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              color: Colors.grey.withOpacity(0.1),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 23, horizontal: 20),
                child: Form(
                  key: _myFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Type d'enregistrement",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      DropdownButtonFormField<String>(
                        value: _registrationType,
                        items: [
                          DropdownMenuItem(value: "individuel", child: Text("Individuel")),
                          DropdownMenuItem(value: "communautaire", child: Text("Communautaire")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _registrationType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 15),

                      // Formulaire pour l'enregistrement individuel
                      if (_registrationType == "individuel") ...[
                        SizedBox(height: 20),
                        MyTextField(
                          keyboardType: TextInputType.emailAddress,
                          hintText: "Email",
                          controller: emailController,
                          obscureText: false,

                        ),
                        SizedBox(height: 20),
                        MyTextField(
                          hintText: "Nom complet",
                          controller: nameController,
                          obscureText: false,

                        ),
                        SizedBox(height: 20),
                        MyTextField(
                          hintText: "Nom de la personne qui accompagne",
                          controller: guideNameController,
                          obscureText: false,

                        ),
                        SizedBox(height: 20),

                        MyTextField(
                          hintText: "Numero de l'accompagnateur",
                          controller: guidePhoneController,
                          obscureText: false,

                        ),
                        SizedBox(height: 20),
                        MyTextField(
                          hintText: "Mot de passe",
                          obscureText: _isSecret,
                          suffixIcon: InkWell(
                            onTap: () => setState(() => _isSecret = !_isSecret),
                            child: Icon(_isSecret ? Icons.visibility : Icons.visibility_off),
                          ),
                          controller: passwordController,

                        ),
                        SizedBox(height: 20),
                        MyTextField(
                          hintText: "Confirmer mot de passe",
                          obscureText: true,
                          controller: confirmPasswordController,

                        ),
                      ],

                      // Formulaire pour l'enregistrement communautaire
                      if (_registrationType == "communautaire") ...[
                        MyTextField(
                          hintText: "Nom du groupe communautaire",
                          controller: communityGroupNameController,
                          obscureText: false,

                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: communityUserCount,
                          itemBuilder: (context, index) {
                            if (communityNameControllers.length < communityUserCount) {
                              communityNameControllers.add(TextEditingController());
                              communityEmailControllers.add(TextEditingController());
                              communityPasswordControllers.add(TextEditingController());
                              communityConfirmPasswordControllers.add(TextEditingController());
                              communityguidePhoneControllers.add(TextEditingController());
                              communityguideNameControllers.add(TextEditingController());
                            }
                            return Column(
                              children: [
                                SizedBox(height: 20),
                                MyTextField(
                                  hintText: "Nom complet de l'utilisateur ${index + 1}",
                                  controller: communityNameControllers[index],
                                  obscureText: false,

                                ),
                                SizedBox(height: 20),
                                MyTextField(
                                  keyboardType: TextInputType.emailAddress,
                                  hintText: "Email de l'utilisateur ${index + 1}",
                                  controller: communityEmailControllers[index],
                                  obscureText: false,

                                ),
                                SizedBox(height: 20),
                                MyTextField(
                                  hintText: "Nom de la personne qui accompagne ${index + 1}",
                                  controller: communityguideNameControllers[index],
                                  obscureText: false,

                                ),
                                SizedBox(height: 20),

                                MyTextField(
                                  hintText: "Numero de l'accompagnateur ${index + 1}",
                                  controller: communityguidePhoneControllers[index],
                                  obscureText: false,

                                ),
                                SizedBox(height: 20),
                                MyTextField(
                                  hintText: "Mot de passe de l'utilisateur ${index + 1}",
                                  obscureText: _isSecret,
                                  suffixIcon: InkWell(
                                    onTap: () => setState(() => _isSecret = !_isSecret),
                                    child: Icon(_isSecret ? Icons.visibility : Icons.visibility_off),
                                  ),
                                  controller: communityPasswordControllers[index],

                                ),
                                SizedBox(height: 20),
                                MyTextField(
                                  hintText: "Confirmer mot de passe de l'utilisateur ${index + 1}",
                                  obscureText: true,
                                  controller: communityConfirmPasswordControllers[index],

                                ),

                                SizedBox(height: 20),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 10),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              communityUserCount++;
                            });
                          },
                          icon: Icon(Icons.add),
                          label: Text("Ajouter un membre"),
                        ),
                      ],

                      const SizedBox(height: 20),
                      MyButton(text: "S'inscrire", onTap: _submitForm),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Déjà un compte ?"),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              'Connectez-vous maintenant',
                              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
