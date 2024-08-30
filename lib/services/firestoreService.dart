import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

class FirestoreService {
  final fire = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;
  GetStorage? storage;
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
        {"${currentUser!.email}":data}
      );
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
  // Future<String?>getEmailField() async {
  //   String v = "";
  //     final data = await fire.collection('usersFiches').get();
  //     for (int i=0; i<= data.size; i++) {
  //       if(data.docs[i]["email"] == currentUser?.email ){
  //         v = "${data.docs[i]["email"]}";
  //       }
  //       else{
  //         return null;
  //       }
  //
  //     }
  //     return v;
  //   }

  Future<Map<String, dynamic>> readData() async{
    var data = await storage!.read("PASSENGER");
    return data;
    print("_____________________________________________${data}");
  }

  // Future<String>getDocumentField(String fieldName) async {
  //     if(fieldName == currentUser!.email){
  //       return true;
  //     }
  //   return false;
  // }
 }