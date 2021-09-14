import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_1/model/MyUser.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseHelper {
  //Authentification

  final auth = FirebaseAuth.instance;

  Future<User> handleSigneIn(String mail, String mdp) async {
    final UserCredential result =
        (await auth.signInWithEmailAndPassword(email: mail, password: mdp));
    return result.user!;
  }

  Future<bool> handleLogOut() async {
    await auth.signOut();
    return true;
  }

  Future<User> create(
      String mail, String mdp, String prenom, String nom) async {
    final UserCredential result =
        await auth.createUserWithEmailAndPassword(email: mail, password: mdp);
    final User user = result.user!;
    String uid = user.uid;
    Map<String, String> map = {"prenom": prenom, "nom": nom, "uid": uid};
    addUser(uid, map);
    return user; //
  }

  //Database
  static final base = FirebaseDatabase.instance.reference();
  final baseuser = base.child("users");
  final basemessage = base.child("messages");
  final baseconversation = base.child("conversations");

  addUser(String uid, Map map) {
    baseuser.child(uid).set(map);
  }

  Future<MyUser> getUser(String uid) async {
    DataSnapshot snapshot = await baseuser.child(uid).once();
    MyUser user = MyUser(snapshot);
    return user;
  }

  sendMessage(MyUser me, MyUser partenaire, String texte) {
    // 1) id1 + id2
    String ref = getMessageRef(me.uid!, partenaire.uid!);
    String date = DateTime.now().millisecondsSinceEpoch.toString();
    Map map = {
      "from": me.uid,
      "to": partenaire.uid,
      "text": texte,
      "dateString": date
    };
    basemessage.child(ref).child(date).set(map);

    //Notification de dernier message de conversation.
  }

  getMessageRef(String from, String to) {
    List<String> list = [from, to];
    list.sort((a, b) => a.compareTo(b));
    String ref = "";
    for (var x in list) {
      ref += x + "+";
    }
    return ref;
  }

  // Storage

  static final entryStorage = FirebaseStorage.instance.ref('users/imageUrl');
  final entryUser = entryStorage;

  Future<String> savePic(File file, Reference reference) async {
    UploadTask task = reference.putFile(file);
    TaskSnapshot snap = await task;
    String url = await snap.ref.getDownloadURL();
    return url;
  }
}
