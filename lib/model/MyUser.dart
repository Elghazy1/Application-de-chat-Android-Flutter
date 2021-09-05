import 'package:firebase_database/firebase_database.dart';

class MyUser {
  String? uid;
  String? prenom;
  String? nom;
  String? imageUrl;
  String? initiales;

  MyUser(DataSnapshot snapshot) {
    uid = snapshot.key;
    Map map = snapshot.value;
    prenom = map["prenom"];
    nom = map["nom"];
    imageUrl = map["imageUrl"];
    if (prenom!.length > 0) {
      initiales = prenom![0];
    }
    if (nom!.length > 0) {
      //if (initiales != null)
      initiales = initiales! + nom![0];
    }
  }
  Map toMap() {
    return {"prenom": prenom, "nom": nom, "imageUrl": imageUrl, "uid": uid};
  }
}
