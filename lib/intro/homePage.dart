import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naningana/components/afficherMessageInfo.dart';
import 'package:naningana/services/firestoreService.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    FirestoreService fire = FirestoreService();
    var email = fire.getEmail();
    return Scaffold(
      body: Container(
        width: 500,
        decoration:  BoxDecoration(
          color: Colors.black12,
          image: DecorationImage(
            image: AssetImage(
                'assets/images/background.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("email:",
                          style: TextStyle(
                              color: Colors.white
                          ),),
                        Text("${email}",style: TextStyle(
                            color: Colors.white
                        ),),
                        SizedBox(height: 12.0,),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: TextButton(
                              onPressed: (){
                                fire.logout();
                                Navigator.pushNamed(context, '/login_register');
                                afficherMessageInfo(context, "Deconnexion effectuée avec succès", Colors.blue, Colors.black);
                              },
                              child: const Text("se deconnecter",
                                style: TextStyle(
                                    color: Colors.blue
                                ),)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80,),
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/logo.png'))
                ),
              ),

              const Text("Na ningana",
              style: TextStyle(
                fontSize: 50,
                color: Colors.black,
                fontWeight: FontWeight.bold,

              ),),
              const SizedBox(
                height: 18,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {

                        Navigator.pushNamed(context, '/intro_page');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text("Jouer",style: TextStyle(color: Colors.white),)),
                  const SizedBox(width: 20,),
                  ElevatedButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text("Quitter",style: TextStyle(color: Colors.white),)),
                ],

              )
            ],
          ),
        ),
      ),

    );
  }

  _showAlert(BuildContext context){
    showDialog(context: context, builder: (BuildContext context) {
      FirestoreService fire = FirestoreService();
      return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          title: Center(child: Text("Quitter")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Voulez-vous quitter et"),
              Text("mettre fin à la partie ?"),
              SizedBox(height: 15,),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    ),
                    onPressed: (){
                      fire.logout();
                      Navigator.pushNamed(context, '/login_register');
                      afficherMessageInfo(context, "Deconnexion effectuée avec succès", Colors.orangeAccent, Colors.black);
                    },
                    child: Text("Quitter",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),),
                  ),
                  SizedBox(width: 14.0,),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      ),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text("annuler"))
                ],
              ),
            ],
          )
      ); },barrierDismissible: false,);
  }
}
