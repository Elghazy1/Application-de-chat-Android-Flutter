import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/model/MyUser.dart';

class Conversation {
  MyUser? user;
  String? date;
  String? msg;
  String? uid;

  Conversation(DataSnapshot snap) {
    Map m = snap.value;
    user = MyUser(snap);
    date = m["dateString"];
    msg = m["lastMessage"];
    uid = m["monId"];
  }
}
