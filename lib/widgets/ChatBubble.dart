import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/DateHelper.dart';
import 'package:flutter_application_1/model/FirebaseHelper.dart';
import 'package:flutter_application_1/model/Messages.dart';
import 'package:flutter_application_1/model/MyUser.dart';
import 'package:flutter_application_1/widgets/customimage.dart';

class ChatBubble extends StatelessWidget {
  Message? message;
  MyUser? partenaire;
  Animation<double> animation;
  String myId = FirebaseHelper().auth.currentUser!.uid;

  ChatBubble(this.message, this.partenaire, this.animation);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeIn),
      child: Container(
        margin: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: bubble(myId == message!.from),
        ),
      ),
    );
  }

  List<Widget> bubble(bool moi) {
    CrossAxisAlignment alignment =
        (moi) ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    Color color = (moi) ? Colors.blue.shade100 : Colors.green.shade100;
    return <Widget>[
      (moi)
          ? Padding(padding: EdgeInsets.all(5))
          : CustomImage(partenaire!.imageUrl, partenaire!.initiales, 15),
      Expanded(
          child: Column(
        crossAxisAlignment: alignment,
        children: <Widget>[
          Text(DateHelper().convert(message!.dateString!)),
          Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: color,
            child: Container(
              padding: EdgeInsets.all((message!.imageUrl != "") ? 0 : 10),
              child: (message?.imageUrl == "")
                  ? Text(message!.text!)
                  : CustomImage(message!.imageUrl, "", null),
            ),
          ),
        ],
      ))
    ];
  }
}
