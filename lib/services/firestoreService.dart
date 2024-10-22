import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GetStorage storage = GetStorage();
  User? currentUser;

  FirestoreService() {
    currentUser = FirebaseAuth.instance.currentUser;
  }

  /// Enregistrement individuel dans la collection 'users'
  Future<void> createUser(Map<String, dynamic> userData, String userId) async {
    try {
      await _db.collection('users').doc(userId).set(userData);
      print("Utilisateur enregistré avec succès !");
    } catch (e) {
      print("Erreur lors de l'enregistrement de l'utilisateur : $e");
      throw Exception("Erreur d'enregistrement : $e"); // Lancer une exception plus spécifique
    }
  }

  create(String? email, String name, String guideName, String guidePhone, Map<String, dynamic>? data){
    try{
      _db.collection("users").add({
        'email': email,
        'name' : name,
        'guideName' : guideName,
        'guidePhone' : guidePhone,
        'questionnaire' : data,
        'timestamp' : Timestamp.now(),
      });
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  /// Enregistrement d'un groupe communautaire dans la collection 'community_groups'
  Future<void> createCommunityGroup(Map<String, dynamic> groupData) async {
    try {
      await _db.collection('community_groups').add(groupData);
      print("Groupe communautaire enregistré avec succès !");
    } catch (e) {
      print("Erreur lors de l'enregistrement du groupe communautaire : $e");
      throw Exception("Erreur d'enregistrement de groupe : $e");
    }
  }

  /// Récupération d'un utilisateur par ID
  Future<DocumentSnapshot> getUserById(String userId) async {
    try {
      return await _db.collection('users').doc(userId).get();
    } catch (e) {
      print("Erreur lors de la récupération de l'utilisateur : $e");
      throw Exception("Erreur de récupération de l'utilisateur : $e");
    }
  }

  /// Mise à jour d'un utilisateur
  Future<void> updateUser(String userId, Map<String, dynamic> updatedData) async {
    try {
      await _db.collection('users').doc(userId).update(updatedData);
      print("Utilisateur mis à jour avec succès !");
    } catch (e) {
      print("Erreur lors de la mise à jour de l'utilisateur : $e");
      throw Exception("Erreur de mise à jour de l'utilisateur : $e");
    }
  }

  /// Suppression d'un utilisateur
  Future<void> deleteUser(String userId) async {
    try {
      await _db.collection('users').doc(userId).delete();
      print("Utilisateur supprimé avec succès !");
    } catch (e) {
      print("Erreur lors de la suppression de l'utilisateur : $e");
      throw Exception("Erreur de suppression de l'utilisateur : $e");
    }
  }

  /// Récupération de tous les groupes communautaires
  Future<QuerySnapshot> getCommunityGroups() async {
    try {
      return await _db.collection('community_groups').get();
    } catch (e) {
      print("Erreur lors de la récupération des groupes communautaires : $e");
      throw Exception("Erreur de récupération des groupes communautaires : $e");
    }
  }

  /// Mise à jour d'un groupe communautaire
  Future<void> updateCommunityGroup(String groupId, Map<String, dynamic> updatedData) async {
    try {
      await _db.collection('community_groups').doc(groupId).update(updatedData);
      print("Groupe communautaire mis à jour avec succès !");
    } catch (e) {
      print("Erreur lors de la mise à jour du groupe communautaire : $e");
      throw Exception("Erreur de mise à jour du groupe communautaire : $e");
    }
  }

  Future<void> saveSurveyAnswers(Map<String, String?> answers) async {
    try {
      await _db.collection('reponses_questionnaire').add({
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'questionnaire': answers,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("Réponses enregistrées avec succès !");
    } catch (e) {
      print("Erreur lors de l'enregistrement des réponses : $e");
    }
  }

  Future<bool> hasAlreadyAnswered(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('questionnaire')
        .where('userId', isEqualTo: userId)
        .get();
    // Vérifie si le document existe déjà
    return snapshot.docs.isNotEmpty;
  }

  /// Suppression d'un groupe communautaire
  Future<void> deleteCommunityGroup(String groupId) async {
    try {
      await _db.collection('community_groups').doc(groupId).delete();
      print("Groupe communautaire supprimé avec succès !");
    } catch (e) {
      print("Erreur lors de la suppression du groupe communautaire : $e");
      throw Exception("Erreur de suppression du groupe communautaire : $e");
    }
  }

  /// Récupération de l'e-mail de l'utilisateur actuel
  String? getEmail() {
    return currentUser?.email;
  }

  /// Création d'une fiche utilisateur
  Future<void> createFiche(Map<String, dynamic> data) async {
    try {
      if (currentUser == null) {
        throw Exception("Utilisateur non authentifié");
      }
      await _db.collection("usersFiches").add({
        "${currentUser!.email}": data,
      });
      print("Fiche créée avec succès !");
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la création de la fiche : ${e.toString()}");
      }
      throw Exception("Erreur lors de la création de la fiche : $e");
    }
  }

  /// Lecture des données depuis GetStorage
  Map<String, dynamic>? readData() {
    var data = storage.read("PASSENGER");
    print("_________________READ____________________________$data");
    return data;
  }

  /// Écriture des données dans GetStorage
  Future<void> writeData(Map<String, dynamic>? data) async {
    await storage.write("PASSENGER", data);
  }

  /// Suppression des données de GetStorage
  Future<void> removeData() async {
    await storage.remove("PASSENGER");
  }

  /// Déconnexion de l'utilisateur
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
