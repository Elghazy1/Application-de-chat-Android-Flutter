import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class FirebaseHelper {
  //Authentification
  final auth = FirebaseAuth.instance;

  Future<User> handleSigneIn(String mail, String mdp) async {
    final User user =
        (await auth.signInWithEmailAndPassword(email: mail, password: mdp))
            .user!;
    return user;
  }

  Future<User> create(
      String mail, String mdp, String prenom, String nom) async {
    final create =
        await auth.createUserWithEmailAndPassword(email: mail, password: mdp);
    final User user = create.user!;
    String uid = user.uid;
    Map<String, String> map = {"prenom": prenom, "nom": nom, "uid": uid};
    addUser(uid, map);
    return user; //
  }

  //Database
  static final entryPoint = FirebaseDatabase.instance.reference();
  final entry_user = entryPoint.child("users");

  addUser(String uid, Map map) {
    entry_user.child(uid).set(map);
  }
}
