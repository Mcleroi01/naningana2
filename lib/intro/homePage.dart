import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naningana/services/firestoreService.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    FirestoreService fire = FirestoreService();
    return Scaffold(
      body: Container(
        width: 500,
        decoration: const BoxDecoration(
          color: Colors.black12,
          image: DecorationImage(
            image: NetworkImage(
                'https://www.shutterstock.com/image-vector/blue-spiral-background-vector-illustration-600nw-2473473495.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: TextButton(
                onPressed: (){
                  fire.logout();
                        },
                child: Text("se deconnecter",
                style: TextStyle(
                  color: Colors.white
                ),)),
              ),
              SizedBox(height: 80,),
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/logo.png'))
                ),
              ),
              const Text("Naningana",
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
                      child: Text("Quittez",style: TextStyle(color: Colors.white),)),
                ],

              )
            ],
          ),
        ),
      ),

    );
  }
}
