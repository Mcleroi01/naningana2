import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naningana/components/myDrawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Na ningana"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Commençons"),
            const SizedBox(height: 18,),
            ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/intro_page');
                },
                child: const Text("Get started"))
          ],
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}
