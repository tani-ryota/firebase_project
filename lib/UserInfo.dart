import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_project/chat.dart';
import 'package:firebase_project/setting.dart';
import 'package:flutter/material.dart';
import 'shift.dart';

class userInfo extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 右上に表示される"debug"ラベルを消す
      debugShowCheckedModeBanner: false,
      title: 'ユーザー情報変更',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Info(),
      routes: {
        '/Shift': (context) => Shift(),
        '/Setting': (context) => Setting(),
        '/Chat': (context) => Chat(),
      },
    );
  }
}

class Info extends StatelessWidget {
  Info({super.key});
    //Firestoreインスタンスの作成と代入 
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //firebase上のコレクションへのアクセス(変数名を _users にしているが、自由に決める)
  static final CollectionReference _users = _firestore.collection('SHIFT_USER');
  final Stream<QuerySnapshot> _user_nameStream = _users.where('name', isEqualTo: 'user_name').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ユーザー情報変更'),

      ),
      body:TextField(
          decoration: InputDecoration(
            labelText: '名前',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ElevatedButton(child: null,)
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
            icon: Icon(Icons.chat),
          ),
          BottomNavigationBarItem(
            label: '設定',
            icon: Icon(Icons.settings),
          ),
        ],
        onTap: (int value) {
          if (value == 0) {
            Navigator.pushNamed(context, '/Shift');
          } else if (value == 1) {
            Navigator.pushNamed(context, '/Chat');
          } else if (value == 2) {
            Navigator.pushNamed(context, '/Setting');
          }
        },
      ),
    );
  }
}
