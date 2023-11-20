
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'login.dart';

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

class Info extends StatefulWidget {
  @override
  _Info createState() => _Info();
}
class _Info extends State<Info> {
  @override
  final user_name = TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;
  bool _isObscure3 = true;
  late String _userName = '';
  late String _newPass = '';
  var fireDocs = '';
  void fire_get() async {
    
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
  void fire_doc() async {
  var fireDoc = '';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //firebase上のコレクションへのアクセス(変数名を _users にしているが、自由に決める)
  await _firestore.collection('SHIFT_USER').get().then(
        (QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach(
            (doc) {
              fireDoc = doc.id;
            },
          ),
        },
      );
      setState(() {
        fireDocs = fireDoc;
      });
  
  
  }
  void fire_up() async {
    
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  fire_doc();
  user_name.text = '{$fireDocs}';
  //firebase上のコレクションへのアクセス(変数名を _users にしているが、自由に決める)
  // await _firestore.collection('SHIFT_USER').doc('{$fireDoc}').update({'user_name' : _userName});
  
  
  
  }
  @override 
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('ユーザー情報変更'),

      ),
      body:Center(
        child:SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child:ElevatedButton(onPressed: fire_get, child: Text('名前を表示する')),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child:
          TextFormField(
                decoration: InputDecoration(
                  labelText: '名前を入力',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                 
                ),
                 controller: user_name,
                onChanged: (value){
                            setState(() {
                              
                              _userName = value;
                    });
                  }
          ),),
          Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child:
           TextFormField(
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                       border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                      labelText: '現在のパスワードを入力',
                      suffixIcon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              
                              _isObscure = !_isObscure;
                                                         
                            });
                              
                          }
                          ),
                          
                          ),
                          
                ),),
         Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child:
           TextFormField(
                  obscureText: _isObscure2,
                  decoration: InputDecoration(
                       border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                      labelText: '新しいパスワードを入力',
                      suffixIcon: IconButton(
                          icon: Icon(_isObscure2
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              
                              _isObscure2 = !_isObscure2;
                                                         
                            });
                              
                          }
                          
                          ),
                           
                          ),
                           onChanged: (value){
                            setState(() {
                              
                              _newPass = value;
                    });
                  }
                          
                ),),
                Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child:
           TextFormField(
                  obscureText: _isObscure3,
                  decoration: InputDecoration(
                       border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                      labelText: '再入力',
                      suffixIcon: IconButton(
                          icon: Icon(_isObscure3
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              
                              _isObscure3 = !_isObscure3;
                                                         
                            });
                              
                          }
                          ),
                          
                          ),
                          
                          
                ),),
          Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                
                            child:ElevatedButton(onPressed: fire_up, child: Text('変更する')),
                       
           ),
          
          ])
          ,),
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
