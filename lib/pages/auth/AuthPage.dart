import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naningana/intro/homePage.dart';
import 'package:naningana/pages/FicheDeSuivi.dart';
import 'package:naningana/pages/auth/loginOrRegister.dart';
import 'package:naningana/services/firestoreService.dart';

import '../../user/userProfile.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}


class _AuthPageState extends State<AuthPage> {
  FirestoreService fire = FirestoreService();

  Map<String, dynamic>? mys;


  @override
  Widget build(BuildContext context) {
    FirestoreService fire = FirestoreService();
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {

            if(snapshot.hasData)
            {return UserProfile();}
            else{
              return const LoginOrRegister();
            }
          }
      ),
    );
  }
}
