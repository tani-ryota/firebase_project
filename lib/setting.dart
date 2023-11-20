

import 'package:firebase_project/chat.dart';
import 'package:firebase_project/userInfo.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'shift.dart';

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 右上に表示される"debug"ラベルを消す
      debugShowCheckedModeBanner: false,
      title: '設定',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Settings(),
      routes: {
        '/Shift': (context) => Shift(),
        '/Chat': (context) => Chat(),
        '/UserInfo': (context) => userInfo(),
      },
    );
  }
}

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: Center(
         child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center( 
                
                child: ElevatedButton(
                            onPressed: ()async{
                              await Navigator.pushNamed(context , '/UserInfo');
                            },
                            child: Text('ユーザー情報変更'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(20),
                              textStyle: const TextStyle(fontSize: 15),
                              foregroundColor: Colors.black, // foreground
                              fixedSize: Size(400, 50),
                              alignment: Alignment.center,
                            )),
              ),
              Center(
                
                child: ElevatedButton(
                            onPressed: (){
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                 
                                    title: Text("ログアウト"),
                                    content: Text("ログアウトします"),
                                    actions: <Widget>[
                                      // ボタン領域
                                      TextButton( 
                                        child: Text("Cancel"),
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                        ),
                                        onPressed: () =>
                                          Navigator.pop<String>(context,'Cancel')
                                           
                                      ),
                                      TextButton(
                                        child: Text("OK"),
                                        onPressed: (){  
                                          FirebaseAuth.instance.signOut();

                                          Navigator.pushNamed(context, '/Login');
                                        }
                                      ),
                                    ],
                                  
                                )
                              );
                              
                            },
                            child: Text("ログアウト"),
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 15),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white, // foreground
                              fixedSize: Size(400, 50),
                              alignment: Alignment.center,
                            )),
              )
            ]
          )
         )
      
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
