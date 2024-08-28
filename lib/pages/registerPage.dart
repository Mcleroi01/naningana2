import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naningana/components/myBytton.dart';
import 'package:naningana/components/myTextField.dart';

import '../helperFunctions.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void register() async{
    //show loading circle
    showDialog(
        context: context,
        builder: (context)=> const Center(
          child: CircularProgressIndicator(),
        ));
    if(passwordController.text != confirmPasswordController.text){
      Navigator.pop(context);
      displayMessage("Passwords don't match", context);
    }else{
      try{
        UserCredential? userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text,);

        //create user and add to database
        createUserDocument(userCredential);

        if(context.mounted) Navigator.pop(context);
      }on FirebaseAuthException catch(e){
        Navigator.pop(context);

        displayMessage(e.code, context);
      }
    }
  }


  Future<void>createUserDocument(UserCredential? userCredential)async{
    if(userCredential != null && userCredential.user != null){
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'name' : nameController.text,
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.inversePrimary,),
                const SizedBox(height: 15,),
                const Text("R E G I S T E R",
                  style: TextStyle(
                      fontSize: 20
                  ),),
                const SizedBox(height: 60,),
            
            
                //email
                MyTextField(
                    hintText: "your email",
                    obscureText: false,
                    controller: emailController),
                const SizedBox(height: 10,),
            
                MyTextField(
                    hintText: "your name",
                    obscureText: false,
                    controller: nameController),
                const SizedBox(height: 10,),
            
                MyTextField(
                    hintText: "your password",
                    obscureText: true,
                    controller: passwordController),
                const SizedBox(height: 12,),
            
                MyTextField(
                    hintText: "confirm password",
                    obscureText: true,
                    controller: confirmPasswordController),
                const SizedBox(height: 12,),
            
            
                MyButton(
                    onTap: register,
                    text: "register"),
            
            
                const SizedBox(height: 25,),
            
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary
                      ),),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text("  Login here",
                        style: TextStyle(
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
    );
  }
}
