import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/FirebaseHelper.dart';
import 'package:flutter_application_1/model/Messages.dart';
import 'package:flutter_application_1/model/MyUser.dart';
import 'package:flutter_application_1/widgets/ZoneDeText.dart';
import 'package:flutter_application_1/widgets/customimage.dart';

class ChatController extends StatefulWidget {
  MyUser partenaire;

  ChatController(this.partenaire);

  ChatControllerState createState() => ChatControllerState();
}

class ChatControllerState extends State<ChatController> {
  MyUser? me;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String uid = FirebaseHelper().auth.currentUser!.uid;
    FirebaseHelper().getUser(uid).then((user) {
      setState(() {
        this.me = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomImage(
                widget.partenaire.imageUrl, widget.partenaire.initiales, 25),
            Text(widget.partenaire.fullName()),
          ],
        ),
        //title: Text(widget.partenaire.fullName()),
      ),
      body: InkWell(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Column(
          children: <Widget>[
            Flexible(
                child: (me != null)
                    ? FirebaseAnimatedList(
                        query: FirebaseHelper().basemessage.child(
                            FirebaseHelper().getMessageRef(
                                me!.uid!, widget.partenaire.uid!)),
                        sort: (a, b) => b.key!.compareTo(a.key!),
                        reverse: true,
                        itemBuilder: (BuildContext ctx, DataSnapshot snap,
                            Animation<double> animation, int index) {
                          Message msg = Message(snap);
                          return ListTile(
                            title: Text(msg.text!),
                          );
                        })
                    : Center(
                        child: Text("Chargement.."),
                      )),
            Divider(height: 2),
            ZoneDeTexte(widget.partenaire, this.me!)
          ],
        ),
      ),
    );
  }
}
