
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _email = '';
  late String _password = '';
  String infoText = 'ログイン';
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(infoText),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'ユーザー名を入力してください',                    
                  ),
                  onChanged: (value){
                    setState(() {
                      // _email = '';
                      _email = value;
                    });
                  }
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                      labelText: 'Password',
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
                          onChanged: (value){
                            setState(() {
                              // _password = '';
                              _password = value;
                    });
                  }
                ),
              ),
              Center(
                child: ElevatedButton(
                    onPressed:() async {
                       try {
      
                        await _auth.signInWithEmailAndPassword(
                          email: _email,
                          password: _password
                        );
                        await Navigator.pushNamed(context , '/Shift');
                       setState(() {
                         infoText = 'ログインに成功しました';
                       });
                       
                        
                  }  catch (e) {
                    setState(() {
                      infoText = 'ログインに失敗しました';
                    });
                    }   
                    },
                    child: Text('ログイン')),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
 
}
