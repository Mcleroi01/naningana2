import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naningana/components/afficherMessageInfo.dart';
import 'package:naningana/components/myBytton.dart';
import 'package:naningana/components/myTextField.dart';
import 'package:naningana/services/firestoreService.dart';
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController guideNameController = TextEditingController();
  final TextEditingController guideNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _isSecret = true;

  void register() async{
    //show loading circle
    showDialog(
        context: context,
        builder: (context)=> const Center(
          child: CircularProgressIndicator(
            color: Colors.orangeAccent,
          ),
        ));
    if(passwordController.text != confirmPasswordController.text){
      Navigator.pop(context);
      displayMessage("Les mots de passe ne correspondent pas", context);
    }else{
      try{
        UserCredential? userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text,);

          fire.writeData({
            'email': userCredential.user!.email,
            'name' : nameController.text,
            'guideName' : guideNameController.text,
            'guidePhone' : guideNumberController.text,
          });

        if(context.mounted) {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/fiche_page');
        }
      }on FirebaseAuthMultiFactorException catch(e){
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
  bool isValidEmail(String email) {
    // Expression régulière pour valider une adresse e-mail
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

// Exemple d'utilisation
  void validateEmail(String email) {
    if (isValidEmail(email)) {
      return null;
    } else {
      afficherMessageInfo(context, "Adresse e-mail invalide.", Colors.redAccent, Colors.white,);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.surface,
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
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(Icons.person,
                            size: 50,
                            color: Colors.white,)

                        ),
                      ),
                      const SizedBox(height: 15,),
                      const Text("Créer un compte",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),),
                      const Text("Veuillez remplir les champs ci-dessous",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20
                        ),),
                      const SizedBox(height: 60,),
                      //email
                      MyTextField(
                        keyboardType: TextInputType.emailAddress,
                          hintText: "email",
                          obscureText: false,
                          controller: emailController),
                      const SizedBox(height: 10,),

                      MyTextField(
                          hintText: "nom complet",
                          obscureText: false,
                          controller: nameController),
                      const SizedBox(height: 10,),

                      MyTextField(
                          hintText: "mot de passe",
                          obscureText: _isSecret,
                          suffixIcon:    InkWell(
                            onTap: ()=>setState(() {
                              _isSecret = !_isSecret;
                            }),
                            child: Icon(_isSecret ? Icons.visibility : Icons.visibility_off),
                          ),
                          controller: passwordController),
                      const SizedBox(height: 12,),

                      MyTextField(
                          hintText: "confirmer mot de passe",
                          obscureText: true,
                          controller: confirmPasswordController),
                      const SizedBox(height: 12,),


                      MyTextField(
                          hintText: "nom de l'accompagnateur",
                          obscureText: false,
                          controller: guideNameController),
                      const SizedBox(height: 10,),

                      MyTextField(
                        keyboardType: TextInputType.phone,
                          hintText: "numéro de l'accompagnateur",
                          obscureText: false,
                          controller: guideNumberController),
                      const SizedBox(height: 25,),

                      MyButton(
                          onTap: (){
                            _submitForm();
                            validateEmail(emailController.text);
                          },
                          text: "Valider"),


                      const SizedBox(height: 25,),


                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Vous avez séjà un compte ?",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.inversePrimary
                            ),),
                          const SizedBox(height: 15.0,),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text("  Cliquez ici",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),),
                          )
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
