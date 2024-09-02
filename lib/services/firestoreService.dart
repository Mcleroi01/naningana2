import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

class FirestoreService {
  GetStorage storage = GetStorage();
  final fire = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;
  create(String? email, String name, String guideName, String guidePhone, Map<String, dynamic>? data){
    try{
      fire.collection("users").add({
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


  Stream<QuerySnapshot> getUser(){
    final noteStream = fire.collection("users");
    final str = noteStream.orderBy("timestamp",descending: true).snapshots();
    return str;
  }

  createFiche(Map<String, dynamic> data){
    try{

      fire.collection("usersFiches").add(
        {"${currentUser!.email}":data}
      );
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Map<String, dynamic>? readData(){
    var data =  storage.read("PASSENGER");
    print("_________________READ____________________________${data}");
    return data;
  }

  void writeData(Map<String, dynamic>? data) async{
    await storage.write("PASSENGER",data);
  }

  void removeData() async{
    await storage.remove("PASSENGER");
  }
 }