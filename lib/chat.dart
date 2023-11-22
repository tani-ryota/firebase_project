import 'package:firebase_project/setting.dart';
import 'package:flutter/material.dart';

import 'shift/main_page/shift_mainpage.dart';

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
        '/Shift': (context) => shift(),
        '/Setting': (context) => Setting(),
      },
    );
  }
}

class Group extends StatelessWidget {
  const Group({super.key});

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
