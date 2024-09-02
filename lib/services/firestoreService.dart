import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

class FirestoreService {
  GetStorage storage = GetStorage();
  final fire = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;
  create(String? email, String name, String guideName, String guidePhone){
    try{
      fire.collection("users").add({
        'email': email,
        'name' : name,
        'guideName' : guideName,
        'guidePhone' : guidePhone,
        'isVerified' : false,
        'timestamp' : Timestamp.now(),
      });
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  updateField()async{
    try{
      DocumentReference docRef = fire.collection('users').doc(currentUser!.email);
      await docRef.update({'isVerified' : true,});
    }catch(e){
      print('Erreur de lis à jour ${e.toString()}');
    }
  }

  checkValue() async{
    try{
      DocumentReference docRef = fire.collection('users').doc(currentUser!.email);
      DocumentSnapshot docSnap= await docRef.get();
      if(docSnap.exists){
        var field = docSnap.get('isVerified');
        if(field == true){
          return true;
        }
      }
    }catch(e){
     print("Le document n'éxiste pas") ;
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

  Future<Map<String, dynamic>>? readData() async{
    var data = await storage.read("PASSENGER");
    print("_________________READ____________________________${data}");
    return data;
  }

  void writeData(String data) async{
    await storage.write("PASSENGER",{"user":data});
    print("___________________WRITE__________________________${data}");
  }
  // Future<String>getDocumentField(String fieldName) async {
  //     if(fieldName == currentUser!.email){
  //       return true;
  //     }
  //   return false;
  // }
 }