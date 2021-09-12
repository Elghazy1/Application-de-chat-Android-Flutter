import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/FirebaseHelper.dart';
import 'package:flutter_application_1/model/MyUser.dart';
import 'package:flutter_application_1/widgets/customimage.dart';

class ContactController extends StatefulWidget {
  ContactControllerState createState() => ContactControllerState();
}

class ContactControllerState extends State<ContactController> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FirebaseAnimatedList(
        query: FirebaseHelper().baseuser,
        sort: (a, b) => (a.value["prenom"].toString().toLowerCase())
            .compareTo(b.value["prenom"].toString().toLowerCase()),
        itemBuilder: (BuildContext ctx, DataSnapshot snap,
            Animation<double> animation, int index) {
          MyUser newUser = MyUser(snap);
          if (FirebaseHelper().auth.currentUser!.uid == newUser.uid) {
            return Container();
          } else {
            return ListTile(
              leading: CustomImage(newUser.imageUrl, newUser.initiales, 20),
              title: Text("${newUser.prenom} ${newUser.nom}"),
              trailing: IconButton(
                icon: Icon(Icons.message),
                onPressed: () {},
              ),
            );
          }
        });
  }
}
