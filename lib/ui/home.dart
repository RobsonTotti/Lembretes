import 'package:flutter/material.dart';
import 'lembretes_tela.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lembretes"),
        backgroundColor: Colors.black54,
      ),

      body: LembretesTela(),
    );
  }
}
