import 'package:flutter/material.dart';
import 'ui/home.dart';

void main() => runApp(new Lembretes());

class Lembretes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lembretes',
      home: Home(),
    );
  }
}
