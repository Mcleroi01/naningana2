import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naningana/intro/homePage.dart';
import 'package:naningana/pages/FicheDeSuivi.dart';
import 'package:naningana/pages/auth/loginOrRegister.dart';
import 'package:naningana/services/firestoreService.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}


class _AuthPageState extends State<AuthPage> {
  bool? m;


  @override
  Widget build(BuildContext context) {
    FirestoreService fire = FirestoreService();
    //var myStore = fire.readData();
    var myva = fire.checkValue();
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){

          if(snapshot.hasData)
          {return FicheDeSuivi();}
          // else if(fire.readData() != null){
          //   return HomePage();
          // }
       //    else if(myStore != null){
       //     return const HomePage();
       // }
          else if(myva == true){
            return const HomePage();
          }
          else{
            return const LoginOrRegister();
          }
        }
      ),
    );
  }
}
