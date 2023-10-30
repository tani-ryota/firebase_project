import 'package:flutter/material.dart';
import 'package:firebase_project/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat.dart';
import 'shift.dart';
import 'login.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'でていけ',
      initialRoute: '/Login',
      routes: {
        '/Login': (context) => LoginPage(),
        '/Shift': (context) => Shift(),
        '/Chat': (context) => Chat(),
      },
    );
  }
}
