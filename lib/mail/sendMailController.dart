import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:firebase_auth/firebase_auth.dart';

sendEmail(BuildContext context) async {
  // Obtenir l'utilisateur connecté via Firebase
  User? user = FirebaseAuth.instance.currentUser;

  // Vérifier si l'utilisateur est connecté
  if (user == null) {
    // Si non connecté, afficher une erreur
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Utilisateur non connecté")));
    return;
  }

  String connectedUserEmail = user.email!; // Email de l'utilisateur connecté

  // Paramètres SMTP pour Gmail
  String username = 'abc@gmail.com'; // Votre email d'envoi principal
  String password = '****************'; // Mot de passe de l'application (16 chiffres)

  final smtpServer = gmail(username, password);

  // Liste des destinataires
  final List<String> recipients = [
    'firstrecipient@example.com',
    'secondrecipient@example.com'
  ];

  // Créez le message
  final message = Message()
    ..from = Address(connectedUserEmail, 'Utilisateur Connecté') // Utiliser l'email de l'utilisateur
    ..recipients.addAll(recipients) // Ajouter les destinataires
    ..subject = 'Demande de service/commande de la part de $connectedUserEmail'
    ..text = 'Bonjour,\n\nJe souhaiterais passer une commande ou demander un service.'
  ;

  try {
    // Envoyer le message
    final sendReport = await send(message, smtpServer);
    print('Message envoyé: ' + sendReport.toString());

    // Afficher une notification de succès
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Mail envoyé avec succès")));
  } on MailerException catch (e) {
    print('Message non envoyé. Erreur: ${e.message}');
    for (var p in e.problems) {
      print('Problème: ${p.code}: ${p.msg}');
    }

    // Afficher une notification d'erreur
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Échec de l'envoi du mail")));
  }
}
