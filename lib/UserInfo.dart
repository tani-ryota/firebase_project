
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';


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
  
  final user_name = TextEditingController();
  bool _isObscure = true;

  void fire() async {
    
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //firebase上のコレクションへのアクセス(変数名を _users にしているが、自由に決める)
  final _users =  await _firestore.collection('SHIFT_USER').get();
  var msg = '';
 _users.docChanges.forEach((element) {
  final name = element.doc.get('user_name');
  final id = element.doc.get('user_id');
  final wage = element.doc.get('hourly_wage');
  msg += "${name}";
 });
  
  user_name.text = msg;
  }
  @override 
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('ユーザー情報変更'),

      ),
      body:Center(
        child:Column(
          children: <Widget>[
            
          ElevatedButton(onPressed: fire, child: Text('名前を表示する')),
           
          TextFormField(
                decoration: InputDecoration(
                  
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                 
                ),
                 controller: user_name
          ),
          
          TextFormField(
                decoration: InputDecoration(
                  
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                 
                ),
                 controller: user_name
          ),
          TextFormField(
                decoration: InputDecoration(
                  
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                 
                ),
                 controller: user_name
          ),
          
          
            
          ],),
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
