import 'dart:ffi';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/FirebaseHelper.dart';
import 'package:flutter_application_1/model/MyUser.dart';
import 'package:image_picker/image_picker.dart';

class ZoneDeTexte extends StatefulWidget {
  MyUser partenaire;
  MyUser? me;

  ZoneDeTexte(this.partenaire, this.me);

  ZoneState createState() => ZoneState();
}

class ZoneState extends State<ZoneDeTexte> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.all(3.5),
      child: Row(
        children: <Widget>[
          IconButton(
              onPressed: () => takePic(ImageSource.camera),
              icon: Icon(Icons.camera_enhance)),
          IconButton(
              onPressed: () => takePic(ImageSource.gallery),
              icon: Icon(Icons.photo_library)),
          Flexible(
              child: TextField(
            controller: _controller,
            decoration:
                InputDecoration.collapsed(hintText: "Ecrivez votre message"),
            maxLines: null,
          )),
          IconButton(
              onPressed: () => _sendButtonPressed(), icon: Icon(Icons.send))
        ],
      ),
    );
  }

  _sendButtonPressed() {
    if (_controller.text != "") {
      String text = _controller.text;
      // 1) Envoyer sur firebase
      FirebaseHelper().sendMessage(widget.me!, widget.partenaire, text, "");
      // 2) Clear text
      _controller.clear();
      // 3) Fermer
      FocusScope.of(context).requestFocus(FocusNode());
    } else {
      print("Text vide !");
    }
  }

  Future<void> takePic(ImageSource source) async {
    XFile? picked = await ImagePicker()
        .pickImage(source: source, maxWidth: 1000, maxHeight: 1000);
    if (picked != null) {
      File file = File(picked.path);
      String date = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref =
          FirebaseHelper().entryMessage.child(widget.me!.uid!).child(date);
      FirebaseHelper().savePic(file, ref).then((imageUrl) {
        FirebaseHelper()
            .sendMessage(widget.me!, widget.partenaire, "", imageUrl);
      });
    }
  }
}
