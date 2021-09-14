import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/contactController.dart';
import 'package:flutter_application_1/controller/messagesController.dart';
import 'package:flutter_application_1/controller/profileController.dart';
import 'package:flutter_application_1/model/FirebaseHelper.dart';

class MainAppController extends StatelessWidget {
  User user = FirebaseHelper().auth.currentUser!;

  @override
  Widget build(BuildContext context) {
    final current = Theme.of(context).platform;
    if (current == TargetPlatform.iOS) {
      // Pour ce projet je vais faire que la partie Android
    } else {
      return DefaultTabController(
          length: 3,
          child: Scaffold(
              appBar: AppBar(
                title: Text("MaygWawal"),
                bottom: TabBar(tabs: [
                  Tab(
                    icon: Icon(Icons.message),
                  ),
                  Tab(
                    icon: Icon(Icons.supervisor_account),
                  ),
                  Tab(
                    icon: Icon(Icons.account_circle),
                  )
                ]),
              ),
              body: TabBarView(
                children: controllers(),
              )));
    }
    return ProfileController();
  }

  List<Widget> controllers() {
    return [MessagesController(), ContactController(), ProfileController()];
  }
}
