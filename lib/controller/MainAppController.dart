import 'package:flutter/material.dart';

class MainAppController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
      ),
      body: Center(
        child: Text("Nous somme connectés"),
      ),
    );
  }
}
