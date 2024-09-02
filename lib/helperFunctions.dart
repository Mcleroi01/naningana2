import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void displayMessage(String message, BuildContext context){
  showDialog(
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

void handleAuthError(FirebaseAuthException e, BuildContext context) {
  switch (e.code) {
    case 'invalid-email':
      displayMessage("Email invalide", context);
      break;
    case 'user-disabled':
      displayMessage("Utilisateur désactivé", context);
      break;
    case 'user-not-found':
      displayMessage('Utilisateur non trouvé', context);
      break;
    case 'wrong-password':
      displayMessage('Mot de passe incorrect', context);
      break;
    case 'email-already-in-use':
      displayMessage('Email déjà utilisé', context);
      break;
    default:
      displayMessage("Erreur d'authentification : ${e.message}", context);
  }
}