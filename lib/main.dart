// import 'package:firebase_project/App.dart';



import 'Create_shift.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'shift/main_page/shift_mainpage.dart';

final textProvider = StateProvider.autoDispose((ref) {
  return TextEditingController(text: '');
});
// 数値を入れるプロバイダー
final doubleProvider = StateProvider.autoDispose((ref) {
  return TextEditingController(text: '');
});
// FireStoreの'arrays'コレクションのすべてのドキュメントを取得するプロバイダー。初回に全件分、あとは変更があるたびStreamに通知される。


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  runApp(
    const  ProviderScope(child: MyApp()),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    
// currentUser が null であればログインしていません。
    if (FirebaseAuth.instance.currentUser == null) {
      // 未ログイン
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        home: const SignInPage(),
      );
    } else {
      // ログイン中
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        home:   isLogin(),
        
      );
    }
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  Future<void> signInWithGoogle() async {
    final googleUser =
        await GoogleSignIn(scopes: ['profile', 'email']).signIn();

    final googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログイン'),
        backgroundColor: (const Color.fromARGB(255, 255, 155, 147)),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('GoogleSignIn'),
          onPressed: () async {
            await signInWithGoogle();
            print(FirebaseAuth.instance.currentUser?.displayName);
            if (mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) {
                  if(FirebaseAuth.instance.currentUser?.displayName == 'Admin'){
                  return  create_shift();
                  }else{
                  return  isLogin();
                  }
                }),
                (route) => false,
              );
            }
          },
        ),
      ),
    );
  }


}

