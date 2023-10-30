import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

import 'main.dart';
import 'login.dart';
import 'shift.dart';

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 右上に表示される"debug"ラベルを消す
      debugShowCheckedModeBanner: false,
      title: 'チャット',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Group(),
      routes: {
        '/Shift': (context) => Shift(),
      },
    );
  }
}

class Group extends StatelessWidget {
  const Group({super.key});
  static var _value;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('グループチャット'),
      ),
      body: const Center(
        child: Text(
          '',
          style: TextStyle(fontSize: 32.0),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              label: 'シフト',
              icon: Icon(Icons.home),
              backgroundColor: Colors.blueAccent),
          BottomNavigationBarItem(
            label: 'チャット',
            icon: Icon(Icons.location_city),
          ),
        ],
        onTap: (int value) {
          if (value == 0) {
            Navigator.pushNamed(context, '/Shift');
          } else if (value == 1) {
            Navigator.pushNamed(context, '/Chat');
          }
        },
      ),
    );
  }
}
