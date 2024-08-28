import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:naningana/components/myBytton.dart';
import 'package:naningana/components/myTextField.dart';
import 'package:naningana/helperFunctions.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async{
    showDialog(
      context: context,
      builder: (context) =>const Center(
        child: CircularProgressIndicator(),
      )
    );
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text);
      if(context.mounted) Navigator.pop(context);
    }on FirebaseAuthException catch(e){
      Navigator.pop(context);
      displayMessage(e.code, context);
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person,
              size: 80,
              color: Theme.of(context).colorScheme.inversePrimary,),
              const SizedBox(height: 15,),
              const Text("L O G I N",
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
                  hintText: "your password",
                  obscureText: true,
                  controller: passwordController),
              const SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Forgot password',style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),),
                ],
              ),
              const SizedBox(height: 12,),
              MyButton(
                  onTap: login, text: "login"),
              const SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary
                  ),),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text("  Register here",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
