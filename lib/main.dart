import 'package:flutter/material.dart';
import 'package:ivypodsapp/screens/start_sreen.dart';
import 'package:ivypodsapp/utils/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IVYPODS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StartScreen(
        auth: Auth(),
      ),
    );
  }
}
