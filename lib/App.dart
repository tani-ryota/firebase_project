import 'package:flutter/material.dart';
import 'package:firebase_project/login.dart';
import 'chat.dart';
import 'shift.dart';
import 'setting.dart';
import 'UserInfo.dart'; 
import 'package:firebase_auth/firebase_auth.dart';


class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'でていけ',
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // スプラッシュ画面などに書き換えても良い
              return const SizedBox();
            }
            if (snapshot.hasData) {
              // User が null でなない、つまりサインイン済みのホーム画面へ
              return Shift();
            }
            // User が null である、つまり未サインインのサインイン画面へ
            return LoginPage();
          },
        ),
      routes: {
        '/Login': (context) => LoginPage(),
        '/Shift': (context) => Shift(),
        '/Chat': (context) => Chat(),
        '/Setting': (context) => Setting(),
        '/UserInfo' : (context) => userInfo()
      },
    );
  }
}
