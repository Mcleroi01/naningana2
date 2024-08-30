import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  void Function()? onTap;
  String text;

  MyButton({super.key,
  required this.onTap,
  required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(text,style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white
          ),),
        ),
      ),
    );
  }
}
