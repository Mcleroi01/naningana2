import 'package:flutter/material.dart';

void displayMessage(String message, BuildContext context){
  showDialog(
    barrierDismissible: true,
      context: context,
      builder: (context)=>Container(
        color: Colors.red.withOpacity(0.1),
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          title: Center(child: Text(message,
          style: const TextStyle(
            color: Colors.black
          ),)),
        ),
      ),
      );
}