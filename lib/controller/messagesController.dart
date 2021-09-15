import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/ChatController.dart';
import 'package:flutter_application_1/model/Conversation.dart';
import 'package:flutter_application_1/model/DateHelper.dart';
import 'package:flutter_application_1/model/FirebaseHelper.dart';
import 'package:flutter_application_1/widgets/customimage.dart';

class MessagesController extends StatefulWidget {
  MessagesControllerState createState() => MessagesControllerState();
}

class MessagesControllerState extends State<MessagesController> {
  @override
  Widget build(BuildContext context) {
    String uid = FirebaseHelper().auth.currentUser!.uid;
    // TODO: implement build
    return FirebaseAnimatedList(
        query: FirebaseHelper().baseconversation.child(uid),
        itemBuilder: (BuildContext ctx, DataSnapshot snap,
            Animation<double> anim, int index) {
          Conversation conversation = Conversation(snap);
          String sub = (conversation.uid == uid) ? "Moi :" : "";
          sub += ("${conversation.msg}");
          return ListTile(
            leading: CustomImage(
                conversation.user!.imageUrl, conversation.user!.initiales, 20),
            title: Text(conversation.user!.fullName()),
            subtitle: Text(sub),
            trailing: Text(DateHelper().convert(conversation.date!)),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext ctx) {
                return ChatController(conversation.user!);
              }));
            },
          );
        });
  }
}
