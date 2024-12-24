import 'package:flutter/material.dart';
import 'package:ats/bottom_navbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UTS',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BottomNavbar(),
    );
  }
}