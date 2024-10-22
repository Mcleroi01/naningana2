import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:naningana/intro/homePage.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _formKey = GlobalKey<FormState>();
  String? _orderDetails;
  String? _typeTapis; // Champ pour le type de tapis
  String? _tailleTapis; // Champ pour la taille de tapis
  int? _quantite; // Champ pour la quantité
  bool _isSending = false;

  // Constants
  final String firstRecipientEmail = 'noellakabuya@yahoo.ca';
  final String secondRecipientEmail = 'villagebopemi@gmail.com';
  final String apiUrl = 'http://127.0.0.1:5001/game-project-55bad/us-central1/sendEmail';

  // Fonction pour envoyer le mail de commande
  Future<void> sendOrderEmail() async {
    setState(() {
      _isSending = true; // Démarre le processus d'envoi
    });

    // Récupération de l'utilisateur connecté
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Aucun utilisateur connecté.')),
      );
      setState(() {
        _isSending = false; // Arrête le processus d'envoi
      });
      return;
    }

    String userName = 'client Naningana'; // Remplacez 'name' par le nom de votre champ dans Firestore

    // Préparer les détails de la commande
    final String orderDetails = '''
    Détails de la commande :
    
    - Type de tapis : $_typeTapis
    - Taille du tapis : $_tailleTapis
    - Quantité : $_quantite
    - Instructions supplémentaires : $_orderDetails
    ''';

    // Envoyer l'e-mail au premier destinataire
    final response1 = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'from': user.email!,
        'to': firstRecipientEmail,
        'subject': 'Nouvelle commande de ${user.email} client Naningana',

        'text': orderDetails,
      }),
    );

    if (response1.statusCode == 200) {
      // Si l'envoi au premier destinataire est réussi, envoyer au second
      final response2 = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'from': user.email!,
          'to': secondRecipientEmail,
          'subject': 'Nouvelle commande du $userName',
          'text': orderDetails,
        }),
      );

      if (response2.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Commande envoyée avec succès aux deux destinataires !')),
        );

        // Clear the form fields after successful submission
        _formKey.currentState!.reset();

        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec de l\'envoi de la commande au deuxième destinataire.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de l\'envoi de la commande au premier destinataire.')),
      );
    }

    setState(() {
      _isSending = false; // Arrête le processus d'envoi
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Passer une commande de tapis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Formulaire de commande de tapis',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Veuillez remplir les détails ci-dessous pour passer votre commande.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              TextFormField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Décrivez ce que vous souhaitez commander',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer les détails de la commande';
                  }
                  return null;
                },
                onSaved: (value) {
                  _orderDetails = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Type de tapis (ex: Tapis en mousse)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le type de tapis';
                  }
                  return null;
                },
                onSaved: (value) {
                  _typeTapis = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Taille du tapis (ex: 1m x 2m)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la taille du tapis';
                  }
                  return null;
                },
                onSaved: (value) {
                  _tailleTapis = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Quantité (nombre de tapis)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la quantité';
                  }
                  final int? quantity = int.tryParse(value);
                  if (quantity == null || quantity <= 0) {
                    return 'Veuillez entrer un nombre entier positif';
                  }
                  return null;
                },
                onSaved: (value) {
                  _quantite = int.tryParse(value!);
                },
              ),
              SizedBox(height: 20),
              Center(
                child: _isSending
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _isSending
                      ? null
                      : () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      sendOrderEmail();
                    }
                  },
                  child: Text('Envoyer la commande'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}