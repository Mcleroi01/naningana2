import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Na ningana"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: Text("Commençons"),
          )
        ],
      ),
    );
  }
}
