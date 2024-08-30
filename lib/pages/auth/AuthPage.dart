import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naningana/pages/FicheDeSuivi.dart';
import 'package:naningana/pages/auth/loginOrRegister.dart';
import 'package:naningana/services/firestoreService.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    FirestoreService fire = FirestoreService();
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData)
          {return FicheDeSuivi();
          }
          else{
            return const LoginOrRegister();
          }
        }
      ),
    );
  }
}
