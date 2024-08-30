import 'package:flutter/material.dart';

void afficherMessageInfo(BuildContext context ,String message, Color? color) {
  var snackBar = SnackBar(
    duration: const Duration(seconds: 5),
    backgroundColor: color,
      content: Text(message,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500
      ),
      textAlign: TextAlign.center,));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}