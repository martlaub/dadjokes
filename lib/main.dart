import 'package:flutter/material.dart';
import 'newMainPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dad Jokes',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: NewMainPage(title: 'Dad Jokes'),
    );
  }
}
