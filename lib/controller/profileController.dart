import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/FirebaseHelper.dart';

class ProfileController extends StatefulWidget {
  ProfileControllerState createState() => ProfileControllerState();
}

class ProfileControllerState extends State<ProfileController> {
  User user = FirebaseHelper().auth.currentUser!;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Text("Profile: ${user.uid}"),
    );
  }
}
