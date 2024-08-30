import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final fire = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  create(String? email, String name, String guideName, String guidePhone){
    try{
      fire.collection("users").add({
        'email': email,
        'name' : name,
        'guideName' : guideName,
        'guidePhone' : guidePhone,
        'timestamp' : Timestamp.now(),
      });
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
  createFiche(Map<String, dynamic> data){
    try{

      fire.collection("usersFiches").add(
        {"$user":data}
      );
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
  // Future<bool> documentExists() async {
    Future<void> getDocumentIds() async {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('usersFiches').get();

      for (var doc in querySnapshot.docs) {
        print('Document ID: ${doc.id}');
        // Accède aux données du document si nécessaire
        print('Données: ${doc.data()}');
      }
    }

  //   DocumentSnapshot snapshot = await FirebaseFirestore.instance
  //       .collection('usersFiches')
  //       .doc()
  //       .get();
  //
//   return true;
//   }
 }