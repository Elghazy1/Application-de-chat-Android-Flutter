import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/FirebaseHelper.dart';

class LogController extends StatefulWidget {
  LogControllerState createState() => LogControllerState();
}

class LogControllerState extends State<LogController> {
  bool _log = true;
  String? _adresseMail;
  String? _password;
  String? _prenom;
  String? _nom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentification"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 40,
              height: MediaQuery.of(context).size.height / 2,
              child: Card(
                elevation: 7.5,
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: textfields(),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _log = !_log;
                });
              },
              child: Text((_log) ? "Authentification" : "Création de compte"),
            ),
            ElevatedButton(
              onPressed: _handleLog,
              child: Text("Go"),
            )
          ],
        ),
      ),
    );
  }

  _handleLog() {
    if (_adresseMail != "") {
      if (_password != "") {
        if (_log) {
          //Connexion
          FirebaseHelper()
              .handleSigneIn(_adresseMail!, _password!)
              .then((user) {
            print(user.uid);
          }).catchError((error) {
            alerte(error.toString());
          });
        } else {
          //Création de compte
          if (_prenom != "") {
            if (_nom != "") {
              // methode pour créer utilisateur
              FirebaseHelper()
                  .create(_adresseMail!, _password!, _prenom!, _nom!)
                  .then((user) {
                print(user.uid);
              }).catchError((error) {
                alerte(error.toString());
              });
            } else {
              //Alert pas de nom
              alerte("Aucune nom n'a été renseignée !");
            }
          } else {
            //Alert pas de prénom
            alerte("Aucune prénom n'a été renseignée !");
          }
        }
      } else {
        //alert pas de mdp
        alerte("Aucune mot de passe n'a été renseignée !");
      }
    } else {
      //alert pas de mail
      alerte("Aucune adresse mail n'a été renseignée !");
    }
  }

  List<Widget> textfields() {
    List<Widget> widgets = [];
    widgets.add(TextField(
      decoration: InputDecoration(hintText: "Adresse mail"),
      onChanged: (string) {
        setState(() {
          _adresseMail = string;
        });
      },
    ));

    widgets.add(TextField(
      decoration: InputDecoration(hintText: "Password"),
      obscureText: true,
      onChanged: (string) {
        setState(() {
          _password = string;
        });
      },
    ));

    if (!_log) {
      widgets.add(TextField(
        decoration: InputDecoration(hintText: "Prenom"),
        onChanged: (string) {
          setState(() {
            _prenom = string;
          });
        },
      ));

      widgets.add(TextField(
        decoration: InputDecoration(hintText: "Nom"),
        onChanged: (string) {
          setState(() {
            _nom = string;
          });
        },
      ));
    }
    return widgets;
  }

  Future<void> alerte(String message) async {
    Text title = Text("Erreur");
    Text msg = Text(message);
    TextButton okButton = TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Text("Ok"),
    );
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return (Theme.of(context).platform == TargetPlatform.iOS)
              ? CupertinoAlertDialog(
                  title: title,
                  content: msg,
                  actions: <Widget>[okButton],
                )
              : AlertDialog(
                  title: title, content: msg, actions: <Widget>[okButton]);
        });
  }
}
