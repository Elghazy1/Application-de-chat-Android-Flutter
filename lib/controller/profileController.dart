import 'dart:ffi';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/FirebaseHelper.dart';
import 'package:flutter_application_1/model/MyUser.dart';
import 'package:flutter_application_1/widgets/customimage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends StatefulWidget {
  ProfileControllerState createState() => ProfileControllerState();
}

class ProfileControllerState extends State<ProfileController> {
  MyUser? me;
  String? prenom;
  String? nom;

  User user = FirebaseHelper().auth.currentUser!;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (me == null)
        ? Center(
            child: Text("Chargement..."),
          )
        : SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CustomImage(me?.imageUrl, me?.initiales,
                      MediaQuery.of(context).size.width / 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            _takeApic(ImageSource.camera);
                          },
                          icon: Icon(Icons.camera_enhance)),
                      IconButton(
                          onPressed: () {
                            _takeApic(ImageSource.gallery);
                          },
                          icon: Icon(Icons.photo_library)),
                    ],
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: me?.prenom),
                    onChanged: (str) {
                      setState(() {
                        prenom = str;
                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: me?.nom),
                    onChanged: (str) {
                      setState(() {
                        nom = str;
                      });
                    },
                  ),
                  ElevatedButton(
                      child: Text('Sauvegarder'), onPressed: saveChanges),
                  TextButton(onPressed: logOut, child: Text("Déconnexion"))
                ],
              ),
            ),
          );
  }

  Future<Void?> logOut() async {
    Text title = Text("Se déconnecter");
    Text content = Text("Êtes vous sûr de vouloir déconnecter ?");

    TextButton noBtn = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("Non"));

    TextButton yesBtn = TextButton(
        onPressed: () {
          FirebaseHelper().handleLogOut().then((bool) {
            Navigator.of(context).pop();
          });
        },
        child: Text("Oui"));
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (
          BuildContext ctx,
        ) {
          return (Theme.of(context).platform == TargetPlatform.iOS)
              ? CupertinoAlertDialog(
                  title: title,
                  content: content,
                  actions: <Widget>[
                    yesBtn,
                    noBtn,
                  ],
                )
              : AlertDialog(
                  title: title,
                  content: content,
                  actions: <Widget>[
                    yesBtn,
                    noBtn,
                  ],
                );
        });
  }

  saveChanges() {
    Map map = me!.toMap();
    if (prenom != null && prenom != "") {
      map["prenom"] = prenom;
    }
    if (nom != null && nom != "") {
      map["nom"] = nom;
    }
    FirebaseHelper().addUser(me!.uid!, map);
    _getUser();
  }

  _getUser() {
    FirebaseHelper().getUser(user.uid).then((me) {
      setState(() {
        this.me = me;
      });
    });
  }

  Future<void> _takeApic(ImageSource source) async {
    XFile? img = await ImagePicker()
        .pickImage(source: source, maxHeight: 500, maxWidth: 500);
    if (img != null) {
      File file = File(img.path);
      FirebaseHelper()
          .savePic(file, FirebaseHelper().entryUser.child(me!.uid!))
          .then((str) {
        // Add user
        Map map = me!.toMap();
        map["imageUrl"] = str;
        FirebaseHelper().addUser(me!.uid!, map);
        _getUser();
      });
    }
  }
}
